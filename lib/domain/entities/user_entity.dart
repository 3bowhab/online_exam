import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, username, email, firstName, lastName, phone];
}
