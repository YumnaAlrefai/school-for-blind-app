// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'past_exam_solutions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PastExamSolutionsResponse _$PastExamSolutionsResponseFromJson(
  Map<String, dynamic> json,
) => PastExamSolutionsResponse(
  status: json['status'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => PastExamQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PastExamSolutionsResponseToJson(
  PastExamSolutionsResponse instance,
) => <String, dynamic>{'status': instance.status, 'data': instance.data};

PastExamQuestion _$PastExamQuestionFromJson(Map<String, dynamic> json) =>
    PastExamQuestion(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      description: json['description'] as String,
      choices: (json['choices'] as List<dynamic>?)
          ?.map((e) => PastExamChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      solution: json['solution'] as String?,
    );

Map<String, dynamic> _$PastExamQuestionToJson(PastExamQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'description': instance.description,
      'choices': instance.choices,
      'solution': instance.solution,
    };

PastExamChoice _$PastExamChoiceFromJson(Map<String, dynamic> json) =>
    PastExamChoice(
      id: (json['id'] as num).toInt(),
      choiceText: json['choice_text'] as String,
      isCorrect: json['is_correct'] as bool,
    );

Map<String, dynamic> _$PastExamChoiceToJson(PastExamChoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'choice_text': instance.choiceText,
      'is_correct': instance.isCorrect,
    };
