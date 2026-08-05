import 'package:injectable/injectable.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/domain/entities/user_entity.dart';
import 'package:online_exam/domain/repository/profile_repository.dart';

@injectable
class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<ApiResult<UserEntity>> execute() {
    return _repository.getProfileData();
  }
}