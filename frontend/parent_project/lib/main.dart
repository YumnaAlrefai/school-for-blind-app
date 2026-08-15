import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/core/api/dio_client.dart';
import 'package:parent_project/local_notifications_service.dart';
import 'package:parent_project/notification_cubit.dart';
import 'package:parent_project/notification_repository.dart';
import 'package:parent_project/push_notifications_service.dart';

import 'features/auth/data/datasource/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/logic/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'screens/technical_support_page.dart';
import 'screens/schedule_cell.dart';
import 'notifications_page.dart';
import 'screens/donation_parent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalNotificationsService.init();

  final notificationCubit = NotificationCubit(
    NotificationRepository(DioClient.dio),
  );

  PushNotificationsService.notificationCubit = notificationCubit;

  await PushNotificationsService.init();

  runApp(BlocProvider.value(value: notificationCubit, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthRepository(AuthRemoteDataSource())),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(fontFamily: 'ArabicTypesetting', useMaterial3: true),

        home: const LoginPage(),
      ),
    );
  }
}
