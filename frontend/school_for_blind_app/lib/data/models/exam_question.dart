import 'package:json_annotation/json_annotation.dart';

part 'exam_question.g.dart';

@JsonSerializable()
class ExamQuestionsResponse {
  final String status;
  final List<ExamQuestion> data;

  ExamQuestionsResponse({required this.status, required this.data});

  factory ExamQuestionsResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamQuestionsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExamQuestionsResponseToJson(this);
}

@JsonSerializable()
class ExamQuestion {
  final int id;
  final String type;
  @JsonKey(name: 'description')
  final String text;
  @JsonKey(name: 'point')
  final String mark;
  @JsonKey(name: 'totalmark')
  final int? totalMark;
  final List<ExamChoice>? choices;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int questionNumber = 0;

  ExamQuestion({
    required this.id,
    required this.type,
    required this.text,
    required this.mark,
    this.totalMark,
    this.choices,
  });

  factory ExamQuestion.fromJson(Map<String, dynamic> json) =>
      _$ExamQuestionFromJson(json);
  Map<String, dynamic> toJson() => _$ExamQuestionToJson(this);
}

@JsonSerializable()
class ExamChoice {
  final int id;
  @JsonKey(name: 'choice_text')
  final String choiceText;

  ExamChoice({required this.id, required this.choiceText});

  factory ExamChoice.fromJson(Map<String, dynamic> json) =>
      _$ExamChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$ExamChoiceToJson(this);
}
