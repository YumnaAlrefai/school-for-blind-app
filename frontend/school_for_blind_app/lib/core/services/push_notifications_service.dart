import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';

class PushNotificationsService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future init() async {
    await firebaseMessaging.requestPermission();

    String? token = await firebaseMessaging.getToken();

    if (token != null) {
      log('FCM TOKEN: $token');
      sendFcmTokenToServer(token);
    }

    firebaseMessaging.onTokenRefresh.listen((value) {
      sendFcmTokenToServer(value);
    });

    FirebaseMessaging.onBackgroundMessage(handleOnBackgroundMessage);
    handleOnForegroundMessage();
  }

  static Future<void> handleOnBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? 'null');
  }

  static void handleOnForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      showCustomInAppNotification(
        title: msg.notification?.title ?? 'إشعار جديد',
        body: msg.notification?.body ?? '',
      );
    });
  }

  static void showCustomInAppNotification({
    required String title,
    required String body,
  }) {
    showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        color: Theme.of(context).colorScheme.surface,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: 0.2,
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.notifications_active,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 40.sp,
            ),
          ),
          subtitle: Text(
            body,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 34.sp,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.onSurface,
              size: 32,
            ),
            onPressed: () {
              OverlaySupportEntry.of(context)?.dismiss();
            },
          ),
        ),
      );
    }, duration: const Duration(seconds: 10));
  }

  static void sendFcmTokenToServer(String token) {}
}
