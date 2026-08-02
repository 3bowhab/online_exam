import 'package:online_exam/core/network/api_result.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/domain/entities/user_entity.dart';
import 'package:online_exam/domain/repository/profile_repository.dart';

@injectable
class EditProfileUseCase {
  final ProfileRepository _repository;

  EditProfileUseCase(this._repository);

  Future<ApiResult<UserEntity>> execute(EditProfileRequest request) {
    return _repository.editProfile(request);
  }
}