import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/theme_app.dart';
import 'package:school_for_blind_app/core/theme/theme_cubit.dart';

class TeacherThemeScope extends StatelessWidget {
  const TeacherThemeScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      bloc: getIt<ThemeCubit>(),
      builder: (context, mode) {
        final theme =
            mode == ThemeMode.light ? AppThemes.light : AppThemes.dark;
        // نطبّق الثيم + نلوّن الخلفية تلقائياً حسب الثيم المختار.
        return Theme(
          data: theme,
          child: Material(
            color: theme.scaffoldBackgroundColor,
            child: child,
          ),
        );
      },
    );
  }
}