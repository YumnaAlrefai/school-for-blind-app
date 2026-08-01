import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/call_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/donation_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/level_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/messages_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/role_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saves_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/schedule_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/student_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/subject_progress_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher/teacher_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/data/models/student/lesson.dart';
import 'package:school_for_blind_app/data/models/student/record_model.dart';
import 'package:school_for_blind_app/presentation/screens/student/splash_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_accounts_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_announcements_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_audio_player_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_contact_support_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_exam_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_exams_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_library_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_messages_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_payment_intent_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_payment_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_lesson_records_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_live_call_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_quiz_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_schedule_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_subject_details_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_waiting_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_whatsapp_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_login_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_main_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_otp_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_profile_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_register_data_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_register_number_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_register_photo_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/teacher_accounts_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/user_type_screen.dart';
import 'package:school_for_blind_app/presentation/screens/student/student_past_exam_solutions_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/add_bank_questions_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/add_lessons_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/donation_info_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/donation_payment_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/edit_quiz_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/grade_student_answers_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/question_bank_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/quiz_submissions_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/school_timetable_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/statistics_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_announcements_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_channel_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_channels_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_chats_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_groups_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_login_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_notifications_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_otp_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_profile_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_quize_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_register_number_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_register_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_safenumber_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_test_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/technical_support_screen.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/view_exam_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final authCubit = getIt<AuthCubit>();
    final studentCubit = getIt<StudentCubit>();
    final callCubit = getIt<CallCubit>();
    final subjectProgressCubit = getIt<SubjectProgressCubit>();

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

      case AppRoutes.kStudentMessagesScreen:
        final args = settings.arguments as Map<String, dynamic>?;

        if (args == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('خطأ في تمرير البيانات')),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<MessagesCubit>(),
            child: StudentMessagesScreen(
              channelId: args['channelId'],
              channelName: args['channelName'],
              currentUserId: args['currentUserId'],
              icon: args['icon'],
              isChannel: args['isChannel'],
            ),
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
      case AppRoutes.kStudentExamsScreen:
        final args = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => StudentExamsScreen(subjectId: args),
        );
      case AppRoutes.kStudentExamScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => StudentExamScreen(
            examId: args['examId'],
            totalQuestions: args['totalQuestions'],
            durationMinutes: args['durationMinutes'],
            examDate: args['examDate'],
            subjectId: args['subjectId'],
          ),
        );
      case AppRoutes.kStudentLibraryScreen:
        final args = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => StudentLibraryScreen(subjectId: args),
        );
      case AppRoutes.kStudentPastExamSolutionsScreen:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => PastExamSolutionsScreen(
            examId: args['examId'],
            title: args['title'],
          ),
        );
      case AppRoutes.kStudentScheduleScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => getIt<ScheduleCubit>()..emitGetSchedule(),
            child: const StudentScheduleScreen(),
          ),
        );








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
        final args = (settings.arguments as Map<String, dynamic>?) ?? {};
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<TeacherCubit>(),
            child: DonationPaymentScreen(
              donorName: (args['name'] ?? '') as String,
              amount: (args['amount'] ?? 0) as num,
            ),
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
        return MaterialPageRoute(builder: (context) => const AddTestScreen());
      case AppRoutes.kQuizzes:
        final lessonId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => AddQuizScreen(lessonId: lessonId),
        );

      case AppRoutes.kQuestionBank:
        return MaterialPageRoute(builder: (_) => const QuestionBankScreen());

      case AppRoutes.kAddBankQuestions:
        return MaterialPageRoute(
          builder: (_) => const AddBankQuestionsScreen(),
        );

      case AppRoutes.kEditQuiz:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EditQuizScreen(
            quizId: args['quizId'] as int,
            lessonTitle: (args['lessonTitle'] ?? '') as String,
          ),
        );

      case AppRoutes.kViewExam:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ViewExamScreen(
            examId: args['examId'] as int,
            examTitle: (args['examTitle'] ?? '') as String,
          ),
        );
      case AppRoutes.kQuizSubmissions:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => QuizSubmissionsScreen(
            quizId: args['quizId'] as int,
            quizTitle: (args['quizTitle'] ?? '') as String,
          ),
        );

      case AppRoutes.kGradeStudentAnswers:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => GradeStudentAnswersScreen(
            quizId: args['quizId'] as int,
            studentId: args['studentId'] as int,
            studentName: (args['studentName'] ?? '') as String,
          ),
        );

      case AppRoutes.kSchoolTimetable:
        return MaterialPageRoute(builder: (_) => const TeacherScheduleScreen());

      case AppRoutes.kStatistics:
        return MaterialPageRoute(builder: (_) => const StatisticsScreen());
      case AppRoutes.kTeacherChats:
        return MaterialPageRoute(builder: (_) => const TeacherChatsScreen());
      case AppRoutes.kTeacherChannels:
        return MaterialPageRoute(builder: (_) => const TeacherChannelsScreen());

      case AppRoutes.kTeacherChannel:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TeacherChannelScreen(
            channelId: args['channelId'] as int,
            channelName: (args['channelName'] ?? '') as String,
          ),
        );
      case AppRoutes.kTeacherGroups:
        return MaterialPageRoute(builder: (_) => const TeacherGroupsScreen());
      case AppRoutes.kTeacherAnnouncements:
        return MaterialPageRoute(
          builder: (_) => const TeacherAnnouncementsScreen(),
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
