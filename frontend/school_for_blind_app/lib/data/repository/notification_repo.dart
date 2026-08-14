import 'package:school_for_blind_app/data/models/notifications_response_model.dart';
import 'package:school_for_blind_app/data/web_services/student_web_services.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

class NotificationRepo {
  final StudentWebServices webServices;
  NotificationRepo(this.webServices);

  Future<ApiResult<bool>> sendFcmToken(String fcmToken) async {
    try {
      final response = await webServices.sendFcmToken({'fcm_token': fcmToken});
      return ApiResult.success(response['success'] == true);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<bool>> deleteFcmToken(String fcmToken) async {
    try {
      final response = await webServices.deleteFcmToken({
        'fcm_token': fcmToken,
      });
      return ApiResult.success(response['success'] == true);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<NotificationsResponse>> getNotifications() async {
    try {
      final response = await webServices.getNotifications();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }
}
