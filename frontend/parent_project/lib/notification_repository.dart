import 'package:dio/dio.dart';
import 'notification_model.dart';

class NotificationRepository {
  final Dio dio;
  NotificationRepository(this.dio);

  Future<void> sendFcmToken(String token) async {
    await dio.post('fcm-token', data: {'fcm_token': token});
  }

  Future<void> deleteFcmToken(String token) async {
    await dio.delete('fcm-token', data: {'fcm_token': token});
  }

  Future<NotificationsResponse> getNotifications() async {
    final response = await dio.get('notifications');
    return NotificationsResponse.fromJson(response.data);
  }
}
