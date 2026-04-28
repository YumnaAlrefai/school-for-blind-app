import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_colors.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';

class SchoolForBlind extends StatelessWidget {
  final AppRouter appRouter;
  const SchoolForBlind({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'School for the Blind',
        debugShowCheckedModeBanner: false,

        locale: const Locale('ar', 'SY'),
        supportedLocales: const [Locale('ar', 'SY')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: 'ArabicTypesetting',
          brightness: Brightness.dark,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: AppColors.kPrimaryColor,
            selectionColor: AppColors.kPrimaryColor.withOpacity(0.3),
            selectionHandleColor: AppColors.kPrimaryColor,
          ),
        ),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRoutes.kSplashScreen,
      ),
    );
  }
}
