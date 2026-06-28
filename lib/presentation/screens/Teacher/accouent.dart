import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/login.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/phoneTeacher.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/signup.dart';
// تأكد من استيراد ملف صفحة تسجيل الدخول هنا
// import 'path_to_your_file/login_teacher.dart';

class AccountTeacher extends StatefulWidget {
  const AccountTeacher({super.key});

  @override
  State<AccountTeacher> createState() => _AccountTeacherState();
}

class _AccountTeacherState extends State<AccountTeacher> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 0.3),
            color: AppColors.kBackgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- تعديل زر تسجيل الدخول هنا ---
              GestureDetector(
                onTap: () {
                  // الانتقال إلى صفحة LoginTeacher
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginTeacher(),
                    ),
                  );
                },
                child: Container(
                  width: 246,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD3FF54), // اللون الفسفوري
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // ---------------------------------
              const SizedBox(height: 20),

              // زر إنشاء حساب
              GestureDetector(
                onTap: () {
                  // الانتقال إلى صفحة RegisterTeacher
                  Navigator.pushNamed(context, AppRoutes.kTeacherPhone);
                },
                child: Container(
                  width: 246,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: isPressed
                        ? const Color(0xFFD3FF54).withOpacity(0.2)
                        : Colors.transparent,
                    border: Border.all(
                      color: const Color(0xFFD3FF54),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "إنشاء حساب",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
