import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/level_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/role_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/presentation/screens/splash_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_accounts_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_home_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_login_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_main_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_otp_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_register_data_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_register_number_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_register_photo_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher_accounts_screen.dart';
import 'package:school_for_blind_app/presentation/screens/user_type_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final authCubit = getIt<AuthCubit>();

    switch (settings.name) {
      case AppRoutes.kSplashScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider.value(value: authCubit, child: const SplashScreen()),
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
        return MaterialPageRoute(builder: (_) => const TeacherAccountsScreen());

      case AppRoutes.kStudentRegisterNumberScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
            child: const StudentRegisterNumberScreen(),
          ),
        );
      case AppRoutes.kStudentOTPScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
            child: const StudentOtpScreen(),
          ),
        );
      case AppRoutes.kStudentRegisterDataScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: authCubit),
              BlocProvider(create: (context) => LevelCubit()),
            ],
            child: const StudentRegisterDataScreen(),
          ),
        );
      case AppRoutes.kStudentRegisterPhotoScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
            child: const StudentRegisterPhotoScreen(),
          ),
        );
      case AppRoutes.kStudentLoginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
            child: const StudentLoginScreen(),
          ),
        );
      case AppRoutes.kStudentHomeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
            child: const StudentHomeScreen(),
          ),
        );
      case AppRoutes.kStudentMainScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
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
