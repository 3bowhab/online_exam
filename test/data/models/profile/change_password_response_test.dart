import 'package:flutter_test/flutter_test.dart';
import 'package:online_exam/data/models/profile/change_password_response.dart';

void main() {
  group('Test ChangePasswordResponse Model', () {
    final tJson = {'message': 'success', 'token': 'mock_jwt_token'};

    final tResponse = ChangePasswordResponse(
      message: 'success',
      token: 'mock_jwt_token',
    );

    test('should convert fromJson successfully when json has data', () {
      final result = ChangePasswordResponse.fromJson(tJson);

      expect(result.message, tResponse.message);
      expect(result.token, tResponse.token);
    });

    test('should handle null values in fromJson', () {
      final result = ChangePasswordResponse.fromJson({});

      expect(result.message, isNull);
      expect(result.token, isNull);
    });

    test('should convert toJson successfully', () {
      final result = tResponse.toJson();

      expect(result, equals(tJson));
    });
  });
}
