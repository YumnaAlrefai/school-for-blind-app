import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_questions.g.dart';

@JsonSerializable()
class QuizQuestionsResponse {
  @JsonKey(name: 'quiz_id')
  final int quizId;
  final List<Question> questions;

  QuizQuestionsResponse({required this.quizId, required this.questions});
  factory QuizQuestionsResponse.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$QuizQuestionsResponseToJson(this);
}

@JsonSerializable()
class Question {
  @JsonKey(name: 'question_number')
  final int questionNumber;
  final int id;
  final String type;
  final String text;
  final int mark;
  final List<Choices>? choices;

  Question({
    required this.questionNumber,
    required this.id,
    required this.type,
    required this.text,
    required this.mark,
    this.choices,
  });
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Choices {
  final int id;
  @JsonKey(name: 'choice_text')
  final String choiceText;

  Choices({required this.id, required this.choiceText});
  factory Choices.fromJson(Map<String, dynamic> json) =>
      _$ChoicesFromJson(json);
  Map<String, dynamic> toJson() => _$ChoicesToJson(this);
}
