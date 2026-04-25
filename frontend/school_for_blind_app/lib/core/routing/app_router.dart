import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/role_cubit.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/presentation/screens/splash_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_accounts_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher_accounts_screen.dart';
import 'package:school_for_blind_app/presentation/screens/user_type_screen.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.kSplashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
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
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
