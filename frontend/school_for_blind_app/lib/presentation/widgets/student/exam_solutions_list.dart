import 'package:flutter/material.dart';
import 'package:school_for_blind_app/data/models/student/exam_solution.dart';
import 'package:school_for_blind_app/presentation/widgets/student/mcq_solution_exam_card.dart';
import 'package:school_for_blind_app/presentation/widgets/student/tf_solution_exam_card.dart';
import 'package:school_for_blind_app/presentation/widgets/student/text_solution_exam_card.dart';

class ExamSolutionsList extends StatelessWidget {
  final List<ExamSolutionQuestion> questions;
  final int totalQuestions;

  const ExamSolutionsList({
    super.key,
    required this.questions,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        switch (question.type.toUpperCase()) {
          case 'MCQ':
            return McqSolutionExamCard(
              key: ValueKey(question.id),
              question: question,
              totalQuestions: totalQuestions,
            );
          case 'TF':
            return TfSolutionExamCard(
              key: ValueKey(question.id),
              question: question,
              totalQuestions: totalQuestions,
            );
          case 'TEXT':
            return TextSolutionExamCard(
              key: ValueKey(question.id),
              question: question,
              totalQuestions: totalQuestions,
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
