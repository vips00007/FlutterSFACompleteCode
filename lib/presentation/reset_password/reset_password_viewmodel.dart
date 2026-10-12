import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_practice_sr_level/domain/usecases/update_password_usecase.dart';
import 'package:flutter_practice_sr_level/routes/route_names.dart';

class ResetPasswordViewModel extends GetxController {
  final UpdatePasswordUseCase updatePasswordUseCase;

  ResetPasswordViewModel({required this.updatePasswordUseCase});

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final isSuccess = false.obs;

  late String resetToken;
  late String identifier;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    resetToken = args['resetToken'] ?? '';
    identifier = args['identifier'] ?? '';
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

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
      await updatePasswordUseCase.execute(resetToken, pass);
      isLoading.value = false;
      isSuccess.value = true;
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
    Get.offAllNamed(RoutesName.login_view);
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
