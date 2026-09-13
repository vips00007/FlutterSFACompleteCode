class ForgotPasswordRequest {
  final String identifier;

  ForgotPasswordRequest({
    required this.identifier,
  });

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
    };
  }
}

class VerifyOtpRequest {
  final String identifier;
  final String otp;

  VerifyOtpRequest({
    required this.identifier,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'otp': otp,
    };
  }
}

class ResetPasswordRequest {
  final String resetToken;
  final String newPassword;

  ResetPasswordRequest({
    required this.resetToken,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'resetToken': resetToken,
      'newPassword': newPassword,
    };
  }
}
