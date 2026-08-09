// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solved_quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolvedQuizzesResponse _$SolvedQuizzesResponseFromJson(
  Map<String, dynamic> json,
) => SolvedQuizzesResponse(
  status: json['status'] as String,
  count: (json['count'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => SolvedQuiz.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SolvedQuizzesResponseToJson(
  SolvedQuizzesResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'count': instance.count,
  'data': instance.data,
};

SolvedQuiz _$SolvedQuizFromJson(Map<String, dynamic> json) => SolvedQuiz(
  submissionId: (json['submission_id'] as num).toInt(),
  quizId: (json['quiz_id'] as num).toInt(),
  quizTitle: json['quiz_title'] as String,
  subjectId: (json['subject_id'] as num).toInt(),
  lessonId: (json['lesson_id'] as num).toInt(),
  totalScore: json['total_score'] as num,
  quizMaxMark: json['quiz_max_mark'] as num,
  status: json['status'] as String,
  submittedAt: json['submitted_at'] as String,
);

Map<String, dynamic> _$SolvedQuizToJson(SolvedQuiz instance) =>
    <String, dynamic>{
      'submission_id': instance.submissionId,
      'quiz_id': instance.quizId,
      'quiz_title': instance.quizTitle,
      'subject_id': instance.subjectId,
      'lesson_id': instance.lessonId,
      'total_score': instance.totalScore,
      'quiz_max_mark': instance.quizMaxMark,
      'status': instance.status,
      'submitted_at': instance.submittedAt,
    };
