import 'package:online_exam/core/base/cubit/base_state.dart';

class ProfileState {
  final BaseState<void> logoutState;

  const ProfileState({this.logoutState = const BaseState()});

  ProfileState copyWith({BaseState<void>? logoutState}) {
    return ProfileState(logoutState: logoutState ?? this.logoutState);
  }
}
