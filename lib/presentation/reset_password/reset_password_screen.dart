import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_practice_sr_level/core/colors/app_colors.dart';
import 'reset_password_viewmodel.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordViewModel viewModel = Get.find<ResetPasswordViewModel>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Obx(
          () => !viewModel.isSuccess.value
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Get.back(),
                )
              : const SizedBox.shrink(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.loginButtonBlue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.6],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (viewModel.isSuccess.value) {
              return _buildSuccessStep(viewModel);
            } else {
              return _buildNewCredentialsStep(viewModel);
            }
          }),
        ),
      ),
    );
  }

  Widget _buildNewCredentialsStep(ResetPasswordViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 30),
          _buildIconHeader(
            'assets/images/forgot_password.png',
            Colors.black,
            130,
          ),
          const SizedBox(height: 30),
          const Text(
            'NEW \n CREDENTIALS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.sfaBlue,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your identity has been verified!\nSet your new password',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.sfaTextGray),
          ),
          const SizedBox(height: 40),
          _buildTextField(
            controller: viewModel.passwordController,
            hint: 'New Password',
            prefixIcon: Icons.lock_outline,
            obscureText: !viewModel.isPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                size: 20,
              ),
              onPressed: viewModel.togglePasswordVisibility,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: viewModel.confirmPasswordController,
            hint: 'Confirm Password',
            prefixIcon: Icons.lock_outline,
            obscureText: !viewModel.isConfirmPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.isConfirmPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                size: 20,
              ),
              onPressed: viewModel.toggleConfirmPasswordVisibility,
            ),
          ),
          const SizedBox(height: 40),
          _buildPrimaryButton(
            text: 'UPDATE',
            onPressed: () => viewModel.updatePassword(),
            isLoading: viewModel.isLoading.value,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep(ResetPasswordViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'PASSWORD\n UPDATED',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 50),
          ),
          const SizedBox(height: 40),
          const Text(
            'your password has been updated!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.sfaTextGray),
          ),
          const SizedBox(height: 40),
          _buildPrimaryButton(
            text: 'LOGIN',
            onPressed: viewModel.goToLogin,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildIconHeader(dynamic icon, Color color, double size) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: icon is String
          ? Image.asset(icon, width: size * 0.6, height: size * 0.6)
          : Icon(icon as IconData, size: size * 0.6, color: color),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    double borderRadius = 4.0,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.fieldBackground,
        prefixIcon: Icon(prefixIcon, color: Colors.black, size: 20),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    Color color = AppColors.sfaBlue,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }
}
