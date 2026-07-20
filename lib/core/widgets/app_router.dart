import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/presentation/home_view.dart';

@singleton
class AppRouter {
  static const String home = '/';

  late final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(path: home, builder: (context, state) => const HomeView()),
    ],
  );
}
