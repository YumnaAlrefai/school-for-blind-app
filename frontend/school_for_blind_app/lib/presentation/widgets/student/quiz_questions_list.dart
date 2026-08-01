import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/data/models/student/quiz_questions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/mcq_question_card.dart';
import 'package:school_for_blind_app/presentation/widgets/student/true_false_question_card.dart';
import 'package:school_for_blind_app/presentation/widgets/student/text_question_card.dart';

class QuizQuestionsList extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> studentAnswers;
  final int totalQuestions;
  final bool isTimeUp;
  final Function(int questionId, dynamic value) onAnswerChanged;

  const QuizQuestionsList({
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
        padding: EdgeInsets.only(bottom: 20.h),
        itemBuilder: (context, index) {
          final question = questions[index];
          switch (question.type.toUpperCase()) {
            case 'MCQ':
              return McqQuestionCard(
                question: question,
                totalQuestions: totalQuestions,
                selectedChoiceId: studentAnswers[question.id] as int?,
                onChoiceSelected: (choiceId) =>
                    onAnswerChanged(question.id, choiceId),
              );
            case 'TF':
              return TrueFalseQuestionCard(
                question: question,
                totalQuestions: totalQuestions,
                selectedAnswer: studentAnswers[question.id] as bool?,
                onAnswerSelected: (answerValue) =>
                    onAnswerChanged(question.id, answerValue),
              );
            case 'TEXT':
              final Map<String, dynamic> textData =
                  (studentAnswers[question.id] as Map<String, dynamic>?) ??
                  {'text': '', 'audio': ''};
              return TextQuestionCard(
                question: question,
                totalQuestions: totalQuestions,
                currentAnswer: textData['text'] ?? '',
                onAnswerChanged: (textValue) {
                  onAnswerChanged(question.id, {
                    'text': textValue,
                    'audio': textData['audio'],
                  });
                },
                onAudioChanged: (String? audioPath) {
                  onAnswerChanged(question.id, {
                    'text': textData['text'],
                    'audio': audioPath,
                  });
                },
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
