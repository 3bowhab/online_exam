import 'package:injectable/injectable.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/base_response.dart';
import 'package:online_exam/domain/repository/auth_repository.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepository _repository;
  ResetPasswordUseCase(this._repository);

  Future<ApiResult<BaseResponse<void>>> execute(
    String email,
    String newPassword,
  ) {
    return _repository.resetPassword(email, newPassword);
  }
}
