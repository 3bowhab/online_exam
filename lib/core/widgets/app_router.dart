import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/presentation/auth/views/forgot_password_view.dart';
import 'package:online_exam/presentation/auth/views/reset_password_view.dart';
import 'package:online_exam/presentation/auth/views/verify_code_view.dart';
import 'package:online_exam/presentation/home_view.dart';

@singleton
class AppRouter {
  // Routes Paths
  static const String home = '/';
  static const String forgotPassword = '/forgot_password';
  static const String verifyCode = '/verify_code';
  static const String resetPassword = '/reset_password';

  late final GoRouter router = GoRouter(
    initialLocation: forgotPassword, 
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: verifyCode,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return VerifyCodeView(email: email);
        },
      ),
      GoRoute(
        path: resetPassword,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return ResetPasswordView(email: email);
        },
      ),
    ],
  );
}