import 'package:flutter/material.dart';
import 'package:online_exam/core/theme/app_colors.dart';

class AppTheme {
  final AppColors colors;
  final bool isDark;

  AppTheme(this.colors, {this.isDark = false});

  late ThemeData themeData = ThemeData(
    brightness: isDark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: colors.white,
    cardColor: colors.lightBlue,

    appBarTheme: AppBarTheme(
      backgroundColor: colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: colors.black),
      titleTextStyle: TextStyle(
        color: colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),

    colorScheme: ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: colors.blue,
      onPrimary: colors.white,
      secondary: colors.blue,
      onSecondary: colors.white,
      error: colors.error,
      onError: colors.white,
      tertiary: colors.sucess,
      onTertiary: colors.white,
      surface: colors.white,
      onSurface: colors.black,
      onSurfaceVariant: colors.gray,
      surfaceContainerHighest: colors.lightBlue,
      outline: colors.placeHolder,
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(color: colors.black),
      bodyMedium: TextStyle(color: colors.black),
      bodySmall: TextStyle(color: colors.gray),
    ),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: colors.placeHolder, fontSize: 14),
      labelStyle: TextStyle(color: colors.gray, fontSize: 14),
      errorStyle: TextStyle(color: colors.error, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.gray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.gray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.blue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.error, width: 1.5),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.blue,
        foregroundColor: isDark ? colors.black : colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colors.white,
      selectedItemColor: colors.blue,
      unselectedItemColor: colors.gray,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
