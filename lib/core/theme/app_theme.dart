import 'package:flutter/material.dart';
import 'package:online_exam/core/theme/app_colors.dart';

class AppTheme {
  final AppColors colors;

  AppTheme(this.colors);

  late ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: colors.white,
    cardColor: colors.lightBlue,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: colors.black),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: colors.blue,
    ).copyWith(error: colors.error),

    // Define text theme
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: colors.black),
      bodyMedium: TextStyle(color: colors.gray),
    ),

    // Define input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: colors.placeHolder, fontSize: 14),
      labelStyle: TextStyle(color: colors.gray, fontSize: 14),
      errorStyle: TextStyle(color: colors.error, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.black),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.black),
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

    // Define elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.blue,
        foregroundColor: colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
