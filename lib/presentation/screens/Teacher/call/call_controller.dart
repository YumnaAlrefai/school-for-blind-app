import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/call/call_models.dart';


/// إعدادات LiveKit. الرابط الأساسي لـ API يُدار من Retrofit (@RestApi baseUrl).
class LiveKitConfig {
  /// عنوان سيرفر LiveKit (WebSocket) لمشروع school-for-blind.
  /// نستخدم بادئة wss:// (وليس https://) للاتصال من العميل.
  static const String url = 'wss://school-for-blind-i8afqt3h.livekit.cloud';
}

enum CallConnectionState {
  idle,
  connecting,
  connected,
  reconnecting,
  disconnected,
  error,
}

/// خطأ مكالمة برسالة عربية جاهزة للعرض.
class CallException implements Exception {
  CallException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// متحكّم شاشة المدرس. يبدأ الدرس عبر TeacherRepo، يتصل بـ LiveKit،
/// ويتحكّم بالكتم/الطرد/الإنهاء. التوكن يُضاف تلقائياً من Dio interceptor.
///
/// مبني على [ChangeNotifier] (مناسب للتحديث اللحظي من LiveKit)، ويستعمل
/// نفس طبقة الشبكة عندك (Retrofit + Repo) لكل نداءات الـ API.
///
/// تنبيه: مكتوب لإصدار livekit_client ^2.x.
class CallController extends ChangeNotifier {
  CallController({
    required this.roomName,
    required this.classId,
    required this.teacherRepo,
    this.teacherName = 'المدرس',
    this.demoMode = false,
  });

  final String roomName;
  final String classId;
  final TeacherRepo teacherRepo;
  final String teacherName;
  final bool demoMode;

  // ===================== الحالة =====================
  CallConnectionState _state = CallConnectionState.idle;
  CallConnectionState get state => _state;

  bool _selfMicEnabled = true;
  bool get selfMicEnabled => _selfMicEnabled;

  bool _allStudentsMuted = false;
  bool get allStudentsMuted => _allStudentsMuted;

  String? errorMessage;

  final List<CallParticipant> _participants = [];
  List<CallParticipant> get participants => List.unmodifiable(_participants);

  /// طلاب الشعبة المُبلّغون (الـ roster).
  final List<RosterStudent> _roster = [];

  // LiveKit
  Room? _room;
  EventsListener<RoomEvent>? _events;

  // الوضع التجريبي فقط
  Timer? _demoTimer;
  final Random _rand = Random();

  // ===================== 1) بدء المكالمة =====================
  Future<void> connect() async {
    _setState(CallConnectionState.connecting);
    try {
      if (demoMode) {
        _loadDemoParticipants();
        _startDemoSpeaking();
        _setState(CallConnectionState.connected);
        return;
      }

      // 1) بدء الدرس عبر الـ Repo (يرجّع توكن LiveKit + الطلاب)
      final data = _unwrap(
        await teacherRepo.startCall(roomName: roomName, classId: classId),
      );
      final token = data['token']?.toString() ?? '';
      if (token.isEmpty) {
        throw CallException('لم يصل توكن LiveKit من الخادم');
      }
      _roster
        ..clear()
        ..addAll(_parseStudents(data['students']));

      // 2) الاتصال بغرفة LiveKit
      final room = Room();
      _room = room;
      await room.connect(LiveKitConfig.url, token);
      await room.localParticipant?.setMicrophoneEnabled(true);
      _selfMicEnabled = true;

      // 3) الاستماع للأحداث
      _bindRoomEvents(room);
      _syncFromRoom();

      _setState(CallConnectionState.connected);
    } on CallException catch (e) {
      errorMessage = e.message;
      _setState(CallConnectionState.error);
    } catch (e) {
      errorMessage = 'تعذّر الاتصال بالمكالمة';
      if (kDebugMode) debugPrint('Call connect error: $e');
      _setState(CallConnectionState.error);
    }
  }

  void _bindRoomEvents(Room room) {
    room.addListener(_syncFromRoom);
    _events = room.createListener()
      ..on<RoomDisconnectedEvent>((_) {
        _setState(CallConnectionState.disconnected);
      })
      ..on<ActiveSpeakersChangedEvent>((_) => _syncFromRoom())
      ..on<TrackMutedEvent>((_) => _syncFromRoom())
      ..on<TrackUnmutedEvent>((_) => _syncFromRoom())
      ..on<ParticipantConnectedEvent>((_) => _syncFromRoom())
      ..on<ParticipantDisconnectedEvent>((_) => _syncFromRoom());
  }

