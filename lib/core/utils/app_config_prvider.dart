import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/theme/app_colors.dart';
import 'package:online_exam/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AppConfigProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  late ThemeData _themeData;
  ThemeData get themeData => _themeData;

  ThemeOptions _currentThemeOption = ThemeOptions.light;
  ThemeOptions get currentThemeOption => _currentThemeOption;

  Locale _appLocale = const Locale('en');
  Locale get appLocale => _appLocale;

  AppConfigProvider({this.sharedPreferences}) {
    _themeData = AppTheme(LightThemeColors()).themeData;
  }

  Future<void> changeTheme(ThemeOptions themeOption) async {
    _currentThemeOption = themeOption;
    final bool isDark = themeOption == ThemeOptions.dark;

    AppColors appColors = switch (themeOption) {
      ThemeOptions.light => LightThemeColors(),
      ThemeOptions.dark => DarkThemeColors(),
    };

    _themeData = AppTheme(appColors, isDark: isDark).themeData;
    await sharedPreferences?.setString('theme', themeOption.name);
    notifyListeners();
  }

  Future<void> setDefaultTheme() async {
    var currentTheme = ThemeOptions.fromString(
      sharedPreferences?.getString('theme') ?? '',
    );
    await changeTheme(currentTheme);

    final savedLang = sharedPreferences?.getString('language') ?? 'en';
    _appLocale = Locale(savedLang);
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_appLocale.languageCode == languageCode) return;
    _appLocale = Locale(languageCode);
    await sharedPreferences?.setString('language', languageCode);
    notifyListeners();
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
        return ThemeOptions.light;
    }
  }
}
