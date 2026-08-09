import 'package:json_annotation/json_annotation.dart';

part 'quiz_review.g.dart';

@JsonSerializable()
class QuizReviewResponse {
  final String status;
  final QuizReviewData data;

  QuizReviewResponse({required this.status, required this.data});

  factory QuizReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$QuizReviewResponseFromJson(json);
  Map<String, dynamic> toJson() => _$QuizReviewResponseToJson(this);
}

@JsonSerializable()
class QuizReviewData {
  @JsonKey(name: 'quiz_id')
  final int quizId;
  @JsonKey(name: 'total_score')
  final num totalScore;
  final String status;
  @JsonKey(name: 'quiz_review')
  final List<QuizReviewQuestion> questions;

  QuizReviewData({
    required this.quizId,
    required this.totalScore,
    required this.status,
    required this.questions,
  });

  factory QuizReviewData.fromJson(Map<String, dynamic> json) =>
      _$QuizReviewDataFromJson(json);
  Map<String, dynamic> toJson() => _$QuizReviewDataToJson(this);
}

@JsonSerializable()
class QuizReviewQuestion {
  @JsonKey(name: 'question_id')
  final int questionId;
  final String description;
  final String type;
  final String points;
  @JsonKey(name: 'correct_answer')
  final String correctAnswer;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int questionNumber = 0;

  QuizReviewQuestion({
    required this.questionId,
    required this.description,
    required this.type,
    required this.points,
    required this.correctAnswer,
  });

  factory QuizReviewQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizReviewQuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuizReviewQuestionToJson(this);
}
