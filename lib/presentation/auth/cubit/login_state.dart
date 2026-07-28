import 'package:online_exam/core/base/cubit/base_state.dart';
import 'package:online_exam/domain/entities/user_entity.dart';

class LoginState {
  final BaseState<UserEntity> loginState;

  const LoginState({
    this.loginState = const BaseState(),
  });

  LoginState copyWith({
    BaseState<UserEntity>? loginState,
  }) {
    return LoginState(
      loginState: loginState ?? this.loginState,
    );
  }
}