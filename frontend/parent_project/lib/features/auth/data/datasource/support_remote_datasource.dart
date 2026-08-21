import 'dart:io';
import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/dio_client.dart';

import '../../../technical_support/data/models/support_ticket_response_model.dart';

class SupportRemoteDataSource {
  final Dio _dio = DioClient.dio;

  Future<SupportTicketResponseModel> sendTicket({
    required String message,
    File? image,
    File? audio,
  }) async {
    try {
      final formData = FormData.fromMap({
        "message": message,
        if (image != null)
          "image": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        if (audio != null)
          "audio": await MultipartFile.fromFile(
            audio.path,
            filename: audio.path.split('/').last,
          ),
      });

      final response = await _dio.post(
        ApiEndpoints.supportTicket,
        data: formData,
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");

      return SupportTicketResponseModel.fromJson(response.data);
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