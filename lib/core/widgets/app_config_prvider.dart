// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
// import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/theme/app_colors.dart';
import 'package:online_exam/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AppConfigProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  late ThemeData _themeData;
  ThemeData get themeData => _themeData;

  AppConfigProvider({this.sharedPreferences}) {
    _themeData = AppTheme(LightThemeColors()).themeData;
  }

  Future<void> changeTheme(ThemeOptions themeOption) async {
    AppColors appColors = switch (themeOption) {
      ThemeOptions.light => LightThemeColors(),
      ThemeOptions.dark => DarkThemeColors(),
    };

    _themeData = AppTheme(appColors).themeData;
    await sharedPreferences?.setString('theme', themeOption.name);
    notifyListeners();
  }

  Future<void> setDefaultTheme() async {
    var currentTheme = ThemeOptions.fromString(
      sharedPreferences?.getString('theme') ?? '',
    );
    await changeTheme(currentTheme);
  }
}

enum ThemeOptions {
  light,
  dark;

  static ThemeOptions fromString(String themeOption) {
    switch (themeOption) {
      case 'light':
        return ThemeOptions.light;
      case 'dark':
        return ThemeOptions.dark;
      default:
        return ThemeOptions
            .light; // Default to light theme if the string doesn't match any option
    }
  }
}
