class VerifyResetCodeRequest {
  final String resetCode;
  VerifyResetCodeRequest({required this.resetCode});
  Map<String, dynamic> toJson() => {'resetCode': resetCode};
}