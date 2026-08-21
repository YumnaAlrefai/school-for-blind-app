// lib/Widget/theme_listener.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class ThemeListener extends StatelessWidget {
  final WidgetBuilder builder;
  const ThemeListener({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppColors.isDarkMode,
      builder: (context, isDark, _) => builder(context),
    );
  }
}