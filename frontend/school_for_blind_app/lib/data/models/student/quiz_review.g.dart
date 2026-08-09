// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizReviewResponse _$QuizReviewResponseFromJson(Map<String, dynamic> json) =>
    QuizReviewResponse(
      status: json['status'] as String,
      data: QuizReviewData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuizReviewResponseToJson(QuizReviewResponse instance) =>
    <String, dynamic>{'status': instance.status, 'data': instance.data};

QuizReviewData _$QuizReviewDataFromJson(Map<String, dynamic> json) =>
    QuizReviewData(
      quizId: (json['quiz_id'] as num).toInt(),
      totalScore: json['total_score'] as num,
      status: json['status'] as String,
      questions: (json['quiz_review'] as List<dynamic>)
          .map((e) => QuizReviewQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuizReviewDataToJson(QuizReviewData instance) =>
    <String, dynamic>{
      'quiz_id': instance.quizId,
      'total_score': instance.totalScore,
      'status': instance.status,
      'quiz_review': instance.questions,
    };

QuizReviewQuestion _$QuizReviewQuestionFromJson(Map<String, dynamic> json) =>
    QuizReviewQuestion(
      questionId: (json['question_id'] as num).toInt(),
      description: json['description'] as String,
      type: json['type'] as String,
      points: json['points'] as String,
      correctAnswer: json['correct_answer'] as String,
    );

Map<String, dynamic> _$QuizReviewQuestionToJson(QuizReviewQuestion instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'description': instance.description,
      'type': instance.type,
      'points': instance.points,
      'correct_answer': instance.correctAnswer,
    };
