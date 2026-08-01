import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/theme/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppThemes.yellowAndNavyTheme) {
    loadTheme();
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final String savedThemeName = prefs.getString('theme') ?? 'yellow';

    switch (savedThemeName) {
      case 'redAndBlack':
        emit(AppThemes.redAndBlackTheme);
        break;
      case 'orangeAndGrey':
        emit(AppThemes.orangeAndGreyTheme);
        break;
      case 'yellowAndBlack':
        emit(AppThemes.yellowAndBlackTheme);
        break;
      case 'whiteAndGreen':
        emit(AppThemes.whiteAndGreenTheme);
        break;
      case 'greenAndNavy':
        emit(AppThemes.greenAndNavyTheme);
      case 'blueAndNavy':
        emit(AppThemes.blueAndNavyTheme);
      case 'purpleAndNavy':
        emit(AppThemes.purpleAndNavyTheme);
      case 'pinkAndNavy':
        emit(AppThemes.pinkAndNavyTheme);
        break;
      case 'light':
        emit(AppThemes.lightTheme);
        break;
      case 'whiteAndBlack':
        emit(AppThemes.whiteAndBlackTheme);
        break;
      case 'yellow':
      default:
        emit(AppThemes.yellowAndNavyTheme);
        break;
    }
  }

  void changeTheme(AppThemeType themeType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeType.name);

    switch (themeType) {
      case AppThemeType.yellowAndNavy:
        emit(AppThemes.yellowAndNavyTheme);
        break;
      case AppThemeType.redAndBlack:
        emit(AppThemes.redAndBlackTheme);
        break;
      case AppThemeType.orangeAndGrey:
        emit(AppThemes.orangeAndGreyTheme);
        break;
      case AppThemeType.yellowAndBlack:
        emit(AppThemes.yellowAndBlackTheme);
        break;
      case AppThemeType.whiteAndGreen:
        emit(AppThemes.whiteAndGreenTheme);
        break;
      case AppThemeType.greenAndNavy:
        emit(AppThemes.greenAndNavyTheme);
      case AppThemeType.blueAndNavy:
        emit(AppThemes.blueAndNavyTheme);
      case AppThemeType.purpleAndNavy:
        emit(AppThemes.purpleAndNavyTheme);
      case AppThemeType.pinkAndNavy:
        emit(AppThemes.pinkAndNavyTheme);
        break;
      case AppThemeType.light:
        emit(AppThemes.lightTheme);
        break;
      case AppThemeType.whiteAndBlack:
        emit(AppThemes.whiteAndBlackTheme);
        break;
    }
  }
}
