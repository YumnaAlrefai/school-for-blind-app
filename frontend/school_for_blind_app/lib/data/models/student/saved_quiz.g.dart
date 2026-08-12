// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedQuiz _$SavedQuizFromJson(Map<String, dynamic> json) => SavedQuiz(
  id: (json['id'] as num).toInt(),
  numOfQuestions: (json['numofquestions'] as num).toInt(),
  timeLimit: (json['timelimit'] as num).toInt(),
  totalmark: (json['totalmark'] as num).toInt(),
  subjectId: (json['subject_id'] as num).toInt(),
  lessonId: (json['lesson_id'] as num).toInt(),
  teacherId: (json['teacher_id'] as num).toInt(),
  subjectName: json['subject_name'] as String,
  teacherName: json['teacher_name'] as String,
);

Map<String, dynamic> _$SavedQuizToJson(SavedQuiz instance) => <String, dynamic>{
  'id': instance.id,
  'numofquestions': instance.numOfQuestions,
  'timelimit': instance.timeLimit,
  'totalmark': instance.totalmark,
  'subject_id': instance.subjectId,
  'lesson_id': instance.lessonId,
  'teacher_id': instance.teacherId,
  'subject_name': instance.subjectName,
  'teacher_name': instance.teacherName,
};
