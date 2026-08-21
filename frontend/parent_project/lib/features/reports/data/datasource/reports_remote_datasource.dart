import 'package:dio/dio.dart';
import 'package:parent_project/features/reports/data/models/subject_details_response_model.dart';
import 'package:parent_project/features/reports/data/models/yearly_reports_response_model.dart';

import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/dio_client.dart';
import '../models/excuse_response_model.dart';
import '../models/daily_reports_response_model.dart';
import '../models/monthly_reports_response_model.dart';
import '../models/objection_response_model.dart';

class ReportsRemoteDataSource {
  final Dio _dio = DioClient.dio;

  Future<DailyReportsResponseModel> getDailyReports() async {
    try {
      final response = await _dio.get(ApiEndpoints.reportsDaily);

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");

      return DailyReportsResponseModel.fromJson(response.data);
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
  Future<ExcuseResponseModel> submitAbsenceExcuse({
  required int studentId,
  required int roomId,
  required String reason,
}) async {
  try {
    final formData = FormData.fromMap({
      "student_id": studentId.toString(),
      "room_id": roomId.toString(),
      "reason": reason,
    });

    final response = await _dio.post(
      ApiEndpoints.submitAbsenceExcuse,
      data: formData,
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE DATA: ${response.data}");

    return ExcuseResponseModel.fromJson(response.data);
  } on DioException catch (e) {
    print("DIO ERROR TYPE: ${e.type}");
    print("DIO RESPONSE: ${e.response?.data}");
    print("DIO STATUS: ${e.response?.statusCode}");

    final data = e.response?.data;
    if (data != null && data["message"] != null) {
      throw ApiException(data["message"]);
    }
    throw ApiException(e.message ?? "Dio Error");
  } catch (e) {
    print("GENERAL ERROR: $e");
    throw ApiException(e.toString());
  }
}
Future<MonthlyReportsResponseModel> getMonthlyReports() async {
  try {
    final response = await _dio.get(ApiEndpoints.reportsMonthly);

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE DATA: ${response.data}");

    return MonthlyReportsResponseModel.fromJson(response.data);
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
Future<YearlyReportsResponseModel> getYearlyReports() async {
  try {
    final response = await _dio.get(ApiEndpoints.reportsYearly);

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE DATA: ${response.data}");

    return YearlyReportsResponseModel.fromJson(response.data);
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
Future<SubjectDetailsResponseModel> getSubjectDetails({
  required int studentId,
  required int subjectId,
}) async {
  try {
    final response = await _dio.get(
      ApiEndpoints.subjectDetails(studentId, subjectId),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE DATA: ${response.data}");

    return SubjectDetailsResponseModel.fromJson(response.data);
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
Future<ObjectionResponseModel> submitPunishmentObjection({
  required int studentId,
  required int punishableRecordId,
  required String reason,
}) async {
  try {
    final formData = FormData.fromMap({
      "student_id": studentId.toString(),
      "punishable_record_id": punishableRecordId.toString(),
      "reason": reason,
    });

    final response = await _dio.post(
      ApiEndpoints.submitPunishmentObjection,
      data: formData,
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE DATA: ${response.data}");

    return ObjectionResponseModel.fromJson(response.data);
  } on DioException catch (e) {
    print("DIO ERROR TYPE: ${e.type}");
    print("DIO RESPONSE: ${e.response?.data}");
    print("DIO STATUS: ${e.response?.statusCode}");

    final data = e.response?.data;
    if (data != null && data["message"] != null) {
      throw ApiException(data["message"]);
    }
    throw ApiException(e.message ?? "Dio Error");
  } catch (e) {
    print("GENERAL ERROR: $e");
    throw ApiException(e.toString());
  }
}
}