import 'package:dio/dio.dart';
import 'package:parent_project/features/auth/data/models/logout_response_model.dart';

import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/dio_client.dart';

import '../../../auth/data/models/login_request_model.dart';
import '../../../auth/data/models/login_response_model.dart';


class AuthRemoteDataSource {

  final Dio _dio = DioClient.dio;

Future<LoginResponseModel> login(
    LoginRequestModel request
) async {

  try {

    final response = await _dio.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE DATA: ${response.data}");

    return LoginResponseModel.fromJson(
      response.data,
    );


  } on DioException catch(e) {

    print("DIO ERROR TYPE: ${e.type}");
    print("DIO ERROR MESSAGE: ${e.message}");
    print("DIO RESPONSE: ${e.response?.data}");
    print("DIO STATUS: ${e.response?.statusCode}");

    throw ApiException(
      e.response?.data["message"] ??
      e.message ??
      "Dio Error",
    );


  } catch(e){

    print("GENERAL ERROR: $e");

    throw ApiException(
      e.toString(),
    );

  }

}
Future<LogoutResponseModel> logout() async {
  try {
    final response = await _dio.post(ApiEndpoints.logout);

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE DATA: ${response.data}");

    return LogoutResponseModel.fromJson(response.data);
  } on DioException catch (e) {
    print("DIO ERROR TYPE: ${e.type}");
    print("DIO ERROR MESSAGE: ${e.message}");
    print("DIO RESPONSE: ${e.response?.data}");
    print("DIO STATUS: ${e.response?.statusCode}");

    throw ApiException(
      e.response?.data["message"] ?? e.message ?? "Dio Error",
    );
  } catch (e) {
    print("GENERAL ERROR: $e");
    throw ApiException(e.toString());
  }
}
}