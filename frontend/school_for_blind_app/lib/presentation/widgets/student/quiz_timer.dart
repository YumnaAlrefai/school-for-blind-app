import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';

class QuizTimer extends StatelessWidget {
  final int remainingSeconds;

  const QuizTimer({super.key, required this.remainingSeconds});

  String _formatDuration(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    final String hoursStr = hours.toString().padLeft(2, '0');
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      padding: EdgeInsets.all(15.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Center(
        child: Text(
          _formatDuration(remainingSeconds),
          style: AppTextStyles.kMediumPrimary(context),
        ),
      ),
    );
  }
}
