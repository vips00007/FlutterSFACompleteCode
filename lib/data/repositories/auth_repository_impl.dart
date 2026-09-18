import 'package:flutter_practice_sr_level/domain/entities/user.dart';
import 'package:flutter_practice_sr_level/domain/repositories/auth_repository.dart';
import 'package:flutter_practice_sr_level/data/datasource/remote/auth_api_service.dart';
import 'package:flutter_practice_sr_level/data/models/login_request.dart';
import 'package:flutter_practice_sr_level/data/models/forgot_password_request.dart';
import 'package:flutter_practice_sr_level/data/models/forgot_password_response.dart';
import 'package:flutter_practice_sr_level/data/models/sfa_otp_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;

  AuthRepositoryImpl(this.apiService);

  @override
  Future<User> login(String username, String password) async {
    final request = LoginRequest(username: username, password: password);
    final response = await apiService.login(request);
    return response.toEntity();
  }

  @override
  Future<SendLoginOtpData> sendLoginOtp(String identifier) async {
    final request = SendLoginOtpRequest(identifier: identifier);
    final response = await apiService.sendLoginOtp(request);
    if (response.data == null) {
      throw Exception("Response data is missing");
    }
    return response.data!;
  }

  @override
  Future<ForgotPasswordData> requestPasswordReset(String identifier) async {
    final request = ForgotPasswordRequest(identifier: identifier);
    final response = await apiService.forgotPasswordSendOtp(request);
    if (response.data == null) {
      throw Exception("Response data is missing");
    }
    return response.data!;
  }

  @override
  Future<VerifyOtpData> verifyOtp(String identifier, String otp) async {
    final request = VerifyOtpRequest(identifier: identifier, otp: otp);
    final response = await apiService.verifyForgotPasswordOtp(request);
    if (response.data == null) {
      throw Exception("Response data is missing");
    }
    return response.data!;
  }

  @override
  Future<User> verifyLoginOtp(String challengeId, String otp) async {
    final request = VerifyLoginOtpRequest(challengeId: challengeId, otp: otp);
    final response = await apiService.verifyLoginOtp(request);
    return response.toEntity();
  }

  @override
  Future<void> updatePassword(String resetToken, String newPassword) async {
    final request = ResetPasswordRequest(resetToken: resetToken, newPassword: newPassword);
    final response = await apiService.resetPassword(request);
    if (response.data == null || !response.data!.passwordReset) {
      throw Exception("Failed to reset password");
    }
  }
}
