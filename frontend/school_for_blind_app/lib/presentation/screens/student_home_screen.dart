import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  Future<void> _openWhatsApp(BuildContext context) async {
    String phone = context.read<AuthCubit>().studentPhone;
    String formatted = phone.startsWith('0') ? phone.substring(1) : phone;

    final uri = Uri.parse("whatsapp://send?phone=+963$formatted");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await launchUrl(Uri.parse("https://wa.me/+963$formatted"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 50),
      backgroundColor: AppColors.kBackgroundColor,
      body: BlocListener<AuthCubit, ResultState<dynamic>>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) {
              Navigator.pushNamed(context, AppRoutes.kStudentAccountsScreen);
            },
            failure: (error) {
              getIt<VoiceServices>().speak("الرابط غير صحيح");
            },
          );
        },
        child: Center(
          child: GestureDetector(
            onTap: () => _openWhatsApp(context),
            child: Image.asset(
              "assets/images/images.png",
              width: 120.w,
              height: 120.h,
            ),
          ),
        ),
      ),
    );
  }
}
