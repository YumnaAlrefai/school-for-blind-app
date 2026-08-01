import 'package:flutter/material.dart';
import 'package:school_for_blind_app/data/models/exam_question.dart';
import 'package:school_for_blind_app/presentation/widgets/mcq_exam_question_card.dart';
import 'package:school_for_blind_app/presentation/widgets/tf_exam_question_card.dart';
import 'package:school_for_blind_app/presentation/widgets/text_exam_question_card.dart';

class ExamQuestionsList extends StatelessWidget {
  final List<ExamQuestion> questions;
  final Map<int, dynamic> studentAnswers;
  final int totalQuestions;
  final bool isTimeUp;
  final void Function(int questionId, dynamic value) onAnswerChanged;

  const ExamQuestionsList({
    super.key,
    required this.questions,
    required this.studentAnswers,
    required this.totalQuestions,
    required this.isTimeUp,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isTimeUp,
      child: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final currentAnswer = studentAnswers[question.id];

          switch (question.type.toUpperCase()) {
            case 'MCQ':
              return McqExamQuestionCard(
                key: ValueKey(question.id),
                question: question,
                totalQuestions: totalQuestions,
                selectedChoiceId: currentAnswer as int?,
                onChoiceSelected: (choiceId) =>
                    onAnswerChanged(question.id, choiceId),
              );
            case 'TF':
              return TfExamQuestionCard(
                key: ValueKey(question.id),
                question: question,
                totalQuestions: totalQuestions,
                selectedValue: currentAnswer as bool?,
                onValueSelected: (value) => onAnswerChanged(question.id, value),
              );
            case 'TEXT':
              final Map<String, dynamic>? textData =
                  currentAnswer as Map<String, dynamic>?;
              return TextExamQuestionCard(
                key: ValueKey(question.id),
                question: question,
                totalQuestions: totalQuestions,
                currentAnswer: (textData?['text'] as String?) ?? '',
                onAnswerChanged: (text) => onAnswerChanged(question.id, {
                  ...?studentAnswers[question.id] as Map<String, dynamic>?,
                  'text': text,
                }),
                onAudioChanged: (audioPath) => onAnswerChanged(question.id, {
                  ...?studentAnswers[question.id] as Map<String, dynamic>?,
                  'audio': audioPath,
                }),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
