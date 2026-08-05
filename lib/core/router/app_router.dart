import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 👈 1. استدعاء FlutterSecureStorage
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/constants/prefs_keys.dart';
import 'package:online_exam/core/router/routers_constants.dart';
import 'package:online_exam/presentation/auth/views/forgot_password_view.dart';
import 'package:online_exam/presentation/auth/views/login_view.dart';
import 'package:online_exam/presentation/auth/views/reset_password_view.dart'
    as auth_reset;
import 'package:online_exam/presentation/auth/views/verify_code_view.dart';
import 'package:online_exam/presentation/main_layout_view.dart';
import 'package:online_exam/presentation/profile/view/profile_reset_password_view.dart';

@singleton
class AppRouter {
  final FlutterSecureStorage _secureStorage;

  AppRouter(this._secureStorage);

  late final GoRouter router = GoRouter(
    initialLocation: RoutersConstants.mainLayout,
    redirect: (context, state) async {
      final String? token = await _secureStorage.read(key: PrefsKeys.token);
      final bool isLoggedIn = token != null && token.isNotEmpty;

      final bool isGoingToLogin =
          state.matchedLocation == RoutersConstants.login;

      if (isLoggedIn && isGoingToLogin) {
        return RoutersConstants.mainLayout;
      }

      if (!isLoggedIn && state.matchedLocation == RoutersConstants.mainLayout) {
        return RoutersConstants.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutersConstants.mainLayout,
        builder: (context, state) => const MainLayoutView(),
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
          return auth_reset.ResetPasswordView(email: email);
        },
      ),
      GoRoute(
        path: RoutersConstants.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: RoutersConstants.profileResetPassword,
        builder: (context, state) => const ProfileResetPasswordView(),
      ),
    ],
  );
}
