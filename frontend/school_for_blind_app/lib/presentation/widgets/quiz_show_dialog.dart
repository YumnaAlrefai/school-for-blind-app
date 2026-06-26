import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_buttons.dart';

class QuizShowDialog {
  static Future<dynamic> buildQuizShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Container(
          padding: EdgeInsets.all(20.w),
          width: 450.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.quiz_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 36.r,
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        'كويز',
                        style: TextStyle(
                          fontSize: 38.sp,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    iconSize: 20,
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xffff3333),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              Divider(thickness: 0.2),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.background.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: 0.2,
                  ),
                ),
                child: Text(
                  // '"$lessonName"',
                  'قواعد المعرفة',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.kMediumPrimary(context),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      context,
                      icon: Icons.emoji_events,
                      title: 'الدرجة:',
                      value: '100 درجة',
                      iconColor: Colors.amber,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _buildInfoCard(
                      context,
                      icon: Icons.help,
                      title: 'الأسئلة:',
                      value: '30 سؤال',
                      iconColor: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              _buildInfoCard(
                context,
                icon: Icons.timer,
                title: 'المدة:',
                value: '03:00:00',
                iconColor: Color(0xFFFF3333),
              ),
              SizedBox(height: 12.h),
              PrimaryButton(
                title: 'بدء الآن',
                width: 155.w,
                height: 75.h,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.kStudentQuizScreen);
                },
                fontSize: 48.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildInfoCard(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String value,
  required Color iconColor,
}) {
  return Container(
    padding: EdgeInsets.all(12.w),
    width: 140.w,
    height: 133.h,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background.withOpacity(0.4),
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: Theme.of(context).colorScheme.onBackground,
        width: 0.2,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 30.r),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 35.sp,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 35.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    ),
  );
}
