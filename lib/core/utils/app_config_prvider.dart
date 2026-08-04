import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/constants/prefs_keys.dart';
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

  Locale _appLocale = const Locale(PrefsKeys.defaultLanguage);
  Locale get appLocale => _appLocale;

  AppConfigProvider({this.sharedPreferences}) {
    _themeData = AppTheme.getTheme(LightThemeColors());
  }

  Future<void> changeTheme(ThemeOptions themeOption) async {
    _currentThemeOption = themeOption;
    final bool isDark = themeOption == ThemeOptions.dark;

    AppColors appColors = switch (themeOption) {
      ThemeOptions.light => LightThemeColors(),
      ThemeOptions.dark => DarkThemeColors(),
    };

    _themeData = AppTheme.getTheme(appColors, isDark: isDark);
    await sharedPreferences?.setString(PrefsKeys.theme, themeOption.name);
    notifyListeners();
  }

  Future<void> setDefaultTheme() async {
    final savedThemeStr = sharedPreferences?.getString(PrefsKeys.theme) ?? '';
    var currentTheme = ThemeOptions.fromString(savedThemeStr);
    await changeTheme(currentTheme);

    final savedLang = sharedPreferences?.getString(PrefsKeys.language) ?? PrefsKeys.defaultLanguage;
    _appLocale = Locale(savedLang);
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_appLocale.languageCode == languageCode) return;
    _appLocale = Locale(languageCode);
    await sharedPreferences?.setString(PrefsKeys.language, languageCode);
    notifyListeners();
  }
}

enum ThemeOptions {
  light,
  dark;

  static ThemeOptions fromString(String themeOption) {
    if (themeOption == ThemeOptions.dark.name) {
      return ThemeOptions.dark;
    }
    return ThemeOptions.light;
  }
}