import 'package:injectable/injectable.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/base_response.dart';
import 'package:online_exam/domain/repository/auth_repository.dart';

@injectable
class VerifyResetCodeUseCase {
  final AuthRepository _repository;
  VerifyResetCodeUseCase(this._repository);

  Future<ApiResult<BaseResponse<void>>> execute(String resetCode) {
    return _repository.verifyResetCode(resetCode);
  }
}
