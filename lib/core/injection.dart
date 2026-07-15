import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/apiTeacher/web_services.dart'
    as teacher_api;
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher_cubit.dart';
import 'package:school_for_blind_app/core/helpers/secure_storage.dart';
import 'package:school_for_blind_app/core/services/deep_link_service.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/theme_cubit.dart';
import 'package:school_for_blind_app/data/repository/auth_repo.dart';
import 'package:school_for_blind_app/data/web_services/auth_web_services.dart';


final getIt = GetIt.instance;

void initGetIt() {
  // ===== 1) الخدمات (WebServices) — تُسجّل أولاً =====
  getIt.registerLazySingleton<WebServices>(
    () => WebServices(createAndSetupDio()),
  );
  getIt.registerLazySingleton<teacher_api.WebServices>(
    () => teacher_api.WebServices(createAndSetupDio()),
  );
  getIt.registerLazySingleton<VoiceServices>(() => VoiceServices());
  getIt.registerSingleton<DeepLinkService>(DeepLinkService());

  // ===== 2) الـ Repositories (تعتمد على WebServices) =====
  getIt.registerFactory<AuthRepo>(() => AuthRepo(getIt()));
  getIt.registerFactory<TeacherRepo>(
    () => TeacherRepo(getIt<teacher_api.WebServices>()),
  );

  // ===== 3) الـ Cubits (تعتمد على الـ Repos) — تُسجّل أخيراً =====
  getIt.registerLazySingleton<AuthCubit>(() => AuthCubit(getIt()));
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerLazySingleton<TeacherCubit>(() => TeacherCubit(getIt()));
  getIt.registerLazySingleton<LessonsCubit>(
    () => LessonsCubit(getIt<TeacherRepo>()),
  );
}

Dio createAndSetupDio() {
  Dio dio = Dio();
  dio
    ..options.connectTimeout = const Duration(seconds: 30)
    ..options.receiveTimeout = const Duration(minutes: 5)
    ..options.sendTimeout = const Duration(minutes: 5);

  dio.options.headers['Accept'] = 'application/json';
  dio.options.headers['Content-Type'] = 'application/json';

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await SecureStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
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