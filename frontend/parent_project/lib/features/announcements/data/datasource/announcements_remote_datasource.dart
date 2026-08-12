import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/dio_client.dart';

import '../models/announcement_list_item_model.dart';
import '../models/announcement_detail_model.dart';

class AnnouncementsRemoteDataSource {
  final Dio _dio = DioClient.dio;

  Future<List<AnnouncementListItemModel>> getAnnouncements() async {
    try {
      final response = await _dio.get(ApiEndpoints.announcementsList);

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");

      final data = response.data;

      // السيرفر يرجع Array مباشرة، أو Map فيها "message" لو فاضي
      if (data is List) {
        return data.map((e) => AnnouncementListItemModel.fromJson(e)).toList();
      }
      return [];
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

  Future<AnnouncementDetailModel> getAnnouncementDetail({
    required int id,
    required String type,
  }) async {
    try {
      final path = type == 'exam_schedule'
          ? ApiEndpoints.announcementExamDetail(id)
          : ApiEndpoints.announcementTimetableDetail(id);

      final response = await _dio.get(path);

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");

      return AnnouncementDetailModel.fromJson(response.data, type);
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