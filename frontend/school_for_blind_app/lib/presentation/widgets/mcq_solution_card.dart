import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/presentation/widgets/glass_effect.dart';
import 'package:school_for_blind_app/data/models/past_exam_solutions.dart';
import 'package:school_for_blind_app/presentation/widgets/math_text.dart';

class McqSolutionCard extends StatelessWidget {
  final PastExamQuestion question;
  final int questionNumber;
  final int totalQuestions;

  const McqSolutionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final choices = question.choices ?? [];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
      child: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$questionNumber/$totalQuestions',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 32.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: MathText(
                    question.description,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                ),
                SizedBox(height: 25.h),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: choices.length,
                  itemBuilder: (context, index) {
                    final choice = choices[index];
                    final isCorrect = choice.isCorrect;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? Colors.green
                              : Theme.of(
                                  context,
                                ).colorScheme.background.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: isCorrect
                                ? Colors.green
                                : Theme.of(context).colorScheme.onSurface,
                            width: 0.2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 30.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: MathText(
                                choice.choiceText,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 40.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          GlassEffect(borderRadius: BorderRadius.circular(15.r)),
        ],
      ),
    );
  }
}
