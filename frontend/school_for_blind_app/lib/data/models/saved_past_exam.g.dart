// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_past_exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedPastExam _$SavedPastExamFromJson(Map<String, dynamic> json) =>
    SavedPastExam(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      year: json['year'] as String,
      session: json['session'] as String,
      subjectId: (json['subject_id'] as num).toInt(),
    );

Map<String, dynamic> _$SavedPastExamToJson(SavedPastExam instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'year': instance.year,
      'session': instance.session,
      'subject_id': instance.subjectId,
    };
