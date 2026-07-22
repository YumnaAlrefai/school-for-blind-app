import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_login_screen.dart';

class AccountTeacher extends StatefulWidget {
  const AccountTeacher({super.key});

  @override
  State<AccountTeacher> createState() => _AccountTeacherState();
}

class _AccountTeacherState extends State<AccountTeacher> {
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
              
              AccountButton(
                label: "تسجيل الدخول",
                filled: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginTeacher(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              
              AccountButton(
                label: "إنشاء حساب",
                filled: false,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.kTeacherPhone);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const AccountButton({
    super.key,
    required this.label,
    required this.onTap,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 246,
        height: 54,
        decoration: BoxDecoration(
          color: filled ? AppColors.kPrimaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: filled
              ? null
              : Border.all(color: AppColors.kPrimaryColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: filled ? Colors.black : AppColors.kPrimaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}