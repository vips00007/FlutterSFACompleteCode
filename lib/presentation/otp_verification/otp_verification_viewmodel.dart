import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_practice_sr_level/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_practice_sr_level/domain/usecases/verify_login_otp_usecase.dart';
import 'package:flutter_practice_sr_level/domain/usecases/forgot_password_usecase.dart';
import 'package:flutter_practice_sr_level/domain/usecases/login_usecase.dart';
import 'package:flutter_practice_sr_level/routes/route_names.dart';
import 'package:flutter_practice_sr_level/core/utils/shared_prefs_manager.dart';
import 'package:flutter_practice_sr_level/domain/entities/user.dart';

enum OtpFlowType { forgotPassword, login }

class OtpVerificationViewModel extends GetxController {
  final VerifyOtpUseCase verifyOtpUseCase;
  final VerifyLoginOtpUseCase verifyLoginOtpUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final LoginUseCase loginUseCase;

  OtpVerificationViewModel({
    required this.verifyOtpUseCase,
    required this.verifyLoginOtpUseCase,
    required this.forgotPasswordUseCase,
    required this.loginUseCase,
  });

  late OtpFlowType flowType;
  late String identifier;
  late String maskedIdentifier;
  late String tenantCode; // Optional, used for legacy resend if needed
  User? loginUser; // Store user data passed from login screen
  String? challengeId;

  final otpControllers = List.generate(5, (index) => TextEditingController());
  final otpFocusNodes = List.generate(5, (index) => FocusNode());

  final isLoading = false.obs;
  final expiryCountdown = 60.obs; 
  final resendCountdown = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    flowType = args['flowType'] as OtpFlowType;
    identifier = args['identifier'] ?? args['phone'] ?? '';
    maskedIdentifier = args['maskedIdentifier'] ?? identifier;
    tenantCode = args['tenantCode'] ?? '';
    loginUser = args['user'] as User?;
    challengeId = args['challengeId'];
    
    int expirySec = args['otpExpiresInSeconds'] ?? 60;
    int resendSec = args['resendAfterSeconds'] ?? 60;

    _startTimer(expirySec, resendSec);
  }

  void _startTimer(int expirySec, int resendSec) {
    _timer?.cancel();
    expiryCountdown.value = expirySec;
    resendCountdown.value = resendSec;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (expiryCountdown.value > 0) {
        expiryCountdown.value--;
      }
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      }
      if (expiryCountdown.value == 0 && resendCountdown.value == 0) {
        _timer?.cancel();
      }
    });
  }

  Future<void> verifyOtp() async {
    String otp = otpControllers.map((c) => c.text).join();
    if (otp.length < 5) {
      Get.snackbar(
        "Error",
        "Please enter the full 5-digit code",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;
    try {
      if (flowType == OtpFlowType.forgotPassword) {
        final data = await verifyOtpUseCase.execute(identifier, otp);
        isLoading.value = false;
        Get.toNamed(RoutesName.reset_password_view, arguments: {
          'identifier': identifier,
          'resetToken': data.resetToken,
        });
      } else {
        if (challengeId == null || challengeId!.isEmpty) {
          throw Exception("Challenge session expired or missing. Please try again.");
        }
        // Verify Login OTP using challengeId
        final user = await verifyLoginOtpUseCase.execute(challengeId!, otp);

        // Save Session & User Data
        await SharedPrefsManager.saveSessionData(
          token: user.accessToken,
          tokenType: user.tokenType,
          expiresIn: user.expiresIn,
          expiresAt: user.expiresAt,
          userUuid: user.userUuid,
          username: user.username,
          displayName: user.displayName,
          companyUuid: user.companyUuid,
          companyCode: user.companyCode,
          roles: user.roles,
          mustChangePassword: user.mustChangePassword,
          sessionMode: user.sessionMode,
          channel: user.channel,
        );

        isLoading.value = false;
        Get.offAllNamed(RoutesName.dashboard_view);
      }
    } catch (e) {
      isLoading.value = false;
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.substring(11);
      }
      Get.snackbar(
        "Error",
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    }
  }

  Future<void> resendOtp() async {
    if (resendCountdown.value > 0 || isLoading.value) return;

    isLoading.value = true;
    try {
      if (flowType == OtpFlowType.forgotPassword) {
        final data = await forgotPasswordUseCase.execute(identifier);
        _startTimer(data.otpExpiresInSeconds, data.resendAfterSeconds);
      } else {
        // Real resend for login flow
        final otpData = await loginUseCase.execute(identifier);
        challengeId = otpData.challengeId;
        _startTimer(otpData.otpExpiresInSeconds, otpData.resendAfterSeconds);
      }
      
      isLoading.value = false;
      Get.snackbar("Success", "OTP has been resent successfully", snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade900,
      );
    } catch (e) {
      isLoading.value = false;
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.substring(11);
      }
      Get.snackbar("Error", errorMsg, snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in otpFocusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
