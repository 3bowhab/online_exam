import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/router/routers_constants.dart';
import 'package:online_exam/presentation/auth/views/forgot_password_view.dart';
import 'package:online_exam/presentation/auth/views/reset_password_view.dart';
import 'package:online_exam/presentation/auth/views/verify_code_view.dart';
import 'package:online_exam/presentation/home_view.dart';

@singleton
class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: RoutersConstants.forgotPassword,
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
    ],
  );
}