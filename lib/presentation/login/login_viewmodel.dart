import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../routes/route_names.dart';
import '../../core/utils/shared_prefs_manager.dart';

class LoginViewModel extends GetxController {
  final LoginUseCase loginUseCase;

  LoginViewModel(this.loginUseCase);

  final isLoading = false.obs;
  final rememberMe = false.obs;
  final isPasswordVisible = false.obs;

  String savedMobile = '';
  String savedPassword = '';

  @override
  void onInit() {
    super.onInit();
    rememberMe.value = SharedPrefsManager.isRememberMeEnabled();
    if (rememberMe.value) {
      savedMobile = SharedPrefsManager.getSavedUsername() ?? '';
      savedPassword = SharedPrefsManager.getSavedPassword() ?? '';
    }
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login(String mobileNumber, String password) async {
    final cleanMobile = mobileNumber.trim();

    if (cleanMobile.isEmpty) {
      _showError("Please enter your mobile number");
      return;
    }

    if (cleanMobile.length != 10 || !RegExp(r'^[0-9]{10}$').hasMatch(cleanMobile)) {
      _showError("Please enter a valid 10-digit mobile number");
      return;
    }

    if (password.isEmpty) {
      _showError("Please enter your password");
      return;
    }

    isLoading.value = true;
    try {
      final user = await loginUseCase.execute(cleanMobile, password);

      // Save or clear credentials based on Remember Me setting
      await SharedPrefsManager.setRememberMe(rememberMe.value);
      if (rememberMe.value) {
        await SharedPrefsManager.saveCredentials(cleanMobile, password);
      } else {
        await SharedPrefsManager.clearCredentials();
      }

      // Save access token and user session details securely
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
        mobile: cleanMobile,
      );

      isLoading.value = false;

      // Handle mandatory password change requirement
      if (user.mustChangePassword) {
        Get.offAllNamed(
          RoutesName.reset_password_view,
          arguments: {
            'resetToken': user.accessToken,
            'identifier': user.username,
          },
        );
      } else {
        Get.offAllNamed(RoutesName.dashboard_view);
      }
    } catch (e) {
      isLoading.value = false;
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.substring(11);
      }
      _showError(errorMsg);
    }
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade50,
      colorText: Colors.red.shade900,
      icon: const Icon(Icons.error_outline, color: Colors.red),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}
