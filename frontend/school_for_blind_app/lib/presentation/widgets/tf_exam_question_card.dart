import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/exam_question.dart';
import 'package:school_for_blind_app/presentation/widgets/glass_effect.dart';

class TfExamQuestionCard extends StatelessWidget {
  final ExamQuestion question;
  final int totalQuestions;
  final bool? selectedValue;
  final Function(bool value) onValueSelected;

  const TfExamQuestionCard({
    super.key,
    required this.question,
    required this.totalQuestions,
    required this.selectedValue,
    required this.onValueSelected,
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
                            backgroundColor: selectedValue == false
                                ? const Color(0xffff3333)
                                : Theme.of(context).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              side: selectedValue == false
                                  ? BorderSide.none
                                  : BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      width: 0.2.w,
                                    ),
                            ),
                          ),
                          onPressed: () => onValueSelected(false),
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
                            backgroundColor: selectedValue == true
                                ? Colors.green
                                : Theme.of(context).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              side: selectedValue == true
                                  ? BorderSide.none
                                  : BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      width: 0.2.w,
                                    ),
                            ),
                          ),
                          onPressed: () => onValueSelected(true),
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
