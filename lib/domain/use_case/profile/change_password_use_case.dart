import 'package:injectable/injectable.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/domain/repository/profile_repository.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<ApiResult<void>> execute(ChangePasswordRequest request) {
    return _repository.changePassword(request);
  }
}