  // ===================== أزرار التحكّم السفلية =====================
  Future<void> toggleSelfMic() async {
    _selfMicEnabled = !_selfMicEnabled;
    if (!demoMode) {
      await _room?.localParticipant?.setMicrophoneEnabled(_selfMicEnabled);
    }
    final meIdx = _participants.indexWhere((p) => p.isLocal);
    if (meIdx != -1) {
      _participants[meIdx] = _participants[meIdx]
          .copyWith(isMicEnabled: _selfMicEnabled, isSpeaking: false);
    }
    notifyListeners();
  }

  /// كتم/فك كتم كل الطلاب (لا يوجد endpoint جماعي، فنكرّر على كل طالب).
  Future<void> toggleMuteAllStudents() async {
    final mute = !_allStudentsMuted;
    _allStudentsMuted = mute;

    if (demoMode) {
      for (var i = 0; i < _participants.length; i++) {
        final p = _participants[i];
        if (!p.isLocal && p.isPresent) {
          _participants[i] = p.copyWith(isMicEnabled: !mute, isSpeaking: false);
        }
      }
      notifyListeners();
      return;
    }

    notifyListeners();
    for (final p in _participants) {
      if (p.isLocal || !p.isPresent) continue;
      if (mute && !p.isMicEnabled) continue;
      if (!mute && p.isMicEnabled) continue;
      try {
        await _setStudentMuted(p, mute);
      } catch (e) {
        if (kDebugMode) debugPrint('mute all error for ${p.id}: $e');
      }
    }
  }

  // ===================== أزرار بطاقة كل طالب =====================
  Future<void> toggleMuteStudent(String id) async {
    final p = _participantById(id);
    if (p == null || !p.isPresent) return;
    try {
      await _setStudentMuted(p, p.isMicEnabled);
    } on CallException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    }
  }

  Future<void> _setStudentMuted(CallParticipant p, bool mute) async {
    final target = _parseIdentity(p.id);
    if (target == null) return;

    if (demoMode) {
      _updateParticipant(p.id, isMicEnabled: !mute, isSpeaking: false);
      return;
    }

    if (mute) {
      final trackSid = _audioTrackSid(p.id);
      if (trackSid == null) return;
      _unwrap(await teacherRepo.muteParticipant(
        roomName: roomName,
        targetId: target.id,
        targetType: target.type,
        trackSid: trackSid,
      ));
    } else {
      _unwrap(await teacherRepo.unmuteParticipant(
        roomName: roomName,
        targetId: target.id,
        targetType: target.type,
      ));
    }
    _updateParticipant(p.id, isMicEnabled: !mute, isSpeaking: false);
  }

