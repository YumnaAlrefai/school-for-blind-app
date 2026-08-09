import 'package:json_annotation/json_annotation.dart';

part 'exam_solution.g.dart';

@JsonSerializable()
class ExamSolutionsResponse {
  final String status;
  final List<ExamSolutionQuestion> data;

  ExamSolutionsResponse({required this.status, required this.data});

  factory ExamSolutionsResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamSolutionsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExamSolutionsResponseToJson(this);
}

@JsonSerializable()
class ExamSolutionQuestion {
  final int id;
  final String type;

  @JsonKey(name: 'description')
  final String text;

  @JsonKey(name: 'points')
  final String points;

  final List<ExamSolutionChoice>? choices;

  final String? solution;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int questionNumber = 0;

  ExamSolutionQuestion({
    required this.id,
    required this.type,
    required this.text,
    required this.points,
    this.choices,
    this.solution,
  });

  factory ExamSolutionQuestion.fromJson(Map<String, dynamic> json) =>
      _$ExamSolutionQuestionFromJson(json);
  Map<String, dynamic> toJson() => _$ExamSolutionQuestionToJson(this);
}

@JsonSerializable()
class ExamSolutionChoice {
  final int id;
  @JsonKey(name: 'choice_text')
  final String choiceText;
  @JsonKey(name: 'is_correct')
  final bool isCorrect;

  ExamSolutionChoice({
    required this.id,
    required this.choiceText,
    required this.isCorrect,
  });

  factory ExamSolutionChoice.fromJson(Map<String, dynamic> json) =>
      _$ExamSolutionChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$ExamSolutionChoiceToJson(this);
}
