import 'package:flutter/foundation.dart';

@immutable
class CallParticipant {
  final String id;
  final String name;
  final bool isTeacher;
  final bool isLocal;

  final bool isPresent;

  final bool isMicEnabled;

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

class RosterStudent {
  RosterStudent({required this.id, required this.name});
  final String id;
  final String name;

  factory RosterStudent.fromJson(Map<String, dynamic> j) => RosterStudent(
        id: (j['id'] ?? j['student_id'] ?? '').toString(),
        name: (j['full_name'] ?? j['name'] ?? 'طالب').toString(),
      );
}

class SchoolClass {
  SchoolClass({required this.id, required this.name});
  final String id;
  final String name;

  factory SchoolClass.fromJson(Map<String, dynamic> j) => SchoolClass(
        id: (j['id'] ?? '').toString(),
        name: (j['name'] ?? 'شعبة').toString(),
      );
}