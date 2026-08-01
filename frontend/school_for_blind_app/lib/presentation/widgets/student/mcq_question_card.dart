import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/student/quiz_questions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/glass_effect.dart';

class McqQuestionCard extends StatelessWidget {
  final Question question;
  final int totalQuestions;
  final int? selectedChoiceId;
  final Function(int choiceId) onChoiceSelected;

  const McqQuestionCard({
    super.key,
    required this.question,
    required this.totalQuestions,
    required this.selectedChoiceId,
    required this.onChoiceSelected,
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
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: choices.length,
                  itemBuilder: (context, index) {
                    final choice = choices[index];
                    final isSelected = selectedChoiceId == choice.id;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: InkWell(
                        onTap: () => onChoiceSelected(choice.id),
                        borderRadius: BorderRadius.circular(15.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 16.h,
                            horizontal: 16.w,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.background.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                              width: 0.2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(6.r),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                  ),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    fontSize: 30.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  choice.choiceText,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    fontSize: 36.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          GlassEffect(borderRadius: BorderRadiusGeometry.circular(15.r)),
        ],
      ),
    );
  }
}
