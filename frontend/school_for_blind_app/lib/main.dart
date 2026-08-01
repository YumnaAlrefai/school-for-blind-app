import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/theme_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/deep_link_service.dart';
import 'core/routing/app_router.dart';
import 'school_for_blind.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Stripe.publishableKey =
      "pk_test_51TkNlpHb6vvSAewAX80goBxYkrKudKIvMMUJWCWUtfBtz34M6b7nSkK856iN4VelOTa5A691otg1gYWZ7NU0GhCn00M54djgTI";
  await Stripe.instance.applySettings();

  initGetIt();
  getIt<DeepLinkService>().initDeepLinks();

  runApp(
    BlocProvider(
      create: (context) => getIt<ThemeCubit>(),
      child: SchoolForBlind(appRouter: AppRouter(), navigatorKey: navigatorKey),
    ),
  );
}
