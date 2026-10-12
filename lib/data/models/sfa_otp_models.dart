class SendLoginOtpRequest {
  final String identifier;

  SendLoginOtpRequest({required this.identifier});

  Map<String, dynamic> toJson() {
    return {'identifier': identifier};
  }
}

class SendLoginOtpResponse {
  final bool success;
  final String code;
  final String message;
  final String correlationId;
  final SendLoginOtpData? data;
  final String timestamp;

  SendLoginOtpResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.correlationId,
    this.data,
    required this.timestamp,
  });

  factory SendLoginOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendLoginOtpResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      correlationId: json['correlationId'] ?? '',
      data: json['data'] != null
          ? SendLoginOtpData.fromJson(json['data'])
          : null,
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class SendLoginOtpData {
  final String challengeId;
  final int otpExpiresInSeconds;
  final int resendAfterSeconds;

  SendLoginOtpData({
    required this.challengeId,
    required this.otpExpiresInSeconds,
    required this.resendAfterSeconds,
  });

  factory SendLoginOtpData.fromJson(Map<String, dynamic> json) {
    return SendLoginOtpData(
      challengeId: json['challengeId'] ?? '',
      otpExpiresInSeconds: json['otpExpiresInSeconds'] ?? 300,
      resendAfterSeconds: json['resendAfterSeconds'] ?? 60,
    );
  }
}

class VerifyLoginOtpRequest {
  final String challengeId;
  final String otp;

  VerifyLoginOtpRequest({required this.challengeId, required this.otp});

  Map<String, dynamic> toJson() {
    return {'challengeId': challengeId, 'otp': otp};
  }
}
