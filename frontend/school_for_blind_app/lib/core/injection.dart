import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/audio_bookmarks_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/call_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/channels_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/donation_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/exam_questions_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/exam_submission_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/exams_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/lesson_records_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/messages_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/offline_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/offline_saved_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/past_exam_solutions_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/past_exams_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/quiz_info_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/quiz_questions_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/quiz_submission_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saved_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saved_past_exams_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saves_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/schedule_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/student_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/subject_progress_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/support_ticket_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/theme_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher/teacher_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher/teacher_lessons_cubit.dart';
import 'package:school_for_blind_app/core/helpers/secure_storage.dart';
import 'package:school_for_blind_app/core/services/deep_link_service.dart';
import 'package:school_for_blind_app/core/services/realtime_service.dart';
import 'package:school_for_blind_app/core/services/server_time_interceptor.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/data/repository/teacher_repo.dart';
import 'package:school_for_blind_app/data/web_services/student_web_services.dart';
import 'package:school_for_blind_app/data/web_services/teacher_web_services.dart';

final getIt = GetIt.instance;

void initGetIt() {
  getIt.registerFactory<StudentRepo>(() => StudentRepo(getIt()));
  getIt.registerLazySingleton<AuthCubit>(() => AuthCubit(getIt()));
  getIt.registerLazySingleton<StudentWebServices>(
    () => StudentWebServices(createAndSetupDio()),
  );
  getIt.registerLazySingleton<VoiceServices>(() => VoiceServices());
  getIt.registerSingleton<DeepLinkService>(DeepLinkService());
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerLazySingleton<StudentCubit>(() => StudentCubit(getIt()));
  getIt.registerLazySingleton<CallCubit>(() => CallCubit(getIt()));
  getIt.registerLazySingleton<DonationCubit>(() => DonationCubit(getIt()));
  getIt.registerFactory<SubjectProgressCubit>(
    () => SubjectProgressCubit(getIt()),
  );
  getIt.registerFactory<LessonsCubit>(() => LessonsCubit(getIt()));
  getIt.registerFactory<LessonRecordsCubit>(
    () => LessonRecordsCubit(getIt<StudentRepo>()),
  );
  getIt.registerFactory<OfflineLessonsCubit>(() => OfflineLessonsCubit());
  getIt.registerFactory<QuizInfoCubit>(() => QuizInfoCubit(getIt()));
  getIt.registerFactory<QuizQuestionsCubit>(() => QuizQuestionsCubit(getIt()));
  getIt.registerFactory<QuizSubmissionCubit>(
    () => QuizSubmissionCubit(getIt()),
  );
  getIt.registerFactory<SavesCubit>(() => SavesCubit(getIt()));
  getIt.registerFactory<SavedLessonsCubit>(
    () => SavedLessonsCubit(getIt<StudentRepo>()),
  );
  getIt.registerFactory(() => SavedPastExamsCubit(getIt<StudentRepo>()));
  getIt.registerFactory<OfflineSavedLessonsCubit>(
    () => OfflineSavedLessonsCubit(),
  );
  getIt.registerFactory<AudioBookmarksCubit>(
    () => AudioBookmarksCubit(studentRepo: getIt<StudentRepo>()),
  );
  getIt.registerFactory<SupportTicketCubit>(
    () => SupportTicketCubit(getIt<StudentRepo>()),
  );
  getIt.registerFactory(() => PastExamsCubit(getIt<StudentRepo>()));
  getIt.registerFactory(() => PastExamSolutionsCubit(getIt<StudentRepo>()));
  getIt.registerFactory(() => ChannelsCubit(getIt<StudentRepo>()));
  getIt.registerFactory(() => MessagesCubit(getIt<StudentRepo>()));
  getIt.registerLazySingleton<RealtimeService>(() => RealtimeService());
  getIt.registerFactory<ExamsCubit>(() => ExamsCubit(getIt<StudentRepo>()));
  getIt.registerFactory<ExamQuestionsCubit>(() => ExamQuestionsCubit(getIt()));
  getIt.registerFactory<ExamSubmissionCubit>(
    () => ExamSubmissionCubit(getIt()),
  );
  getIt.registerFactory<ScheduleCubit>(
    () => ScheduleCubit(getIt<StudentRepo>()),
  );

  getIt.registerLazySingleton<TeacherWebServices>(
    () => TeacherWebServices(createAndSetupDio()),
  );
  getIt.registerLazySingleton<VoiceServices>(() => VoiceServices());
  getIt.registerSingleton<DeepLinkService>(DeepLinkService());

  getIt.registerFactory<TeacherRepo>(
    () => TeacherRepo(getIt<TeacherWebServices>()),
  );

  getIt.registerLazySingleton<AuthCubit>(() => AuthCubit(getIt()));
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerLazySingleton<TeacherCubit>(() => TeacherCubit(getIt()));
  getIt.registerLazySingleton<TeacherLessonsCubit>(
    () => TeacherLessonsCubit(getIt<TeacherRepo>()),
  );
}

Dio createAndSetupDio() {
  Dio dio = Dio();
  dio
    ..options.connectTimeout = Duration(seconds: 30)
    ..options.receiveTimeout = Duration(seconds: 30);

  dio.options.headers['Accept'] = 'application/json';
  dio.options.headers['Content-Type'] = 'application/json';

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await SecureStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        // options.headers['Authorization'] =
        //     'Bearer 45|91Qn2MYeXaDIARxLUJvWMct15nEYZxzdjvwDBpwz76b53103';
        options.headers["ngrok-skip-browser-warning"] = "true";
        return handler.next(options);
      },
    ),
  );
  dio.interceptors.add(
    LogInterceptor(
      responseBody: true,
      error: true,
      requestHeader: false,
      responseHeader: false,
      request: true,
      requestBody: true,
    ),
  );
  dio.interceptors.add(ServerTimeInterceptor());
  return dio;
}
