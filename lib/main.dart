import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/widgets/app_config_prvider.dart';
import 'package:online_exam/core/widgets/app_router.dart';
import 'package:online_exam/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt<AppConfigProvider>().setDefaultTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ChangeNotifierProvider.value(
          value: getIt<AppConfigProvider>(),
          builder: (context, child) {
            return Consumer<AppConfigProvider>(
              builder: (context, appConfigProvider, child) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,

                  // Localization
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  locale: const Locale('en'),

                  // Theme (بقين بنجيبه من الـ Provider مباشرة)
                  theme: appConfigProvider.themeData,

                  // Routing via GoRouter
                  routerConfig: getIt<AppRouter>().router,
                );
              },
            );
          },
        );
      },
    );
  }
}