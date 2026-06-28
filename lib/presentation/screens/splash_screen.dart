import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
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

  void _handleNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedInByLink = prefs.getBool('isLoggedIn') ?? false;
    await Future.delayed(const Duration(seconds: 3));
    if (isLoggedInByLink) {
      Navigator.pushReplacementNamed(context, AppRoutes.kStudentMainScreen);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.kSUserTypeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, ResultState<dynamic>>(
      listener: (context, state) {
        state.whenOrNull(
          success: (data) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.kStudentAccountsScreen,
              (route) => false,
            );
          },
          failure: (error) {
            Navigator.pushReplacementNamed(context, AppRoutes.kSUserTypeScreen);
          },
        );
      },
      child: Scaffold(body: Container(color: AppColors.kBackgroundColor)),
    );
  }
}
