import 'package:dio/dio.dart';
import 'package:parent_project/core/api/api_endpoints.dart';
import 'package:parent_project/core/api/api_exception.dart';
import 'package:parent_project/core/api/dio_client.dart';
import '../models/donation_checkout_response_model.dart';
import '../models/donation_confirm_response_model.dart';

class DonationRemoteDataSource {
  final Dio dio = DioClient.dio;

  
  Future<DonationCheckoutResponseModel> checkout({
    required double amount,
    String? name,
  }) async {
    try {
      final Map<String, dynamic> body = {"amount": amount};
      if (name != null && name.trim().isNotEmpty) {
        body["name"] = name.trim();
      }

      final response = await dio.post(
        ApiEndpoints.donationCheckout,
        data: body,
       
      );
      return DonationCheckoutResponseModel.fromJson(response.data);
    } catch (e) {
      print('Donation checkout error: $e');
      throw ApiException('حدث خطأ أثناء بدء عملية التبرع');
    }
  }

  Future<DonationConfirmResponseModel> confirm(String paymentIntentId) async {
    try {
      final response = await dio.post(
        ApiEndpoints.donationConfirm,
        data: {"payment_intent_id": paymentIntentId},
      );
      return DonationConfirmResponseModel.fromJson(response.data);
    } catch (e) {
      print('Donation confirm error: $e');
      throw ApiException('حدث خطأ أثناء تأكيد عملية التبرع');
    }
  }
}