import 'package:flutter/material.dart';
import 'package:online_exam/l10n/app_localizations.dart';
import 'package:online_exam/presentation/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Add localization support
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),

      home: const HomeView(),
    );
  }
}