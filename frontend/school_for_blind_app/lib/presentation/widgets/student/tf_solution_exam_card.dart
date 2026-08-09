import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/student/exam_solution.dart';
import 'package:school_for_blind_app/presentation/widgets/student/glass_effect.dart';
import 'package:school_for_blind_app/presentation/widgets/student/math_text.dart';

class TfSolutionExamCard extends StatelessWidget {
  final ExamSolutionQuestion question;
  final int totalQuestions;

  const TfSolutionExamCard({
    super.key,
    required this.question,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrectTrue = question.solution?.trim().toLowerCase() == 'true';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
      child: Stack(
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
                SizedBox(height: 25.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 80.h,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !isCorrectTrue
                                ? const Color(0xffff3333)
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(15.r),
                            border: !isCorrectTrue
                                ? null
                                : Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    width: 0.2.w,
                                  ),
                          ),
                          child: Text(
                            'خطأ',
                            style: TextStyle(
                              fontSize: 40.sp,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: SizedBox(
                        height: 80.h,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isCorrectTrue
                                ? Colors.green
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(15.r),
                            border: isCorrectTrue
                                ? null
                                : Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    width: 0.2.w,
                                  ),
                          ),
                          child: Text(
                            'صح',
                            style: TextStyle(
                              fontSize: 40.sp,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
