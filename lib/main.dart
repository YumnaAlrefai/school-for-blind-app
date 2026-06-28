import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/deep_link_service.dart';
import 'core/routing/app_router.dart';
import 'school_for_blind.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initGetIt();
  getIt<DeepLinkService>().initDeepLinks();
  runApp(SchoolForBlind(appRouter: AppRouter(), navigatorKey: navigatorKey));
}
