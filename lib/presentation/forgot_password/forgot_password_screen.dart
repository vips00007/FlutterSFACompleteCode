import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_practice_sr_level/core/colors/app_colors.dart';
import 'package:flutter_practice_sr_level/presentation/forgot_password/forgot_password_viewmodel.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordViewModel viewModel =
        Get.find<ForgotPasswordViewModel>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => viewModel.previousStep(),
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
        child: SafeArea(child: _buildForgetPasswordStep(viewModel)),
      ),
    );
  }

  Widget _buildForgetPasswordStep(ForgotPasswordViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildIconHeader(
            'assets/images/forgot_password.png',
            Colors.black,
            120,
          ),
          const SizedBox(height: 10),
          const Text(
            'FORGOT\n PASSWORD',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Enter the mobile number linked to your account to reset your password.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.sfaBlue),
          ),
          const SizedBox(height: 20),
          _buildCountryCodeSelector(viewModel),
          const SizedBox(height: 20),
          _buildLoginStyleTextField(
            controller: viewModel.phoneController,
            hintText: 'Enter Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          Obx(
            () => viewModel.phoneError.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 4, left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        viewModel.phoneError.value,
                        style: const TextStyle(color: Colors.red, fontSize: 11),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 30),
          Obx(
            () => _buildPrimaryButton(
              text: 'NEXT',
              onPressed: viewModel.sendOtp,
              isLoading: viewModel.isLoading.value,
            ),
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

  Widget _buildCountryCodeSelector(ForgotPasswordViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.fieldBackground,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildLoginStyleTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
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
