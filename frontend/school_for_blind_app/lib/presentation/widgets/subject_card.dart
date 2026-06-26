import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/presentation/widgets/glass_effect.dart';

class SubjectCard extends StatelessWidget {
  final String subjectName;
  final IconData icon;
  final String progress;

  const SubjectCard({
    super.key,
    required this.subjectName,
    required this.icon,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.kStudentSubjectDetailsScreen,
            arguments: subjectName,
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 354.w,
              height: 177.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 0.2.w,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    subjectName,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.kBigPrimary(context),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 45.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.background.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground,
                          width: 0.25.w,
                        ),
                      ),
                    ),
                    alignment: Alignment.topCenter,
                    child: Text(
                      'عدد الدروس: $progress',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 32.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -25,
              right: -15,
              child: Container(
                height: 75.h,
                width: 75.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Theme.of(context).colorScheme.onBackground,
                      width: 0.5.w,
                    ),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 48.sp,
                ),
              ),
            ),
            GlassEffect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)),
            ),
          ],
        ),
      ),
    );
  }
}
