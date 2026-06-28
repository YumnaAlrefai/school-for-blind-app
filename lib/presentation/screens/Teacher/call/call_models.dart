import 'package:flutter/foundation.dart';

/// يمثّل مشاركاً واحداً في المكالمة (معلّم أو طالب).
@immutable
class CallParticipant {
  /// هوية المشارك في LiveKit، بصيغة "Student--15" أو "Teacher--1".
  final String id;
  final String name;
  final bool isTeacher;
  final bool isLocal;

  /// هل دخل الطالب المكالمة فعلياً؟ false = من الشعبة لكن لم ينضم بعد.
  final bool isPresent;

  /// هل ميكروفونه مفعّل؟ (false = مكتوم).
  final bool isMicEnabled;

  /// هل يتحدّث الآن؟ (يفعّل اللون الفوسفوري).
  final bool isSpeaking;

  final double audioLevel;

  const CallParticipant({
    required this.id,
    required this.name,
    this.isTeacher = false,
    this.isLocal = false,
    this.isPresent = true,
    this.isMicEnabled = true,
    this.isSpeaking = false,
    this.audioLevel = 0,
  });

  CallParticipant copyWith({
    String? name,
    bool? isTeacher,
    bool? isLocal,
    bool? isPresent,
    bool? isMicEnabled,
    bool? isSpeaking,
    double? audioLevel,
  }) {
    return CallParticipant(
      id: id,
      name: name ?? this.name,
      isTeacher: isTeacher ?? this.isTeacher,
      isLocal: isLocal ?? this.isLocal,
      isPresent: isPresent ?? this.isPresent,
      isMicEnabled: isMicEnabled ?? this.isMicEnabled,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      audioLevel: audioLevel ?? this.audioLevel,
    );
  }
}

/// طالب من شعبة الدرس (ضمن قائمة المُبلّغين) — يُقرأ من حقل "students" في رد start.
class RosterStudent {
  RosterStudent({required this.id, required this.name});
  final String id;
  final String name;

  factory RosterStudent.fromJson(Map<String, dynamic> j) => RosterStudent(
        id: (j['id'] ?? j['student_id'] ?? '').toString(),
        name: (j['full_name'] ?? j['name'] ?? 'طالب').toString(),
      );
}

/// شعبة يدرّسها المدرس (تأتي من data.classes في رد teacher/info).
class SchoolClass {
  SchoolClass({required this.id, required this.name});
  final String id;
  final String name;

  factory SchoolClass.fromJson(Map<String, dynamic> j) => SchoolClass(
        id: (j['id'] ?? '').toString(),
        name: (j['name'] ?? 'شعبة').toString(),
      );
}