import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:school_for_blind_app/business_logic/cubit/audio_bookmarks_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/call_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/donation_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/lesson_records_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/offline_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/offline_saved_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/quiz_info_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/quiz_questions_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/quiz_submission_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/saved_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/saves_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/subject_progress_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/theme_cubit.dart';
import 'package:school_for_blind_app/core/helpers/secure_storage.dart';
import 'package:school_for_blind_app/core/services/deep_link_service.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/data/web_services/student_web_services.dart';

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
  getIt.registerFactory<OfflineSavedLessonsCubit>(
    () => OfflineSavedLessonsCubit(),
  );
  getIt.registerFactory<AudioBookmarksCubit>(() => AudioBookmarksCubit());
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
        // String? token = await SecureStorage.getToken();
        // if (token != null && token.isNotEmpty) {
        //   options.headers['Authorization'] = 'Bearer $token';
        //}
        options.headers['Authorization'] =
            'Bearer 23|b8TPrk3IFD0uJLXxnBnsr1cTkrXfxvX69t7oazL9819966da';
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

  return dio;
}
