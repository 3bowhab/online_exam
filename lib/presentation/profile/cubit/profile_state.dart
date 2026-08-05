import 'package:equatable/equatable.dart';
import 'package:online_exam/core/base/cubit/base_state.dart';
import 'package:online_exam/domain/entities/user_entity.dart';

class ProfileState extends Equatable {
  final BaseState<UserEntity> profileDataState;
  final BaseState<void> editProfileState;
  final BaseState<void> changePasswordState;
  final BaseState<void> logoutState;

  const ProfileState({
    this.profileDataState = const BaseState(),
    this.editProfileState = const BaseState(),
    this.changePasswordState = const BaseState(),
    this.logoutState = const BaseState(),
  });

  ProfileState copyWith({
    BaseState<UserEntity>? profileDataState,
    BaseState<void>? editProfileState,
    BaseState<void>? changePasswordState,
    BaseState<void>? logoutState,
  }) {
    return ProfileState(
      profileDataState: profileDataState ?? this.profileDataState,
      editProfileState: editProfileState ?? this.editProfileState,
      changePasswordState: changePasswordState ?? this.changePasswordState,
      logoutState: logoutState ?? this.logoutState,
    );
  }

  @override
  List<Object?> get props => [
    profileDataState,
    editProfileState,
    changePasswordState,
    logoutState,
  ];
}
