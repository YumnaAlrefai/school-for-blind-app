// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_solution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamSolutionsResponse _$ExamSolutionsResponseFromJson(
  Map<String, dynamic> json,
) => ExamSolutionsResponse(
  status: json['status'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => ExamSolutionQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExamSolutionsResponseToJson(
  ExamSolutionsResponse instance,
) => <String, dynamic>{'status': instance.status, 'data': instance.data};

ExamSolutionQuestion _$ExamSolutionQuestionFromJson(
  Map<String, dynamic> json,
) => ExamSolutionQuestion(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  text: json['description'] as String,
  points: json['points'] as String,
  choices: (json['choices'] as List<dynamic>?)
      ?.map((e) => ExamSolutionChoice.fromJson(e as Map<String, dynamic>))
      .toList(),
  solution: json['solution'] as String?,
);

Map<String, dynamic> _$ExamSolutionQuestionToJson(
  ExamSolutionQuestion instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'description': instance.text,
  'points': instance.points,
  'choices': instance.choices,
  'solution': instance.solution,
};

ExamSolutionChoice _$ExamSolutionChoiceFromJson(Map<String, dynamic> json) =>
    ExamSolutionChoice(
      id: (json['id'] as num).toInt(),
      choiceText: json['choice_text'] as String,
      isCorrect: json['is_correct'] as bool,
    );

Map<String, dynamic> _$ExamSolutionChoiceToJson(ExamSolutionChoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'choice_text': instance.choiceText,
      'is_correct': instance.isCorrect,
    };
