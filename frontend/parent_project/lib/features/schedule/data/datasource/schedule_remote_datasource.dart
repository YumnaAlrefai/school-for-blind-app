import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/dio_client.dart';

import '../models/schedule_response_model.dart';

class ScheduleRemoteDataSource {
  final Dio _dio = DioClient.dio;

  Future<ScheduleResponseModel> getSchedule() async {
    try {
      final response = await _dio.get(ApiEndpoints.schedule);

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");

      return ScheduleResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print("DIO ERROR TYPE: ${e.type}");
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