import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/router/routers_constants.dart';
import 'package:online_exam/presentation/auth/views/forgot_password_view.dart';
import 'package:online_exam/presentation/auth/views/login_view.dart';
import 'package:online_exam/presentation/auth/views/reset_password_view.dart';
import 'package:online_exam/presentation/auth/views/verify_code_view.dart';
import 'package:online_exam/presentation/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class AppRouter {
  final SharedPreferences _prefs;

  AppRouter(this._prefs);

  late final GoRouter router = GoRouter(
    initialLocation: RoutersConstants.login,
    redirect: (context, state) {
      final String? token = _prefs.getString('token');
      final bool isLoggedIn = token != null && token.isNotEmpty;

      final bool isGoingToLogin =
          state.matchedLocation == RoutersConstants.login;

      if (isLoggedIn && isGoingToLogin) {
        return RoutersConstants.home;
      }

      if (!isLoggedIn && state.matchedLocation == RoutersConstants.home) {
        return RoutersConstants.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutersConstants.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: RoutersConstants.forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: RoutersConstants.verifyCode,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return VerifyCodeView(email: email);
        },
      ),
      GoRoute(
        path: RoutersConstants.resetPassword,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return ResetPasswordView(email: email);
        },
      ),
      GoRoute(
        path: RoutersConstants.login,
        builder: (context, state) => const LoginView(),
      ),
    ],
  );
}
