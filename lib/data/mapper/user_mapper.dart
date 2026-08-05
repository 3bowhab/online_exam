import 'package:injectable/injectable.dart';
import 'package:online_exam/data/models/auth/login_response.dart';
import 'package:online_exam/domain/entities/user_entity.dart';

@injectable
class UserMapper {
  UserEntity mapUserModelToUserEntity(UserModel? model) {
    return UserEntity(
      id: model?.id ?? '',
      username: model?.username ?? '',
      email: model?.email ?? '',
      firstName: model?.firstName ?? '',
      lastName: model?.lastName ?? '',
      phone: model?.phone ?? '',
    );
  }

  List<UserEntity> mapUserModelListToUserEntityList(
    List<UserModel>? models,
  ) {
    if (models == null || models.isEmpty) return [];
    return models.map(mapUserModelToUserEntity).toList();
  }
}