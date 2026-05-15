import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/core/helpers/secure_storage.dart';
import 'package:school_for_blind_app/core/services/deep_link_service.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/data/repository/auth_repo.dart';
import 'package:school_for_blind_app/data/web_services/auth_web_services.dart';

final getIt = GetIt.instance;

void initGetIt() {
  getIt.registerFactory<AuthRepo>(() => AuthRepo(getIt()));
  getIt.registerLazySingleton<AuthCubit>(() => AuthCubit(getIt()));
  getIt.registerLazySingleton<WebServices>(
    () => WebServices(createAndSetupDio()),
  );
  getIt.registerLazySingleton<VoiceServices>(() => VoiceServices());
  getIt.registerSingleton<DeepLinkService>(DeepLinkService());
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
