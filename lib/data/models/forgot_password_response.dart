class ForgotPasswordResponse {
  final bool success;
  final String code;
  final String message;
  final String correlationId;
  final ForgotPasswordData? data;
  final String timestamp;

  ForgotPasswordResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.correlationId,
    this.data,
    required this.timestamp,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      correlationId: json['correlationId'] ?? '',
      data: json['data'] != null ? ForgotPasswordData.fromJson(json['data']) : null,
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class ForgotPasswordData {
  final String maskedIdentifier;
  final int otpExpiresInSeconds;
  final int resendAfterSeconds;

  ForgotPasswordData({
    required this.maskedIdentifier,
    required this.otpExpiresInSeconds,
    required this.resendAfterSeconds,
  });

  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordData(
      maskedIdentifier: json['maskedIdentifier'] ?? '',
      otpExpiresInSeconds: json['otpExpiresInSeconds'] ?? 0,
      resendAfterSeconds: json['resendAfterSeconds'] ?? 0,
    );
  }
}

class VerifyOtpResponse {
  final bool success;
  final String code;
  final String message;
  final String correlationId;
  final VerifyOtpData? data;
  final String timestamp;

  VerifyOtpResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.correlationId,
    this.data,
    required this.timestamp,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      correlationId: json['correlationId'] ?? '',
      data: json['data'] != null ? VerifyOtpData.fromJson(json['data']) : null,
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class VerifyOtpData {
  final String resetToken;
  final int resetTokenExpiresInSeconds;

  VerifyOtpData({
    required this.resetToken,
    required this.resetTokenExpiresInSeconds,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      resetToken: json['resetToken'] ?? '',
      resetTokenExpiresInSeconds: json['resetTokenExpiresInSeconds'] ?? 0,
    );
  }
}

class ResetPasswordResponse {
  final bool success;
  final String code;
  final String message;
  final String correlationId;
  final ResetPasswordData? data;
  final String timestamp;

  ResetPasswordResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.correlationId,
    this.data,
    required this.timestamp,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      correlationId: json['correlationId'] ?? '',
      data: json['data'] != null ? ResetPasswordData.fromJson(json['data']) : null,
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class ResetPasswordData {
  final bool passwordReset;

  ResetPasswordData({
    required this.passwordReset,
  });

  factory ResetPasswordData.fromJson(Map<String, dynamic> json) {
    return ResetPasswordData(
      passwordReset: json['passwordReset'] ?? false,
    );
  }
}
