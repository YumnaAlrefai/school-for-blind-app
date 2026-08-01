import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/presentation/widgets/student/glass_effect.dart';
import 'package:school_for_blind_app/presentation/widgets/student/options_card.dart';

enum QuizQuestionType { essay, multipleChoice, trueOrfalse }

QuizQuestionType quizType = QuizQuestionType.trueOrfalse;

class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 25.w),
            width: 378.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.onBackground,
                width: 0.2.w,
              ),
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('10 درجات', style: TextStyle(fontSize: 36.sp)),
                    Text('1/30', style: TextStyle(fontSize: 36.sp)),
                  ],
                ),
                Text(
                  '"نص السؤال الاول"',
                  style: AppTextStyles.kMediumPrimary(context),
                ),

                SizedBox(height: 30.h),
                _buildAnswerSpace(),
              ],
            ),
          ),
          GlassEffect(borderRadius: BorderRadius.all(Radius.circular(20))),
        ],
      ),
    );
  }
}

Widget _buildAnswerSpace() {
  switch (quizType) {
    case QuizQuestionType.essay:
      return _buildEssayQuestion();

    case QuizQuestionType.multipleChoice:
      return _buildMultipleChoiceQuestion();

    case QuizQuestionType.trueOrfalse:
      return _buildTrueOrFalseQuestion();
  }
}

Widget _buildTrueOrFalseQuestion() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      OptionsCard(
        width: 125,
        isSelected: false,
        onTap: () {},
        height: 65,
        title: 'صح',
      ),
      OptionsCard(
        width: 125,
        isSelected: false,
        onTap: () {},
        height: 65,
        title: 'خطأ',
      ),
    ],
  );
}

Widget _buildMultipleChoiceQuestion() {
  return Text(QuizQuestionType.multipleChoice.toString());
}

Widget _buildEssayQuestion() {
  return Text(QuizQuestionType.essay.toString());
}
