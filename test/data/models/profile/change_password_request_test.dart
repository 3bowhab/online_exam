import 'package:flutter_test/flutter_test.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';

void main() {
  group('Test ChangePasswordRequest Model', () {
    final tJson = {
      'oldPassword': 'old123Password',
      'password': 'new123Password',
      'rePassword': 'new123Password',
    };

    final tRequest = ChangePasswordRequest(
      oldPassword: 'old123Password',
      password: 'new123Password',
      rePassword: 'new123Password',
    );

    test('should convert fromJson successfully', () {
      final result = ChangePasswordRequest.fromJson(tJson);

      expect(result.oldPassword, tRequest.oldPassword);
      expect(result.password, tRequest.password);
      expect(result.rePassword, tRequest.rePassword);
    });

    test('should convert toJson successfully', () {
      final result = tRequest.toJson();

      expect(result, equals(tJson));
    });
  });
}
