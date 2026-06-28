import 'package:flutter/material.dart';

import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/call/call_controller.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/call/call_controls.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/call/participant_tile.dart';



/// شاشة المدرس للمكالمة الصوتية الجماعية.
///
/// مثال الفتح:
/// ```dart
/// Navigator.push(context, MaterialPageRoute(
///   builder: (_) => CallScreen(
///     roomName: lesson.title,
///     classId: '8',
///     teacherRepo: teacherRepo, // نفس الـ Repo المستخدم في الكيوبت
///   ),
/// ));
/// ```
class CallScreen extends StatefulWidget {
  const CallScreen({
    super.key,
    required this.roomName,
    required this.classId,
    required this.teacherRepo,
    this.title,
    this.teacherName = 'المدرس',
    this.demoMode = false,
  });

  /// معرّف الغرفة المُرسل للـ API (مثلاً class-2).
  final String roomName;

  /// العنوان المعروض في الأعلى (اسم الشعبة). إن لم يُمرّر يُستخدم roomName.
  final String? title;

  final String classId;
  final TeacherRepo teacherRepo;
  final String teacherName;

  /// true لمعاينة الواجهة بدون باك إند.
  final bool demoMode;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late final CallController _controller;

  static const Color _bg = Color(0xFF0A1422);

  @override
  void initState() {
    super.initState();
    _controller = CallController(
      roomName: widget.roomName,
      classId: widget.classId,
      teacherRepo: widget.teacherRepo,
      teacherName: widget.teacherName,
      demoMode: widget.demoMode,
    );
    _controller.connect();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _endCall() async {
    await _controller.endCall();
    if (mounted) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          centerTitle: false,
          title: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title ?? widget.roomName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _statusLine(),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.state == CallConnectionState.connecting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFC8F526)),
              );
            }
            if (_controller.state == CallConnectionState.error) {
              return _ErrorView(
                message: _controller.errorMessage ?? 'حدث خطأ',
                onRetry: () => _controller.connect(),
              );
            }

            final participants = _controller.participants;
            return Column(
              children: [
                Expanded(
                  child: participants.isEmpty
                      ? const Center(
                          child: Text(
                            'بانتظار انضمام الطلاب…',
                            style: TextStyle(color: Colors.white54),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.82,
                          ),
                          itemCount: participants.length,
                          itemBuilder: (context, i) {
                            final p = participants[i];
                            final canModerate = !p.isLocal;
                            return ParticipantTile(
                              participant: p,
                              showModeration: canModerate,
                              onToggleMute: () =>
                                  _controller.toggleMuteStudent(p.id),
                              onKick: () => _controller.kickStudent(p.id),
                            );
                          },
                        ),
                ),
                CallControls(
                  selfMicEnabled: _controller.selfMicEnabled,
                  allStudentsMuted: _controller.allStudentsMuted,
                  onEndCall: _endCall,
                  onToggleSelfMic: _controller.toggleSelfMic,
                  onToggleMuteAll: _controller.toggleMuteAllStudents,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _statusLine() {
    final base = _stateLabel(_controller.state);
    if (_controller.state != CallConnectionState.connected) return base;
    final students = _controller.participants.where((p) => !p.isTeacher);
    final total = students.length;
    if (total == 0) return base;
    final joined = students.where((p) => p.isPresent).length;
    return '$base · متصل $joined من $total';
  }

  String _stateLabel(CallConnectionState s) {
    switch (s) {
      case CallConnectionState.connecting:
        return 'جارٍ بدء المكالمة…';
      case CallConnectionState.connected:
        return 'المكالمة جارية';
      case CallConnectionState.reconnecting:
        return 'إعادة الاتصال…';
      case CallConnectionState.disconnected:
        return 'انتهت المكالمة';
      case CallConnectionState.error:
        return 'خطأ في الاتصال';
      case CallConnectionState.idle:
        return '';
    }
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white54, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC8F526),
                foregroundColor: Colors.black,
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}