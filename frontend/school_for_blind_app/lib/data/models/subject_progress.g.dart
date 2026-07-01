// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubjectProgress _$SubjectProgressFromJson(Map<String, dynamic> json) =>
    SubjectProgress(
      subjectId: json['subject_id'] as String,
      currentLessons: (json['current_lessons'] as num).toInt(),
      totalLessons: (json['total_lessons'] as num).toInt(),
      progressText: json['progress_text'] as String,
    );

Map<String, dynamic> _$SubjectProgressToJson(SubjectProgress instance) =>
    <String, dynamic>{
      'subject_id': instance.subjectId,
      'current_lessons': instance.currentLessons,
      'total_lessons': instance.totalLessons,
      'progress_text': instance.progressText,
    };
