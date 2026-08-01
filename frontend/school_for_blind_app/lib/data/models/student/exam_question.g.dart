// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamQuestionsResponse _$ExamQuestionsResponseFromJson(
  Map<String, dynamic> json,
) => ExamQuestionsResponse(
  status: json['status'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => ExamQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExamQuestionsResponseToJson(
  ExamQuestionsResponse instance,
) => <String, dynamic>{'status': instance.status, 'data': instance.data};

ExamQuestion _$ExamQuestionFromJson(Map<String, dynamic> json) => ExamQuestion(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  text: json['description'] as String,
  mark: json['point'] as String,
  totalMark: (json['totalmark'] as num?)?.toInt(),
  choices: (json['choices'] as List<dynamic>?)
      ?.map((e) => ExamChoice.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExamQuestionToJson(ExamQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'description': instance.text,
      'point': instance.mark,
      'totalmark': instance.totalMark,
      'choices': instance.choices,
    };

ExamChoice _$ExamChoiceFromJson(Map<String, dynamic> json) => ExamChoice(
  id: (json['id'] as num).toInt(),
  choiceText: json['choice_text'] as String,
);

Map<String, dynamic> _$ExamChoiceToJson(ExamChoice instance) =>
    <String, dynamic>{'id': instance.id, 'choice_text': instance.choiceText};
