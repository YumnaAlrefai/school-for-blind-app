import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/level_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/role_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/add_lessons_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/donation_info_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/donation_payment_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_home_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_login_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_notifications_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_otp_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_account_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_profile_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_quize_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_test_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_register_number_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_register_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_safenumber_screen.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/technical_support_screen.dart';
import 'package:school_for_blind_app/presentation/screens/splash_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_accounts_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_home_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_login_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_main_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_otp_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_register_data_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_register_number_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_register_photo_screen.dart';
import 'package:school_for_blind_app/presentation/screens/user_type_screen.dart';
import 'dart:io' as io;

class AppRouter {
  Route? generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case AppRoutes.kSplashScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<AuthCubit>(),
            child: const SplashScreen(),
          ),
        );

      case AppRoutes.kSUserTypeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => RoleCubit(),
            child: const UserTypeScreen(),
          ),
        );

      case AppRoutes.kStudentAccountsScreen:
        return MaterialPageRoute(builder: (_) => const StudentAccountsScreen());

      case AppRoutes.kTeacherAccountsScreen:
        return MaterialPageRoute(builder: (_) => const AccountTeacher());

      case AppRoutes.kSubjectScreen:
        return MaterialPageRoute(builder: (_) => const LessonsScreen());

      case AppRoutes.kTeacherPhone:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<TeacherCubit>(),
            child: const Phoneteacher(),
          ),
        );

      case AppRoutes.kTeacherotb:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<TeacherCubit>(),
            child: const OtpScreen(),
          ),
        );

      case AppRoutes.kTeacherRegister:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<TeacherCubit>(),
            child: const RegisterTeacher(),
          ),
        );

      case AppRoutes.kTeacherLogin:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<TeacherCubit>(),
            child: const LoginTeacher(),
          ),
        );

      case AppRoutes.kTeachersecurity:
        final cvFile = settings.arguments as io.File;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<TeacherCubit>(),
            child: SecurityScreen(cvFile: cvFile),
          ),
        );

      case AppRoutes.knotificationTeacher:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<TeacherCubit>(),
            child: const NotificationsScreen(),
          ),
        );

      case AppRoutes.kTeacherprfile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<TeacherCubit>(),
            child: const TeacherProfil(),
          ),
        );

      case AppRoutes.kAddLesson:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<TeacherCubit>(),
            child: const AddLessonScreen(),
          ),
        );

   case AppRoutes.kDonationInfoScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<TeacherCubit>(),
            child: const DonationInfoScreen(),
          ),
        );
   case AppRoutes.kDonationPaymentScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<TeacherCubit>(),
            child: const DonationPaymentScreen(),
          ),
        );
   case AppRoutes.kTechnicalSupportScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<TeacherCubit>(),
            child: const TechnicalSupportScreen(),
          ),
        );
         case AppRoutes.kTest:
        return MaterialPageRoute(
          builder: (context) => const AddTestScreen(),
        );
 case AppRoutes.kQuizzes:
  final lessonId = settings.arguments as int;
  return MaterialPageRoute(
    builder: (_) => AddQuizScreen(lessonId: lessonId),
  );
      case AppRoutes.kStudentRegisterNumberScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<AuthCubit>(),
            child: const StudentRegisterNumberScreen(),
          ),
        );

      case AppRoutes.kStudentOTPScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<AuthCubit>(),
            child: const StudentOtpScreen(),
          ),
        );

      case AppRoutes.kStudentRegisterDataScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<AuthCubit>()),
              BlocProvider(create: (context) => LevelCubit()),
            ],
            child: const StudentRegisterDataScreen(),
          ),
        );

      case AppRoutes.kStudentRegisterPhotoScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<AuthCubit>(),
            child: const StudentRegisterPhotoScreen(),
          ),
        );

      case AppRoutes.kStudentLoginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<AuthCubit>(),
            child: const StudentLoginScreen(),
          ),
        );

      case AppRoutes.kStudentHomeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<AuthCubit>(),
            child: const StudentHomeScreen(),
          ),
        );

      case AppRoutes.kStudentMainScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<AuthCubit>(),
            child: const StudentMainScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
