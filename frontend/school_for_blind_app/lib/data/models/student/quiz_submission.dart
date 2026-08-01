import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_submission.g.dart';

@JsonSerializable()
class QuizSubmissionResponse {
  final String status;
  final String message;
  final SubmissionData data;

  QuizSubmissionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory QuizSubmissionResponse.fromJson(Map<String, dynamic> json) =>
      _$QuizSubmissionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuizSubmissionResponseToJson(this);
}

@JsonSerializable()
class SubmissionData {
  @JsonKey(name: 'submission_id')
  final int submissionId;

  @JsonKey(name: 'auto_score')
  final double autoScore;

  final String status;

  SubmissionData({
    required this.submissionId,
    required this.autoScore,
    required this.status,
  });

  factory SubmissionData.fromJson(Map<String, dynamic> json) =>
      _$SubmissionDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionDataToJson(this);
}
