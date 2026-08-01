import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_buttons.dart';

class StudentAccountsScreen extends StatelessWidget {
  const StudentAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        helpMessage:
            'ْهنا يجب عليك أن تختارَ إمَّا إنشاءَ حسابٍ أو تسجيلَ دخولْ، إن كانَ لديك حسابٌ بالفعل اختر تسجيل الدخول، وإلا إنشاءَ حساب',
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              title: 'تسجيل الدخول',
              width: 332,
              height: 97,
              fontSize: 48,
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
