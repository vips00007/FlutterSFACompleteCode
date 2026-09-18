import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_practice_sr_level/domain/usecases/forgot_password_usecase.dart';
import 'package:flutter_practice_sr_level/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_practice_sr_level/domain/usecases/update_password_usecase.dart';
import 'package:flutter_practice_sr_level/routes/route_names.dart';
import 'package:flutter_practice_sr_level/presentation/otp_verification/otp_verification_viewmodel.dart';

class ForgotPasswordViewModel extends GetxController {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;

  ForgotPasswordViewModel({
    required this.forgotPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.updatePasswordUseCase,
  });

  // Flow Control
  final currentStep = 0.obs; // 0: Forget, 1: Verify, 2: New Creds, 3: Success

  // Step 1: Forget Password
  final phoneController = TextEditingController();
  final selectedCountryCode = "+92".obs;

  // Validation Errors
  final phoneError = "".obs;

  final isLoading = false.obs;

  // Internal state
  final resetToken = "".obs;

  // Step 3: New Credentials
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('step')) {
      currentStep.value = args['step'];
      if (args.containsKey('phone')) {
        phoneController.text = args['phone'];
      }
      if (args.containsKey('identifier')) {
        phoneController.text = args['identifier'];
      }
      if (args.containsKey('resetToken')) {
        resetToken.value = args['resetToken'];
      }
    }
  }

  // Step 1 Action
  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();

    // Reset errors
    phoneError.value = "";

    if (phone.isEmpty) {
      phoneError.value = "Phone Number must not be empty";
      return;
    } else if (phone.length < 7) {
      phoneError.value = "Please enter a valid phone number";
      return;
    }

    isLoading.value = true;
    try {
      final data = await forgotPasswordUseCase.execute(phone);
      
      isLoading.value = false;
      // Navigate to reusable OTP screen
      Get.toNamed(RoutesName.otp_view, arguments: {
        'flowType': OtpFlowType.forgotPassword,
        'identifier': phone,
        'maskedIdentifier': data.maskedIdentifier,
        'otpExpiresInSeconds': data.otpExpiresInSeconds,
        'resendAfterSeconds': data.resendAfterSeconds,
      });
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

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  // Step 3 Action
  Future<void> updatePassword() async {
    final pass = passwordController.text;
    final confirmPass = confirmPasswordController.text;

    if (pass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (pass != confirmPass) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;
    try {
      await updatePasswordUseCase.execute(resetToken.value, pass);
      isLoading.value = false;
      nextStep();
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

  void goToLogin() {
    // Clear state
    resetToken.value = "";
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    Get.offAllNamed(RoutesName.login_view);
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
