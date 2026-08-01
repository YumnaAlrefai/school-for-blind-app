import 'package:json_annotation/json_annotation.dart';

part 'exam_submission.g.dart';

@JsonSerializable()
class ExamSubmissionResponse {
  final String status;
  final String? message;

  ExamSubmissionResponse({required this.status, this.message});

  factory ExamSubmissionResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamSubmissionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExamSubmissionResponseToJson(this);
}
