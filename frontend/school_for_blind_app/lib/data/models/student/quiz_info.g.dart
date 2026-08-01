// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizInfoResponse _$QuizInfoResponseFromJson(Map<String, dynamic> json) =>
    QuizInfoResponse(
      status: json['status'] as String,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : QuizData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuizInfoResponseToJson(QuizInfoResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

QuizData _$QuizDataFromJson(Map<String, dynamic> json) => QuizData(
  quizId: (json['quiz_id'] as num).toInt(),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  totalQuestions: (json['total_questions'] as num).toInt(),
  totalMark: (json['total_mark'] as num).toInt(),
);

Map<String, dynamic> _$QuizDataToJson(QuizData instance) => <String, dynamic>{
  'quiz_id': instance.quizId,
  'duration_minutes': instance.durationMinutes,
  'total_questions': instance.totalQuestions,
  'total_mark': instance.totalMark,
};
