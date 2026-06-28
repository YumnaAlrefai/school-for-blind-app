import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_buttons.dart';

class StudentAccountsScreen extends StatelessWidget {
  const StudentAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.kBackgroundColor),
      backgroundColor: AppColors.kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              title: 'تسجيل الدخول',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.kStudentLoginScreen);
              },
            ),
            SizedBox(height: 30.h),
            SecondaryButton(
              title: 'إنشاء حساب',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.kStudentRegisterNumberScreen,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
