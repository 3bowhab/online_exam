import 'package:flutter/material.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/theme/app_theme.dart';
import 'package:online_exam/core/widgets/app_config_prvider.dart';
import 'package:online_exam/l10n/app_localizations.dart';
import 'package:online_exam/presentation/pages/home_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt<AppConfigPrvider>().setDefaultTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: getIt<AppConfigPrvider>(),
      builder: (context, child) {
        return Consumer<AppConfigPrvider>(
          builder: (context, appConfigProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,

              // Add localization support
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('en'),
              
              // Use the theme from AppTheme
              theme: getIt<AppTheme>().themeData,

              home: const HomeView(),
            );
          },
        );
      },
    );
  }
}
