// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamsResponse _$ExamsResponseFromJson(Map<String, dynamic> json) =>
    ExamsResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Exam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExamsResponseToJson(ExamsResponse instance) =>
    <String, dynamic>{'status': instance.status, 'data': instance.data};

Exam _$ExamFromJson(Map<String, dynamic> json) => Exam(
  id: (json['id'] as num).toInt(),
  teacherId: (json['teacher_id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  subjectId: (json['subject_id'] as num).toInt(),
  examDate: json['exam_date'] == null
      ? null
      : DateTime.parse(json['exam_date'] as String),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  numOfQuestions: (json['numofquestions'] as num).toInt(),
  totalmark: (json['totalmark'] as num).toInt(),
  isPublished: (json['is_published'] as num).toInt(),
  isFavorited: json['is_favorited'] as bool? ?? false,
);

Map<String, dynamic> _$ExamToJson(Exam instance) => <String, dynamic>{
  'id': instance.id,
  'teacher_id': instance.teacherId,
  'title': instance.title,
  'description': instance.description,
  'subject_id': instance.subjectId,
  'exam_date': instance.examDate?.toIso8601String(),
  'duration_minutes': instance.durationMinutes,
  'numofquestions': instance.numOfQuestions,
  'totalmark': instance.totalmark,
  'is_published': instance.isPublished,
  'is_favorited': instance.isFavorited,
};
