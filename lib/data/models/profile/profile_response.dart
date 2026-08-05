import 'package:json_annotation/json_annotation.dart';
import 'package:online_exam/data/models/auth/login_response.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  final String? message;
  final UserModel? user;

  ProfileResponse({this.message, this.user});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}