  Future<void> kickStudent(String id) async {
    final target = _parseIdentity(id);
    if (target == null) return;
    try {
      if (!demoMode) {
        _unwrap(await teacherRepo.kickParticipant(
          roomName: roomName,
          targetId: target.id,
          targetType: target.type,
        ));
      }
      _roster.removeWhere((s) => 'Student--${s.id}' == id);
      _participants.removeWhere((p) => p.id == id);
      notifyListeners();
    } on CallException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    }
  }

  // ===================== إنهاء المكالمة =====================
  Future<void> endCall() async {
    _demoTimer?.cancel();
    try {
      if (!demoMode) {
        _unwrap(await teacherRepo.endCall(roomName: roomName));
      }
    } catch (e) {
      if (kDebugMode) debugPrint('end call error: $e');
    }
    await _room?.disconnect();
    _setState(CallConnectionState.disconnected);
  }

  // ===================== مزامنة حالة LiveKit =====================
  void _syncFromRoom() {
    final room = _room;
    if (room == null) return;

    final list = <CallParticipant>[];

    final lp = room.localParticipant;
    if (lp != null) {
      list.add(CallParticipant(
        id: lp.identity,
        name: lp.name.isNotEmpty ? lp.name : teacherName,
        isTeacher: true,
        isLocal: true,
        isPresent: true,
        isMicEnabled: _selfMicEnabled,
        isSpeaking: lp.isSpeaking,
        audioLevel: lp.audioLevel,
      ));
    }

    final remotesByIdentity = <String, RemoteParticipant>{
      for (final rp in room.remoteParticipants.values) rp.identity: rp,
    };
    final handled = <String>{};

    for (final s in _roster) {
      final identity = 'Student--${s.id}';
      handled.add(identity);
      final rp = remotesByIdentity[identity];
      if (rp != null) {
        final pub = rp.audioTrackPublications.isNotEmpty
            ? rp.audioTrackPublications.first
            : null;
        list.add(CallParticipant(
          id: identity,
          name: rp.name.isNotEmpty ? rp.name : s.name,
          isPresent: true,
          isMicEnabled: pub == null ? false : !pub.muted,
          isSpeaking: rp.isSpeaking,
          audioLevel: rp.audioLevel,
        ));
      } else {
        list.add(CallParticipant(
          id: identity,
          name: s.name,
          isPresent: false,
          isMicEnabled: false,
        ));
      }
    }

    for (final rp in room.remoteParticipants.values) {
      if (handled.contains(rp.identity)) continue;
      if (rp.identity == lp?.identity) continue;
      final pub = rp.audioTrackPublications.isNotEmpty
          ? rp.audioTrackPublications.first
          : null;
      list.add(CallParticipant(
        id: rp.identity,
        name: rp.name.isNotEmpty ? rp.name : rp.identity,
        isTeacher: _roleFromMetadata(rp.metadata) == 'Teacher',
        isPresent: true,
        isMicEnabled: pub == null ? false : !pub.muted,
        isSpeaking: rp.isSpeaking,
        audioLevel: rp.audioLevel,
      ));
    }

    _participants
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  // ===================== مساعدات =====================
  /// يفك ApiResult: يرجّع البيانات أو يرمي CallException برسالة الخادم.
  Map<String, dynamic> _unwrap(ApiResult<dynamic> result) {
    Map<String, dynamic> data = const {};
    String? message;
    result.when(
      success: (d) {
        if (d is Map) data = Map<String, dynamic>.from(d);
      },
      // ملاحظة: لو اختلف اسم الدالة في نسختك، بدّلها هنا فقط.
      failure: (e) => message = NetworkExceptions.getErrorMessage(e),
    );
    if (message != null) throw CallException(message!);
    return data;
  }

  List<RosterStudent> _parseStudents(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => RosterStudent.fromJson(Map<String, dynamic>.from(e)))
        .where((s) => s.id.isNotEmpty)
        .toList();
  }

  CallParticipant? _participantById(String id) {
    for (final p in _participants) {
      if (p.id == id) return p;
    }
    return null;
  }

  void _updateParticipant(String id, {bool? isMicEnabled, bool? isSpeaking}) {
    final idx = _participants.indexWhere((p) => p.id == id);
    if (idx == -1) return;
    _participants[idx] = _participants[idx]
        .copyWith(isMicEnabled: isMicEnabled, isSpeaking: isSpeaking);
    notifyListeners();
  }

  RemoteParticipant? _remoteByIdentity(String identity) {
    for (final p
        in _room?.remoteParticipants.values ?? const <RemoteParticipant>[]) {
      if (p.identity == identity) return p;
    }
    return null;
  }

  String? _audioTrackSid(String identity) {
    final rp = _remoteByIdentity(identity);
    if (rp == null || rp.audioTrackPublications.isEmpty) return null;
    return rp.audioTrackPublications.first.sid;
  }

  /// يحوّل "Student--15" إلى (type, id) لـ API لارافيل.
  ({String type, String id})? _parseIdentity(String identity) {
    final i = identity.indexOf('--');
    if (i <= 0) return null;
    final role = identity.substring(0, i);
    final id = identity.substring(i + 2);
    if (id.isEmpty) return null;
    return (type: 'App\\Models\\$role', id: id);
  }

  String? _roleFromMetadata(String? metadata) {
    if (metadata == null || metadata.isEmpty) return null;
    try {
      final m = jsonDecode(metadata);
      if (m is Map && m['role'] is String) return m['role'] as String;
    } catch (_) {}
    return null;
  }

  void _setState(CallConnectionState s) {
    _state = s;
    notifyListeners();
  }

  // ---------- الوضع التجريبي ----------
  void _loadDemoParticipants() {
    _participants
      ..clear()
      ..add(CallParticipant(
        id: 'Teacher--0',
        name: teacherName,
        isTeacher: true,
        isLocal: true,
      ));
    for (var i = 1; i <= 14; i++) {
      final joined = i <= 9;
      _participants.add(CallParticipant(
        id: 'Student--$i',
        name: 'طالب $i',
        isPresent: joined,
        isMicEnabled: joined,
      ));
    }
  }

  void _startDemoSpeaking() {
    _demoTimer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      for (var i = 0; i < _participants.length; i++) {
        final p = _participants[i];
        if (!p.isPresent) continue;
        final speaking = p.isMicEnabled && _rand.nextDouble() < 0.25;
        _participants[i] = p.copyWith(
          isSpeaking: speaking,
          audioLevel: speaking ? 0.4 + _rand.nextDouble() * 0.6 : 0,
        );
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _demoTimer?.cancel();
    _room?.removeListener(_syncFromRoom);
    _events?.dispose();
    _room?.dispose();
    super.dispose();
  }
}