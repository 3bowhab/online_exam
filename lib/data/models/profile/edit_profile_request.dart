import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_request.g.dart';

@JsonSerializable(includeIfNull: false)
class EditProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final String? phone;

  EditProfileRequest({
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.phone,
  });

  factory EditProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$EditProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EditProfileRequestToJson(this);
}