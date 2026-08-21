// lib/Widget/app_colors.dart
import 'package:flutter/material.dart';
import 'package:parent_project/Widget/theme_controller.dart';

class AppColors {
  AppColors._();
   static final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(true);

  static const Color _bgDark = Color(0xFF000F24);
  static const Color _cardDark = Color(0xFF10223A);
  static const Color _accentGreenDark = Color(0xFFD3FF54);
  static const Color _redXDark = Color(0xFFEF5B5B);
  static const Color _fieldBorderDark = Color.fromARGB(69, 212, 255, 84);
  static const Color _textPrimaryDark = Colors.white;
  static const Color _textSecondaryDark = Color(0xFFB3B9C4);

  static const Color _bgLight = Color.fromARGB(255, 248, 250, 253);
  static const Color _cardLight = Color.fromARGB(255, 231, 235, 253);
  static const Color _accentGreenLight = Color.fromARGB(255, 166, 200, 65);
  static const Color _redXLight = Color(0xFFD8483F);
  static const Color _fieldBorderLight = Color.fromARGB(169, 166, 200, 65);
  static const Color _textPrimaryLight = Color(0xFF000F24);
  static const Color _textSecondaryLight = Color(0xFF5B6472);

  static bool get _isDark => ThemeController.instance.isDark;

  static Color get bgDark => _isDark ? _bgDark : _bgLight;
  static Color get cardDark => _isDark ? _cardDark : _cardLight;
  static Color get accentGreen => _isDark ? _accentGreenDark : _accentGreenLight;
  static Color get redX => _isDark ? _redXDark : _redXLight;
  static Color get fieldBorder => _isDark ? _fieldBorderDark : _fieldBorderLight ;
  static Color get textPrimary => _isDark ? _textPrimaryDark : _textPrimaryLight;
  static Color get textSecondary => _isDark ? _textSecondaryDark : _textSecondaryLight;
static Color get overlay70 => textPrimary.withOpacity(0.70);
static Color get overlay54 => textPrimary.withOpacity(0.54); 
static Color get overlay24 => textPrimary.withOpacity(0.24);
static Color get overlay38 => textPrimary.withOpacity(0.38); 
static Color get overlay12 => textPrimary.withOpacity(0.12); 
static Color get glassTint =>
    _isDark ? Colors.white.withOpacity(0.0) : const Color(0xFF10223A).withOpacity(0.15);

static Color get glassBorder =>
    _isDark ? Colors.white: const Color(0xFF000F24);

static Color get imageBackdrop => _isDark ? Colors.transparent : Colors.white;

static double get imageDarkenOpacity => _isDark ? 0.0 : 0.25;
static Color get tableRowBg => _isDark ? _cardDark : _cardLight;
static Color get subjectCardTint =>
    _isDark ? Colors.white.withOpacity(0.06) : const Color(0xFF10223A).withOpacity(0.06);

static Color get subjectCardBorder =>
    _isDark ? Colors.white.withOpacity(0.15) : const Color(0xFF10223A).withOpacity(0.15);
}