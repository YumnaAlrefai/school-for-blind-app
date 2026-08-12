import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/data/datasource/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/logic/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'screens/technical_support_page.dart';
import 'screens/schedule_cell.dart';
import 'screens/notifications_page.dart';
import 'screens/donation_parent.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => AuthCubit(
        AuthRepository(
          AuthRemoteDataSource(),
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          fontFamily: 'ArabicTypesetting',
          useMaterial3: true,
        ),

        home: const LoginPage(),
      ),
    );
  }
}