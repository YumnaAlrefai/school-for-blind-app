// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubjectLessonsResponse _$SubjectLessonsResponseFromJson(
  Map<String, dynamic> json,
) => SubjectLessonsResponse(
  subjectId: json['subject_id'] as String,
  lessons: (json['lessons'] as List<dynamic>)
      .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SubjectLessonsResponseToJson(
  SubjectLessonsResponse instance,
) => <String, dynamic>{
  'subject_id': instance.subjectId,
  'lessons': instance.lessons,
};

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  teacherName: json['teacher_name'] as String,
  teacherId: (json['teacher_id'] as num).toInt(),
  isSaved: json['is_favorited'] as bool,
  isQuizSolved: json['is_quiz_solved'] as bool,
);

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'teacher_name': instance.teacherName,
  'teacher_id': instance.teacherId,
  'is_favorited': instance.isSaved,
  'is_quiz_solved': instance.isQuizSolved,
};
