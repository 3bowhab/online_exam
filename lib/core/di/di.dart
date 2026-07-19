import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/di/di.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();
