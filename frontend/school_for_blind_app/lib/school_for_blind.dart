import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/theme_cubit.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';

class SchoolForBlind extends StatelessWidget {
  final AppRouter appRouter;
  final GlobalKey<NavigatorState> navigatorKey;

  const SchoolForBlind({
    super.key,
    required this.appRouter,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, currentTheme) {
        return ScreenUtilInit(
          designSize: const Size(402, 874),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              title: 'School for the Blind',
              debugShowCheckedModeBanner: false,

              locale: const Locale('ar', 'SY'),
              supportedLocales: const [Locale('ar', 'SY')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              theme: currentTheme,
              themeMode: ThemeMode.dark,

              navigatorKey: navigatorKey,
              onGenerateRoute: appRouter.generateRoute,
              initialRoute: AppRoutes.kSplashScreen,
              //initialRoute: AppRoutes.kStudentMainScreen,
            );
          },
        );
      },
    );
  }
}
