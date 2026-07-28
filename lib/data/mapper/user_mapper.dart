import 'package:online_exam/data/models/auth/login_response.dart';
import 'package:online_exam/domain/entities/user_entity.dart';

extension UserMapper on UserModel? {
  UserEntity toEntity() {
    return UserEntity(
      id: this?.id ?? '',
      username: this?.username ?? '',
      email: this?.email ?? '',
      firstName: this?.firstName ?? '',
      lastName: this?.lastName ?? '',
    );
  }
}