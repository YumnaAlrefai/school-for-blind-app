import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/student/exam_solution.dart';
import 'package:school_for_blind_app/presentation/widgets/student/glass_effect.dart';
import 'package:school_for_blind_app/presentation/widgets/student/math_text.dart';

class TextSolutionExamCard extends StatelessWidget {
  final ExamSolutionQuestion question;
  final int totalQuestions;

  const TextSolutionExamCard({
    super.key,
    required this.question,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${question.questionNumber}/$totalQuestions',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 32.sp,
                      ),
                    ),
                    Text(
                      '${question.points} درجات',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 32.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Center(
                  child: MathText(
                    question.text,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.background.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 0.2,
                    ),
                  ),
                  child: MathText(
                    question.solution ?? '',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 40.sp,
                      height: 1.6,
                    ),
                  ),
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
