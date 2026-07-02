import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    final prefs = await SharedPreferences.getInstance();

    // حالة دخول كل نوع مستخدم (مفاتيح منفصلة)
    final bool teacherLoggedIn = prefs.getBool('teacherLoggedIn') ?? false;
    final bool studentLoggedIn = prefs.getBool('login') ?? false;

    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    if (teacherLoggedIn) {
      // مدرّس مسجّل دخول → الصفحة الرئيسية للمدرّس مباشرة
      Navigator.pushReplacementNamed(context, AppRoutes.kSubjectScreen);
    } else if (studentLoggedIn) {
      // طالب مسجّل دخول → صفحة الطالب
      Navigator.pushReplacementNamed(context, AppRoutes.kStudentMainScreen);
    } else {
      // لا أحد مسجّل → شاشة اختيار الدور
      Navigator.pushReplacementNamed(context, AppRoutes.kSUserTypeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: AppColors.kPrimaryColor),
      ),
      backgroundColor: AppColors.kBackgroundColor,
    );
  }
}