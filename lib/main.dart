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
      builder: (context, child) => _buildAppProvider(),
    );
  }

  Widget _buildAppProvider() {
    return ChangeNotifierProvider.value(
      value: getIt<AppConfigProvider>(),
      builder: (context, child) => _buildMaterialApp(),
    );
  }

  Widget _buildMaterialApp() {
    return Consumer<AppConfigProvider>(
      builder: (context, appConfigProvider, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          theme: appConfigProvider.themeData,
          routerConfig: getIt<AppRouter>().router,
        );
      },
    );
  }
}