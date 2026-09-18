import 'package:flutter_practice_sr_level/domain/entities/user.dart';
import 'package:flutter_practice_sr_level/data/models/forgot_password_response.dart';
import 'package:flutter_practice_sr_level/data/models/sfa_otp_models.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<SendLoginOtpData> sendLoginOtp(String identifier);
  Future<ForgotPasswordData> requestPasswordReset(String identifier);
  Future<VerifyOtpData> verifyOtp(String identifier, String otp);
  Future<User> verifyLoginOtp(String challengeId, String otp);
  Future<void> updatePassword(String resetToken, String newPassword);
}
