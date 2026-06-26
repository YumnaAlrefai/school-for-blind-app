// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      number: (json['number'] as num).toInt(),
      text: json['text'] as String,
      points: (json['points'] as num).toInt(),
      type: $enumDecode(_$QuizQuestionTypeEnumMap, json['type']),
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'number': instance.number,
      'text': instance.text,
      'points': instance.points,
      'type': _$QuizQuestionTypeEnumMap[instance.type]!,
      'options': instance.options,
    };

const _$QuizQuestionTypeEnumMap = {
  QuizQuestionType.essay: 'essay',
  QuizQuestionType.multipleChoice: 'multipleChoice',
  QuizQuestionType.trueOrfalse: 'trueOrfalse',
};
