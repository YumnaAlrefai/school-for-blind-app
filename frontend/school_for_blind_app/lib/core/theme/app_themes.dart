import 'package:flutter/material.dart';

enum AppThemeType {
  yellowAndNavy,
  redAndBlack,
  orangeAndGrey,
  yellowAndBlack,
  whiteAndGreen,
  greenAndNavy,
  blueAndNavy,
  purpleAndNavy,
  pinkAndNavy,
  light,
  whiteAndBlack,
}

class AppThemes {
  static ThemeData get yellowAndNavyTheme {
    return ThemeData(
      fontFamily: 'ArabicTypesetting',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF000F24),
        surface: Color(0xFF133245),
        primary: Color(0xffD3FF54),
        onPrimary: Color(0xFF000F24),
        onBackground: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xffD3FF54),
        selectionColor: Color(0xffD3FF54).withOpacity(0.3),
        selectionHandleColor: Color(0xffD3FF54),
      ),
    );
  }

  static ThemeData get redAndBlackTheme {
    return ThemeData(
      fontFamily: 'ArabicTypesetting',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF000000),
        surface: Color(0xFF1A1A1A),
        primary: Color(0xFFFF0033),
        onPrimary: Color(0xFF000000),
        onBackground: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xFFFF0033),
        selectionColor: Color(0xFFFF0033).withOpacity(0.3),
        selectionHandleColor: Color(0xFFFF0033),
      ),
    );
  }

  static ThemeData get orangeAndGreyTheme {
    return ThemeData(
      fontFamily: 'ArabicTypesetting',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF1C1C1C),
        surface: Color(0xFF272727),
        primary: Color(0xFFFF6F00),
        onPrimary: Color(0xFF1C1C1C),
        onBackground: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xFFFF6F00),
        selectionColor: Color(0xFFFF6F00).withOpacity(0.3),
        selectionHandleColor: Color(0xFFFF6F00),
      ),
    );
  }

  static ThemeData get yellowAndBlackTheme {
    return ThemeData(
      fontFamily: 'ArabicTypesetting',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF000000),
        surface: Color(0xFF1A1A1A),
        primary: Color(0xFFFFFF00),
        onPrimary: Color(0xFF000000),
        onBackground: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xFFFFFF00),
        selectionColor: Color(0xFFFFFF00).withOpacity(0.3),
        selectionHandleColor: Color(0xFFFFFF00),
      ),
    );
  }

  static ThemeData get whiteAndGreenTheme {
    return ThemeData(
      fontFamily: 'ArabicTypesetting',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF0B2516),
        surface: Color(0xFF143522),
        primary: Color(0xFFF4FFA6),
        onPrimary: Color(0xFF0B2516),
        onBackground: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xFFF4FFA6),
        selectionColor: Color(0xFFF4FFA6).withOpacity(0.3),
        selectionHandleColor: Color(0xFFF4FFA6),
      ),
    );
  }

  static ThemeData get pinkAndNavyTheme {
    return ThemeData(
      fontFamily: 'ArabicTypesetting',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF0A0F24),
        surface: Color(0xFF111831),
        primary: Color(0xffFF007F),
        onPrimary: Color(0xFF0A0F24),
        onBackground: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xffFF007F),
        selectionColor: Color(0xffFF007F).withOpacity(0.3),
        selectionHandleColor: Color(0xffFF007F),
      ),
    );
  }

  static ThemeData get greenAndNavyTheme {
    return ThemeData(
      fontFamily: 'ArabicTypesetting',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF0A0F24),
        surface: Color(0xFF111831),
        primary: Color(0xff00FF95),
        onPrimary: Color(0xFF0A0F24),
        onBackground: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xff00FF95),
        selectionColor: Color(0xff00FF95).withOpacity(0.3),
        selectionHandleColor: Color(0xff00FF95),
      ),
    );
  }

  static ThemeData get blueAndNavyTheme {
    return ThemeData(
      fontFamily: 'ArabicTypesetting',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF0A0F24),
        surface: Color(0xFF111831),
        primary: Color(0xff00A6FF),
        onPrimary: Color(0xFF0A0F24),
        onBackground: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xff00A6FF),
        selectionColor: Color(0xff00A6FF).withOpacity(0.3),
        selectionHandleColor: Color(0xff00A6FF),
      ),
    );
  }

  static ThemeData get purpleAndNavyTheme {
    return ThemeData(
      fontFamily: 'ArabicTypesetting',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF0A0F24),
        surface: Color(0xFF111831),
        primary: Color(0xffB300FF),
        onPrimary: Color(0xFF0A0F24),
        onBackground: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xffB300FF),
        selectionColor: Color(0xffB300FF).withOpacity(0.3),
        selectionHandleColor: Color(0xffB300FF),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'ArabicTypesetting',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFFFFF0F5),
        surface: Color(0xFFFAE3EB),
        primary: Color(0xFF580026),
        onPrimary: Color(0xFFFFF0F5),
        onBackground: Color(0xFF000000),
        onSurface: Color(0xFF000000),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xFF580026),
        selectionColor: Color(0xFF580026).withOpacity(0.3),
        selectionHandleColor: Color(0xFF580026),
      ),
    );
  }

  static ThemeData get whiteAndBlackTheme {
    return ThemeData(
      fontFamily: 'ArabicTypesetting',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF000000),
        surface: Color(0xFF272727),
        primary: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF000000),
        onBackground: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xFFFFFFFF),
        selectionColor: Color(0xFFFFFFFF).withOpacity(0.3),
        selectionHandleColor: Color(0xFFFFFFFF),
      ),
    );
  }
}
