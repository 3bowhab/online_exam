import 'package:flutter_test/flutter_test.dart';
import 'package:online_exam/data/models/auth/login_response.dart';
import 'package:online_exam/data/models/profile/profile_response.dart';

void main() {
  group('Test ProfileResponse Model', () {
    final tUserJson = {
      '_id': '123',
      'username': 'ali_ibrahim',
      'email': 'ali@example.com',
    };

    final tJson = {'message': 'success', 'user': tUserJson};

    test('should convert fromJson successfully', () {
      final result = ProfileResponse.fromJson(tJson);

      expect(result.message, 'success');
      expect(result.user, isA<UserModel>());
      expect(result.user?.id, '123');
      expect(result.user?.username, 'ali_ibrahim');
    });

    test('should handle null user and message in fromJson', () {
      final result = ProfileResponse.fromJson({});

      expect(result.message, isNull);
      expect(result.user, isNull);
    });

    test('should convert toJson successfully', () {
      final response = ProfileResponse(
        message: 'success',
        user: UserModel(
          id: '123',
          username: 'ali_ibrahim',
          email: 'ali@example.com',
        ),
      );

      final result = response.toJson();

      expect(result['message'], 'success');
      expect(result['user'], isNotNull);
    });
  });
}
