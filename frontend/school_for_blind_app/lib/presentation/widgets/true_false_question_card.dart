import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/quiz_questions.dart';
import 'package:school_for_blind_app/presentation/widgets/glass_effect.dart';

class TrueFalseQuestionCard extends StatelessWidget {
  final Question question;
  final int totalQuestions;
  final bool? selectedAnswer;
  final Function(bool value) onAnswerSelected;

  const TrueFalseQuestionCard({
    super.key,
    required this.question,
    required this.totalQuestions,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
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
                      '${question.mark} درجات',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 32.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    '"${question.text}"',
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedAnswer == false
                                ? const Color(0xffff3333)
                                : Theme.of(context).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              side: selectedAnswer == false
                                  ? BorderSide.none
                                  : BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      width: 0.2.w,
                                    ),
                            ),
                          ),
                          onPressed: () => onAnswerSelected(false),
                          child: Text(
                            'خطأ',
                            style: AppTextStyles.kMediumPrimary(context),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 15.w),
                    Expanded(
                      child: SizedBox(
                        height: 80.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedAnswer == true
                                ? Colors.green
                                : Theme.of(context).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              side: selectedAnswer == true
                                  ? BorderSide.none
                                  : BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      width: 0.2.w,
                                    ),
                            ),
                          ),
                          onPressed: () => onAnswerSelected(true),
                          child: Text(
                            'صح',
                            style: AppTextStyles.kMediumPrimary(context),
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
