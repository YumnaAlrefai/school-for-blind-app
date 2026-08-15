import 'package:dio/dio.dart';
import 'package:parent_project/core/utils/token_storage.dart';

class DioClient {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: "https://stays-ability-accustom.ngrok-free.dev/api/",
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            headers: {"Accept": "application/json"},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await TokenStorage.getToken();
              print("TOKEN BEING SENT: $token");
              print("REQUEST URL: ${options.uri}");
              if (token != null) {
                options.headers["Authorization"] = "Bearer $token";
              }
              return handler.next(options);
            },
          ),
        );
}
