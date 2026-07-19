import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/theme/app_colors.dart';
import 'package:online_exam/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AppConfigPrvider extends ChangeNotifier {
  AppTheme appTheme;
  SharedPreferences? sharedPreferences;
  AppConfigPrvider({required this.appTheme, this.sharedPreferences});

  Future<void> changeTheme(ThemeOptions themeOption) async {
    AppColors appColors = switch (themeOption) {
      ThemeOptions.light => LightThemeColors(),
      ThemeOptions.dark => DarkThemeColors(),
    };

    if (getIt.isRegistered<AppColors>()) {
      await getIt.unregister<AppColors>();
    }

    if (getIt.isRegistered<AppTheme>()) {
      await getIt.unregister<AppTheme>();
    }

    if (getIt.isRegistered<ThemeOptions>()) {
      await getIt.unregister<ThemeOptions>();
    }

    getIt.registerSingleton<AppColors>(appColors);
    getIt.registerSingleton<AppTheme>(AppTheme(getIt()));
    getIt.registerSingleton<ThemeOptions>(themeOption);
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
