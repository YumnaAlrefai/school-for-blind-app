import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/theme_app.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher/teacher_theme_cubit.dart';

class TeacherThemeScope extends StatelessWidget {
  const TeacherThemeScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherThemeCubit, ThemeMode>(
      bloc: getIt<TeacherThemeCubit>(),
      builder: (context, mode) {
        final theme = mode == ThemeMode.light
            ? AppThemes.light
            : AppThemes.dark;

        return Theme(
          data: theme,
          child: Material(color: theme.scaffoldBackgroundColor, child: child),
        );
      },
    );
  }
}
