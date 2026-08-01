import 'package:flutter/material.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/student_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
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

  void _handleNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('login') ?? false;
    await Future.delayed(const Duration(seconds: 3));
    if (isLoggedIn) {
      getIt<StudentCubit>().loadStudentData();

      Navigator.pushReplacementNamed(context, AppRoutes.kStudentMainScreen);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.kSUserTypeScreen);
    }
  }
  // if(isLoggedIn==true){
  //         if (prefs.getString('role') == 'tenant') {
  //           Navigator.pushReplacementNamed(context, MainlayoutScreen.id);
  //         } else {
  //           Navigator.pushReplacementNamed(context, Homepage.id);
  //         }
  //       }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Theme.of(context).colorScheme.background),
    );
  }
}
