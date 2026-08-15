import 'package:flutter/material.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/student_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher/teacher_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
      reverseDuration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
    _handleNavigation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isStudentLoggedIn = prefs.getBool('login') ?? false;
    final bool isTeacherLoggedIn = prefs.getBool('teacherLoggedIn') ?? false;

    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    await _controller.reverse();

    if (!mounted) return;

    if (isStudentLoggedIn) {
      await getIt<StudentCubit>().loadStudentData();
      Navigator.pushReplacementNamed(context, AppRoutes.kStudentMainScreen);
    } else if (isTeacherLoggedIn) {
      await getIt<TeacherCubit>().loadTeacherData();
      Navigator.pushReplacementNamed(context, AppRoutes.kSubjectScreen);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.kSUserTypeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/images/SESB-removebg-preview.png',
                width: 250,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
