import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';


class AppThemes {
  
  static const Color _darkBg = Color(0xFF000F24); 
  static const Color _darkText = Color(0xFFFFFFFF);
  static const Color _darkCard = Color(0xFF0D1E2D);

  
  static const Color _lightBg = Color(0xFFFFFFFF);
  static const Color _lightText = Color(0xFF000F24);
  static const Color _lightCard = Color(0xFFF2F4F7);

  
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _darkBg,
        primaryColor: AppColors.kPrimaryColor,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.kPrimaryColor,
          surface: _darkBg,
          onSurface: _darkText,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _darkBg,
          foregroundColor: _darkText,
          elevation: 0,
        ),
        cardColor: _darkCard,
        iconTheme: const IconThemeData(color: _darkText),
        textTheme: const TextTheme().apply(
          bodyColor: _darkText,
          displayColor: _darkText,
        ),
        useMaterial3: true,
      );

  
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: _lightBg,
        primaryColor: AppColors.kPrimaryColor,
        colorScheme: const ColorScheme.light(
          primary: AppColors.kPrimaryColor,
          surface: _lightBg,
          onSurface: _lightText,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _lightBg,
          foregroundColor: _lightText,
          elevation: 0,
        ),
        cardColor: _lightCard,
        iconTheme: const IconThemeData(color: _lightText),
        textTheme: const TextTheme().apply(
          bodyColor: _lightText,
          displayColor: _lightText,
        ),
        useMaterial3: true,
      );
}