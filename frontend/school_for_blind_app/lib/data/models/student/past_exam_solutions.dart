import 'package:json_annotation/json_annotation.dart';

part 'past_exam_solutions.g.dart';

@JsonSerializable()
class PastExamSolutionsResponse {
  final String status;
  final List<PastExamQuestion> data;

  PastExamSolutionsResponse({required this.status, required this.data});

  factory PastExamSolutionsResponse.fromJson(Map<String, dynamic> json) =>
      _$PastExamSolutionsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PastExamSolutionsResponseToJson(this);
}

@JsonSerializable()
class PastExamQuestion {
  final int id;
  final String type;
  final String description;
  final List<PastExamChoice>? choices;
  final String? solution;

  PastExamQuestion({
    required this.id,
    required this.type,
    required this.description,
    this.choices,
    this.solution,
  });

  factory PastExamQuestion.fromJson(Map<String, dynamic> json) =>
      _$PastExamQuestionFromJson(json);
  Map<String, dynamic> toJson() => _$PastExamQuestionToJson(this);
}

@JsonSerializable()
class PastExamChoice {
  final int id;
  @JsonKey(name: 'choice_text')
  final String choiceText;
  @JsonKey(name: 'is_correct')
  final bool isCorrect;

  PastExamChoice({
    required this.id,
    required this.choiceText,
    required this.isCorrect,
  });

  factory PastExamChoice.fromJson(Map<String, dynamic> json) =>
      _$PastExamChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$PastExamChoiceToJson(this);
}
