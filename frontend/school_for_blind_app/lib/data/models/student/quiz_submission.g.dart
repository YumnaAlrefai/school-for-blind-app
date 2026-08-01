// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizSubmissionResponse _$QuizSubmissionResponseFromJson(
  Map<String, dynamic> json,
) => QuizSubmissionResponse(
  status: json['status'] as String,
  message: json['message'] as String,
  data: SubmissionData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QuizSubmissionResponseToJson(
  QuizSubmissionResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

SubmissionData _$SubmissionDataFromJson(Map<String, dynamic> json) =>
    SubmissionData(
      submissionId: (json['submission_id'] as num).toInt(),
      autoScore: (json['auto_score'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$SubmissionDataToJson(SubmissionData instance) =>
    <String, dynamic>{
      'submission_id': instance.submissionId,
      'auto_score': instance.autoScore,
      'status': instance.status,
    };
