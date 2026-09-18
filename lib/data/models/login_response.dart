import '../../domain/entities/user.dart';

class LoginResponse {
  final bool success;
  final String code;
  final String message;
  final String correlationId;
  final LoginData? data;
  final String timestamp;

  LoginResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.correlationId,
    this.data,
    required this.timestamp,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      correlationId: json['correlationId'] ?? '',
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      timestamp: json['timestamp'] ?? '',
    );
  }

  User toEntity() {
    if (data == null) {
      throw Exception("Login data is missing");
    }
    return User(
      userUuid: data!.user.userUuid,
      username: data!.user.username,
      displayName: data!.user.displayName,
      companyUuid: data!.user.companyUuid,
      companyCode: data!.user.companyCode,
      roles: data!.user.roles,
      accessToken: data!.accessToken,
      tokenType: data!.tokenType,
      expiresIn: data!.expiresIn,
      expiresAt: data!.expiresAt,
      mustChangePassword: data!.mustChangePassword,
      sessionMode: data!.sessionMode,
      channel: data!.channel,
    );
  }
}

class LoginData {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String expiresAt;
  final String channel;
  final String sessionMode;
  final bool mustChangePassword;
  final UserData user;

  LoginData({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.expiresAt,
    required this.channel,
    required this.sessionMode,
    required this.mustChangePassword,
    required this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['accessToken'] ?? '',
      tokenType: json['tokenType'] ?? '',
      expiresIn: json['expiresIn'] ?? 0,
      expiresAt: json['expiresAt'] ?? '',
      channel: json['channel'] ?? '',
      sessionMode: json['sessionMode'] ?? '',
      mustChangePassword: json['mustChangePassword'] ?? false,
      user: UserData.fromJson(json['user']),
    );
  }
}

class UserData {
  final String userUuid;
  final String username;
  final String displayName;
  final String companyUuid;
  final String companyCode;
  final List<String> roles;

  UserData({
    required this.userUuid,
    required this.username,
    required this.displayName,
    required this.companyUuid,
    required this.companyCode,
    required this.roles,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userUuid: json['userUuid'] ?? '',
      username: json['username'] ?? '',
      displayName: json['displayName'] ?? '',
      companyUuid: json['companyUuid'] ?? '',
      companyCode: json['companyCode'] ?? '',
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
    );
  }
}
