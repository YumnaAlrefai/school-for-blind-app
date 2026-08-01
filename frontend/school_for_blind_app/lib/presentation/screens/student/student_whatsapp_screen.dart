import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';

class StudentWhatsappScreen extends StatelessWidget {
  const StudentWhatsappScreen({super.key});

  // Future<void> _openWhatsApp(BuildContext context) async {
  //   String phone = context.read<AuthCubit>().studentPhone;
  //   String formatted = phone.startsWith('0') ? phone.substring(1) : phone;

  //   final uri = Uri.parse("whatsapp://send?phone=+963$formatted");

  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     await launchUrl(Uri.parse("https://wa.me/+963$formatted"));
  //   }
  // }

  // Future<void> _openWhatsApp() async {
  //   final uri = Uri.parse("whatsapp://send?text=");

  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     await launchUrl(Uri.parse("https://wa.me/"));
  //   }
  // }

  Future<void> _openWhatsApp() async {
    await LaunchApp.openApp(
      androidPackageName: 'com.whatsapp',
      iosUrlScheme: 'whatsapp://',
      appStoreLink: 'itms-apps://itunes.apple.com/app/id310633997',
      openStore: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        helpMessage:
            'لقد أرسلنا إلى رقمك على الواتساب رابطاً يُوَجِّهُكَ للتطبيق عند الضغط عليهْ، في منتصف الشاشة يوجد أيقونة الواتساب إذا ضغطْتَ عليها تفتحُ لكَ التطبيق مباشرةَ',
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
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
            onTap: () => _openWhatsApp(),
            child: Image.asset(
              "assets/images/whatsapp.png",
              width: 500.w,
              height: 500.h,
            ),
          ),
        ),
      ),
    );
  }
}
