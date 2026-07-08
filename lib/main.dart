import 'package:flutter/material.dart';
import 'package:online_exam/core/di/injection.dart';
import 'package:online_exam/core/theme/app_theme.dart';
import 'package:online_exam/l10n/app_localizations.dart';
import 'package:online_exam/presentation/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = getIt<AppTheme>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Set the app theme
      theme: appTheme.themeData,

      // Add localization support
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),

      home: const HomeView(),
    );
  }
}