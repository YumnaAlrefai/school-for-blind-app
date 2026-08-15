import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:parent_project/core/utils/token_storage.dart';
import 'package:parent_project/local_notifications_service.dart';
import 'package:parent_project/notification_cubit.dart';

class PushNotificationsService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String? _cachedToken;
  static NotificationCubit? notificationCubit;

  static Future init() async {
    await firebaseMessaging.requestPermission();
    String? token = await firebaseMessaging.getToken();
    _cachedToken = token;
    if (token != null) {
      log('FCM TOKEN: $token');
    }
    firebaseMessaging.onTokenRefresh.listen((newToken) async {
      _cachedToken = newToken;
      final authToken = await TokenStorage.getToken();
      if (authToken != null) {
        await sendFcmTokenToServer(newToken);
      }
    });
    FirebaseMessaging.onBackgroundMessage(handleOnBackgroundMessage);
    handleOnForegroundMessage();
  }

  static Future<void> sendFcmTokenToServer(String token) async {
    if (notificationCubit == null) return;
    await notificationCubit!.sendToken(token);
  }

  static Future<void> deleteFcmTokenFromServer() async {
    final token = _cachedToken ?? await firebaseMessaging.getToken();
    if (token == null || notificationCubit == null) return;
    await notificationCubit!.deleteToken(token);
  }

  static Future<void> registerTokenAfterLogin() async {
    final token = _cachedToken ?? await firebaseMessaging.getToken();
    if (token != null) await sendFcmTokenToServer(token);
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
