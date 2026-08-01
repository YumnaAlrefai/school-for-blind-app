// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedLesson _$SavedLessonFromJson(Map<String, dynamic> json) => SavedLesson(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  subjectId: (json['subject_id'] as num).toInt(),
  teacherId: (json['teacher_id'] as num).toInt(),
  classId: (json['class_id'] as num).toInt(),
  hasQuiz: json['has_quiz'] as bool,
);

Map<String, dynamic> _$SavedLessonToJson(SavedLesson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subject_id': instance.subjectId,
      'teacher_id': instance.teacherId,
      'class_id': instance.classId,
      'has_quiz': instance.hasQuiz,
    };
