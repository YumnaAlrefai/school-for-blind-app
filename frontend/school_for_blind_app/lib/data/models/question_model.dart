
import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_model.g.dart';

enum QuizQuestionType { essay, multipleChoice, trueOrfalse }
@JsonSerializable()
class QuestionModel {
  final int number;
  final String text;
  final int points;
  final QuizQuestionType type;
  final List<String>? options;

  QuestionModel({
    required this.number,
    required this.text,
    required this.points,
    required this.type,
    this.options,
  });


  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}
