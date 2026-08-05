import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/theme/app_colors.dart';

@injectable
class AppTheme {
  ThemeData getTheme(AppColors colors, {bool isDark = false}) {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: colors.white,
      cardColor: colors.lightBlue,
      appBarTheme: _buildAppBarTheme(colors),
      colorScheme: _buildColorScheme(colors, isDark),
      textTheme: _buildTextTheme(colors),
      inputDecorationTheme: _buildInputDecorationTheme(colors),
      elevatedButtonTheme: _buildElevatedButtonTheme(colors, isDark),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colors),
      bottomNavigationBarTheme: _buildBottomNavTheme(colors),
    );
  }

  AppBarTheme _buildAppBarTheme(AppColors colors) => AppBarTheme(
    backgroundColor: colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: colors.black),
    titleTextStyle: TextStyle(
      color: colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  );

  ColorScheme _buildColorScheme(AppColors colors, bool isDark) => ColorScheme(
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
  );

  TextTheme _buildTextTheme(AppColors colors) => TextTheme(
    bodyLarge: TextStyle(color: colors.black),
    bodyMedium: TextStyle(color: colors.black),
    bodySmall: TextStyle(color: colors.gray),
  );

  InputDecorationTheme _buildInputDecorationTheme(AppColors colors) =>
      InputDecorationTheme(
        hintStyle: TextStyle(color: colors.placeHolder, fontSize: 14),
        labelStyle: TextStyle(color: colors.gray, fontSize: 14),
        errorStyle: TextStyle(color: colors.error, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
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
      );

  ElevatedButtonThemeData _buildElevatedButtonTheme(
    AppColors colors,
    bool isDark,
  ) => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colors.blue,
      foregroundColor: isDark ? colors.black : colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  OutlinedButtonThemeData _buildOutlinedButtonTheme(AppColors colors) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.error),
          foregroundColor: colors.error,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      );

  BottomNavigationBarThemeData _buildBottomNavTheme(AppColors colors) =>
      BottomNavigationBarThemeData(
        backgroundColor: colors.white,
        selectedItemColor: colors.blue,
        unselectedItemColor: colors.gray,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      );
}
