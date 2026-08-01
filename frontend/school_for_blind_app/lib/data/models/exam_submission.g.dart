// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamSubmissionResponse _$ExamSubmissionResponseFromJson(
  Map<String, dynamic> json,
) => ExamSubmissionResponse(
  status: json['status'] as String,
  message: json['message'] as String?,
);

Map<String, dynamic> _$ExamSubmissionResponseToJson(
  ExamSubmissionResponse instance,
) => <String, dynamic>{'status': instance.status, 'message': instance.message};
