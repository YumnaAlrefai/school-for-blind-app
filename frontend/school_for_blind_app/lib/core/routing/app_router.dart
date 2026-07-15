import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/call_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/donation_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/level_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/role_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/saves_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/subject_progress_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/data/models/lesson.dart';
import 'package:school_for_blind_app/data/models/record_model.dart';
import 'package:school_for_blind_app/presentation/screens/splash_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_accounts_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_announcements_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_audio_player_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_contact_support_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_library_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_payment_intent_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_payment_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_lesson_records_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_live_call_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_quiz_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_subject_details_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_waiting_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_whatsapp_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_login_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_main_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_otp_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_profile_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_register_data_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_register_number_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student_register_photo_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher_accounts_screen.dart';
import 'package:school_for_blind_app/presentation/screens/user_type_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final authCubit = getIt<AuthCubit>();
    final studentCubit = getIt<StudentCubit>();
    final callCubit = getIt<CallCubit>();
    final subjectProgressCubit = getIt<SubjectProgressCubit>();

    switch (settings.name) {
      // case AppRoutes.kSplashScreen:
      //   return MaterialPageRoute(
      //     builder: (_) =>
      //         BlocProvider.value(value: authCubit, child: const SplashScreen()),
      //   );
      case AppRoutes.kSUserTypeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => RoleCubit(),
            child: const UserTypeScreen(),
          ),
        );
      case AppRoutes.kTeacherAccountsScreen:
        return MaterialPageRoute(builder: (_) => const TeacherAccountsScreen());
      case AppRoutes.kStudentAccountsScreen:
        return MaterialPageRoute(builder: (_) => const StudentAccountsScreen());
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
      case AppRoutes.kStudentWhatsappScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
            child: const StudentWhatsappScreen(),
          ),
        );
      case AppRoutes.kStudentWaitingScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
            child: const StudentWaitingScreen(),
          ),
        );

      case AppRoutes.kStudentMainScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: authCubit),
              BlocProvider.value(value: studentCubit),
              BlocProvider.value(value: callCubit),
              BlocProvider.value(value: subjectProgressCubit),
            ],
            child: const StudentMainScreen(),
          ),
        );
      case AppRoutes.kStudentProfileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
            child: const StudentProfileScreen(),
          ),
        );
      case AppRoutes.kStudentContactSupportScreen:
        return MaterialPageRoute(
          builder: (_) => const StudentContactSupportScreen(),
        );
      case AppRoutes.kStudentPaymentIntentScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<DonationCubit>.value(
            value: getIt<DonationCubit>(),
            child: const StudentPaymentIntentScreen(),
          ),
        );
      case AppRoutes.kStudentPaymentScreen:
        final args = settings.arguments as List<String>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<DonationCubit>.value(
            value: getIt<DonationCubit>(),
            child: StudentPaymentScreen(
              clientSecret: args[0],
              paymentIntentId: args[1],
            ),
          ),
        );

      case AppRoutes.kStudentLiveCallScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: callCubit,
            child: StudentLiveCallScreen(),
          ),
        );

      case AppRoutes.kStudentSubjectDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => StudentSubjectDetailsScreen(
            subjectId: args['subjectId'] as int,
            subjectName: args['subjectName'] as String,
          ),
        );
      case AppRoutes.kStudentLessonRecordsScreen:
        dynamic lesson;
        bool isOffline = false;
        String subjectName = '';
        SavesCubit? savesCubit;

        final args = settings.arguments;

        if (args is Map<String, dynamic>) {
          lesson = args['lesson'];
          isOffline = args['isOffline'] as bool? ?? false;
          subjectName = args['subjectName'] as String? ?? '';
          savesCubit = args['savesCubit'] as SavesCubit?;
        } else if (args is Lesson) {
          lesson = args;
          isOffline = false;
        } else if (args is List<Lesson> && args.isNotEmpty) {
          lesson = args.first;
          isOffline = false;
        }

        if (lesson == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('خطأ في تحميل بيانات الدرس')),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => savesCubit != null
              ? BlocProvider.value(
                  value: savesCubit,
                  child: StudentLessonRecordsScreen(
                    subjectName: subjectName,
                    lesson: lesson,
                    isOffline: isOffline,
                  ),
                )
              : StudentLessonRecordsScreen(
                  subjectName: subjectName,
                  lesson: lesson,
                  isOffline: isOffline,
                ),
        );

      case AppRoutes.kStudentAudioPlayerScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => StudentAudioPlayerScreen(
            lessonName: args["lessonName"] as String,
            record: args['record'] as RecordModel,
            lessonId: args['lessonId'] as int,
            isOffline: args['isOffline'] as bool? ?? false,
          ),
        );

      case AppRoutes.kStudentAnnouncementsScreen:
        return MaterialPageRoute(builder: (_) => StudentAnnouncementsScreen());

      case AppRoutes.kStudentQuizScreen:
        final args = settings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (_) => StudentQuizScreen(
            subjectId: args[0],
            subjectName: args[1],
            quizId: args[2],
            totalQuestions: args[3],
            durationMinutes: args[4],
          ),
        );
      case AppRoutes.kStudentLibraryScreen:
        return MaterialPageRoute(builder: (_) => StudentLibraryScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
