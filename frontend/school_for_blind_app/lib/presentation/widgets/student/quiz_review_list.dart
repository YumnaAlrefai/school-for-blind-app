import 'package:flutter/material.dart';
import 'package:school_for_blind_app/data/models/student/quiz_review.dart';
import 'package:school_for_blind_app/presentation/widgets/student/quiz_review_question_card.dart';

class QuizReviewList extends StatelessWidget {
  final List<QuizReviewQuestion> questions;

  const QuizReviewList({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return QuizReviewQuestionCard(
          key: ValueKey(question.questionId),
          question: question,
          totalQuestions: questions.length,
        );
      },
    );
  }
}
