import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/local_notifications_service.dart';
import 'package:school_for_blind_app/data/repository/notification_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class PushNotificationsService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String? _cachedToken;

  static Future init() async {
    await firebaseMessaging.requestPermission();

    String? token = await firebaseMessaging.getToken();
    _cachedToken = token;

    if (token != null) {
      log('FCM TOKEN: $token');
      await sendFcmTokenToServer(token);
    }

    firebaseMessaging.onTokenRefresh.listen((newToken) async {
      _cachedToken = newToken;
      log('FCM TOKEN REFRESHED: $newToken');
      await sendFcmTokenToServer(newToken);
    });

    FirebaseMessaging.onBackgroundMessage(handleOnBackgroundMessage);
    handleOnForegroundMessage();
  }

  static Future<void> sendFcmTokenToServer(String token) async {
    final result = await getIt<NotificationRepo>().sendFcmToken(token);
    result.when(
      success: (_) => log('FCM Token sent successfully'),
      failure: (error) => log('FCM Token send failed: $error'),
    );
  }

  static Future<void> deleteFcmTokenFromServer() async {
    final token = _cachedToken ?? await firebaseMessaging.getToken();
    if (token == null) return;
    final result = await getIt<NotificationRepo>().deleteFcmToken(token);
    result.when(
      success: (_) => log('FCM Token deleted successfully'),
      failure: (error) => log('FCM Token delete failed: $error'),
    );
  }

  static Future<void> registerTokenAfterLogin() async {
    final token = _cachedToken ?? await firebaseMessaging.getToken();
    if (token != null) {
      await sendFcmTokenToServer(token);
    }
  }

  static Future<void> handleOnBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? 'null');
  }

  static void handleOnForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      LocalNotificationsService.showBasicNotification(msg);
    });
  }
}
