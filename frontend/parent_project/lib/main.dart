import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:parent_project/Widget/theme_controller.dart';

import 'features/technical_support/data/datasource/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/logic/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await ThemeController.instance.init();
  Stripe.publishableKey = "pk_test_51U4uC21TqNZeXVPp7hQZ4OcBokMpyxhJ1fMA6b4jW7XTXQWhazsErs8ZwztCwqwOn60poPfdJD66Hpx4Ws9aVXhY008yHSXBoS"; // مفتاح Stripe العام (Publishable Key)
  await Stripe.instance.applySettings();

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