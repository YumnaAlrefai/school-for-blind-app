import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/dio_client.dart';

import '../models/announcement_model.dart';
import '../models/exam_schedule_detail_model.dart';

class AnnouncementsRemoteDataSource {
  final Dio _dio = DioClient.dio;

  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      final response = await _dio.get(ApiEndpoints.announcements);

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");

      return (response.data as List)
          .map((e) => AnnouncementModel.fromJson(e))
          .toList();
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

  Future<ExamScheduleDetailModel> getExamScheduleDetail(int id) async {
    try {
      final response = await _dio.get(ApiEndpoints.examScheduleDetail(id));

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");

      return ExamScheduleDetailModel.fromJson(response.data);
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