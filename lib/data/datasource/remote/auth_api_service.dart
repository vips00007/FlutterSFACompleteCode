import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/login_request.dart';
import '../../models/login_response.dart';
import '../../models/forgot_password_request.dart';
import '../../models/forgot_password_response.dart';
import '../../models/sfa_otp_models.dart';

class AuthApiService {
  final String baseUrl = "https://api-staging.rahulpatel.online";

  Future<SendLoginOtpResponse> sendLoginOtp(SendLoginOtpRequest request) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/auth/sfa/login-otp/send"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 401 ||
        response.statusCode == 400) {
      final sfaResponse = SendLoginOtpResponse.fromJson(
        jsonDecode(response.body),
      );
      if (sfaResponse.success && sfaResponse.code == "SUCCESS") {
        return sfaResponse;
      } else {
        throw Exception(
          sfaResponse.message.isNotEmpty
              ? sfaResponse.message
              : "Failed to send login OTP",
        );
      }
    } else {
      throw Exception("Network error: ${response.statusCode}");
    }
  }

  Future<LoginResponse> verifyLoginOtp(VerifyLoginOtpRequest request) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/auth/sfa/login-otp/verify"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 401 ||
        response.statusCode == 400) {
      final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
      if (loginResponse.success && loginResponse.code == "SUCCESS") {
        return loginResponse;
      } else {
        throw Exception(
          loginResponse.message.isNotEmpty
              ? loginResponse.message
              : "Failed to verify OTP",
        );
      }
    } else {
      throw Exception("Network error: ${response.statusCode}");
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 401 ||
        response.statusCode == 400) {
      final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
      if (loginResponse.success && loginResponse.code == "SUCCESS") {
        return loginResponse;
      } else {
        throw Exception(
          loginResponse.message.isNotEmpty
              ? loginResponse.message
              : "Failed to login",
        );
      }
    } else {
      throw Exception("Network error: ${response.statusCode}");
    }
  }

  Future<ForgotPasswordResponse> forgotPasswordSendOtp(
    ForgotPasswordRequest request,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/auth/forgot-password/send-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 401 ||
        response.statusCode == 400) {
      final forgotResponse = ForgotPasswordResponse.fromJson(
        jsonDecode(response.body),
      );
      if (forgotResponse.success && forgotResponse.code == "SUCCESS") {
        return forgotResponse;
      } else {
        throw Exception(
          forgotResponse.message.isNotEmpty
              ? forgotResponse.message
              : "Failed to send OTP",
        );
      }
    } else {
      throw Exception("Network error: ${response.statusCode}");
    }
  }

  Future<VerifyOtpResponse> verifyForgotPasswordOtp(
    VerifyOtpRequest request,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/auth/forgot-password/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 401 ||
        response.statusCode == 400) {
      final verifyResponse = VerifyOtpResponse.fromJson(
        jsonDecode(response.body),
      );
      if (verifyResponse.success && verifyResponse.code == "SUCCESS") {
        return verifyResponse;
      } else {
        throw Exception(
          verifyResponse.message.isNotEmpty
              ? verifyResponse.message
              : "Failed to verify OTP",
        );
      }
    } else {
      throw Exception("Network error: ${response.statusCode}");
    }
  }

  Future<ResetPasswordResponse> resetPassword(
    ResetPasswordRequest request,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/auth/forgot-password/reset-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 401 ||
        response.statusCode == 400) {
      final resetResponse = ResetPasswordResponse.fromJson(
        jsonDecode(response.body),
      );
      if (resetResponse.success && resetResponse.code == "SUCCESS") {
        return resetResponse;
      } else {
        throw Exception(
          resetResponse.message.isNotEmpty
              ? resetResponse.message
              : "Failed to reset password",
        );
      }
    } else {
      throw Exception("Network error: ${response.statusCode}");
    }
  }
}
