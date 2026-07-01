import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/call_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/donation_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/lesson_records_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/lessons_cubit.dart';
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
        // }
        options.headers['Authorization'] =
            'Bearer 29|JAvvzVseKOFMX9rdl07WMlCgvghkyh12zdeSLtUWc3d0716a';
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
