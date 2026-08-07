import 'package:flutter_test/flutter_test.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';

void main() {
  group('Test EditProfileRequest Model', () {
    final tFullJson = {
      'firstName': 'Ali',
      'lastName': 'Ibrahim',
      'username': 'ali_ibrahim',
      'email': 'ali@example.com',
      'phone': '01000000000',
    };

    final tRequest = EditProfileRequest(
      firstName: 'Ali',
      lastName: 'Ibrahim',
      username: 'ali_ibrahim',
      email: 'ali@example.com',
      phone: '01000000000',
    );

    test('should convert fromJson successfully', () {
      final result = EditProfileRequest.fromJson(tFullJson);

      expect(result.firstName, tRequest.firstName);
      expect(result.lastName, tRequest.lastName);
      expect(result.username, tRequest.username);
      expect(result.email, tRequest.email);
      expect(result.phone, tRequest.phone);
    });

    test('should convert toJson successfully with full data', () {
      final result = tRequest.toJson();

      expect(result, equals(tFullJson));
    });

    test(
      'should exclude null fields in toJson because includeIfNull is false',
      () {
        final partialRequest = EditProfileRequest(
          firstName: 'Ali',
          email: 'ali@example.com',
        );

        final result = partialRequest.toJson();

        expect(result.containsKey('lastName'), isFalse);
        expect(result.containsKey('username'), isFalse);
        expect(result.containsKey('phone'), isFalse);
        expect(result['firstName'], 'Ali');
        expect(result['email'], 'ali@example.com');
      },
    );
  });
}
