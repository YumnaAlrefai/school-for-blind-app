import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';

class ThemeController {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  static const String _prefsKey = 'is_dark_mode';

  ValueNotifier<bool> get isDarkNotifier => AppColors.isDarkMode;

  bool get isDark => AppColors.isDarkMode.value;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_prefsKey) ?? true;
    AppColors.isDarkMode.value = saved;
  }

  Future<void> setDark(bool value) async {
    AppColors.isDarkMode.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }

  Future<void> toggle() async {
    await setDark(!isDark);
  }
}