import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/exam_status.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/exam.dart';

class ExamCard extends StatelessWidget {
  final int number;
  final Exam exam;
  final ExamStatus status;
  final VoidCallback? onTap;

  const ExamCard({
    super.key,
    required this.number,
    required this.exam,
    required this.status,
    this.onTap,
  });

  String get _statusLabel {
    switch (status) {
      case ExamStatus.notScheduled:
        return 'لم يُحدد الموعد بعد';
      case ExamStatus.upcoming:
        return 'قريباً';
      case ExamStatus.ongoing:
        return 'جارٍ الآن';
      case ExamStatus.locked:
        return 'انتهت مهلة الدخول';
      case ExamStatus.ended:
        return 'انتهى';
    }
  }

  Color _statusColor(BuildContext context) {
    switch (status) {
      case ExamStatus.notScheduled:
        return Colors.grey;
      case ExamStatus.upcoming:
        return Colors.orange;
      case ExamStatus.ongoing:
        return Colors.green;
      case ExamStatus.locked:
        return Colors.grey;
      case ExamStatus.ended:
        return const Color(0xffff3333);
    }
  }

  bool get _isEnabled => status == ExamStatus.ongoing;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Opacity(
        opacity: _isEnabled || status == ExamStatus.ended ? 1 : 0.5,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    child: Text(
                      '$number',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Text(
                    exam.title,
                    style: AppTextStyles.kMediumPrimary(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(
                '${exam.numOfQuestions} أسئلة • ${exam.durationMinutes} د • ${exam.totalmark} علامة',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 38,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _statusLabel,
                      style: TextStyle(color: color, fontSize: 38),
                    ),
                  ),
                ],
              ),
              Row(children: []),
            ],
          ),
        ),
      ),
    );
  }
}
