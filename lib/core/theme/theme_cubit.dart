import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// يدير وضع الثيم (فاتح/داكن) ويحفظ الاختيار في SharedPreferences.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark) {
    _load();
  }

  static const String _key = 'app_theme_mode';

  /// تحميل الاختيار المحفوظ عند بدء التطبيق.
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == 'light') {
      emit(ThemeMode.light);
    } else if (saved == 'dark') {
      emit(ThemeMode.dark);
    }
  }

  /// تعيين ثيم محدّد (فاتح/داكن) وحفظه.
  Future<void> setTheme(ThemeMode mode) async {
    emit(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode == ThemeMode.light ? 'light' : 'dark');
  }

  bool get isDark => state == ThemeMode.dark;
}