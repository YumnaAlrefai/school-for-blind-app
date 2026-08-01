// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_questions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizQuestionsResponse _$QuizQuestionsResponseFromJson(
  Map<String, dynamic> json,
) => QuizQuestionsResponse(
  quizId: (json['quiz_id'] as num).toInt(),
  questions: (json['questions'] as List<dynamic>)
      .map((e) => Question.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuizQuestionsResponseToJson(
  QuizQuestionsResponse instance,
) => <String, dynamic>{
  'quiz_id': instance.quizId,
  'questions': instance.questions,
};

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
  questionNumber: (json['question_number'] as num).toInt(),
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  text: json['text'] as String,
  mark: (json['mark'] as num).toInt(),
  choices: (json['choices'] as List<dynamic>?)
      ?.map((e) => Choices.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
  'question_number': instance.questionNumber,
  'id': instance.id,
  'type': instance.type,
  'text': instance.text,
  'mark': instance.mark,
  'choices': instance.choices,
};

Choices _$ChoicesFromJson(Map<String, dynamic> json) => Choices(
  id: (json['id'] as num).toInt(),
  choiceText: json['choice_text'] as String,
);

Map<String, dynamic> _$ChoicesToJson(Choices instance) => <String, dynamic>{
  'id': instance.id,
  'choice_text': instance.choiceText,
};
