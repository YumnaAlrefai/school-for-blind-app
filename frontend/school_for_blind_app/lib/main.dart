import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'school_for_blind.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initGetIt();
  runApp(SchoolForBlind(appRouter: AppRouter()));
}
