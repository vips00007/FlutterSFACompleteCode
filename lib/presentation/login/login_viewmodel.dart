import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../routes/route_names.dart';
import '../../core/utils/shared_prefs_manager.dart';
import '../otp_verification/otp_verification_viewmodel.dart';

class LoginViewModel extends GetxController {
  final LoginUseCase loginUseCase;

  LoginViewModel(this.loginUseCase);

  final isLoading = false.obs;
  final rememberMe = false.obs;
  final isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    rememberMe.value = SharedPrefsManager.isRememberMeEnabled();
  }

  Future<void> login(String identifier) async {
    if (identifier.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your identifier",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        icon: const Icon(Icons.error_outline, color: Colors.red),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );

      return;
    }

    isLoading.value = true;
    try {
      final otpData = await loginUseCase.execute(identifier);

      // Save/Clear Credentials based on Remember Me
      await SharedPrefsManager.setRememberMe(rememberMe.value);
      if (rememberMe.value) {
        await SharedPrefsManager.saveCredentials(identifier, '');
      } else {
        await SharedPrefsManager.clearCredentials();
      }

      isLoading.value = false;
      
      Get.toNamed(RoutesName.otp_view, arguments: {
        'flowType': OtpFlowType.login,
        'identifier': identifier,
        'challengeId': otpData.challengeId,
        'otpExpiresInSeconds': otpData.otpExpiresInSeconds,
        'resendAfterSeconds': otpData.resendAfterSeconds,
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

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
