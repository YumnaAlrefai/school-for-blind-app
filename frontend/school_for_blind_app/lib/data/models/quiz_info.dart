import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_info.g.dart';

@JsonSerializable()
class QuizInfoResponse {
  final String status;
  final String? message;
  final QuizData? data;

  QuizInfoResponse({required this.status, this.message, this.data});

  factory QuizInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$QuizInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$QuizInfoResponseToJson(this);
}

@JsonSerializable()
class QuizData {
  @JsonKey(name: 'quiz_id')
  final int quizId;
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @JsonKey(name: 'total_questions')
  final int totalQuestions;
  @JsonKey(name: 'total_mark')
  final int totalMark;

  QuizData({
    required this.quizId,
    required this.durationMinutes,
    required this.totalQuestions,
    required this.totalMark,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) =>
      _$QuizDataFromJson(json);
  Map<String, dynamic> toJson() => _$QuizDataToJson(this);
}
