class ResetPasswordRequest {
  final String email;
  final String newPassword;
  ResetPasswordRequest({required this.email, required this.newPassword});
  Map<String, dynamic> toJson() => {'email': email, 'newPassword': newPassword};
}