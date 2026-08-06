import 'package:flutter_test/flutter_test.dart';
import 'package:online_exam/data/mapper/user_mapper.dart';
import 'package:online_exam/data/models/auth/login_response.dart';

void main() {
  late UserMapper userMapper;

  setUp(() {
    userMapper = UserMapper();
  });

  group('Test UserMapper - Single Model Conversion', () {
    test(
      'should map UserModel to UserEntity correctly when model has data',
      () {
        final userModel = UserModel(
          id: '123',
          username: 'ali_ibrahim',
          email: 'ali@example.com',
          firstName: 'Ali',
          lastName: 'Ibrahim',
          phone: '01000000000',
        );

        final result = userMapper.mapUserModelToUserEntity(userModel);

        expect(result.id, '123');
        expect(result.username, 'ali_ibrahim');
        expect(result.email, 'ali@example.com');
        expect(result.firstName, 'Ali');
        expect(result.lastName, 'Ibrahim');
        expect(result.phone, '01000000000');
      },
    );

    test('should return default empty strings when UserModel is null', () {
      final result = userMapper.mapUserModelToUserEntity(null);

      expect(result.id, '');
      expect(result.username, '');
      expect(result.email, '');
      expect(result.firstName, '');
      expect(result.lastName, '');
      expect(result.phone, '');
    });
  });

  group('Test UserMapper - List Conversion', () {
    test('should map List<UserModel> to List<UserEntity> correctly', () {
      final userModelList = [
        UserModel(
          id: '1',
          username: 'user_1',
          email: 'user1@example.com',
          firstName: 'User',
          lastName: 'One',
          phone: '01111111111',
        ),
        UserModel(
          id: '2',
          username: 'user_2',
          email: 'user2@example.com',
          firstName: 'User',
          lastName: 'Two',
          phone: '01222222222',
        ),
      ];

      final result = userMapper.mapUserModelListToUserEntityList(userModelList);

      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].username, 'user_1');
      expect(result[1].id, '2');
      expect(result[1].username, 'user_2');
    });

    test('should return empty list when input models list is null', () {
      final result = userMapper.mapUserModelListToUserEntityList(null);

      expect(result, isEmpty);
    });

    test('should return empty list when input models list is empty', () {
      final result = userMapper.mapUserModelListToUserEntityList([]);

      expect(result, isEmpty);
    });
  });
}
