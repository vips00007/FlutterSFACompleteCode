import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import 'otp_verification_viewmodel.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OtpVerificationViewModel viewModel = Get.find<OtpVerificationViewModel>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'CO\nDE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                    height: 0.9,
                  ),
                ),
                const Text(
                  'VERIFICATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0081C9),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  'OTP sent to ${viewModel.maskedIdentifier}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: AppColors.sfaTextGray),
                ),
                const SizedBox(height: 35),
                _buildOtpInput(viewModel),
                const SizedBox(height: 20),
                Obx(() {
                  final expirySec = viewModel.expiryCountdown.value;
                  return expirySec > 0
                      ? Text(
                          'OTP expires in ${expirySec}s',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        )
                      : const SizedBox.shrink();
                }),
                const SizedBox(height: 25),
                Obx(() => _buildPrimaryButton(
                  text: 'VERIFY CODE',
                  onPressed: viewModel.verifyOtp,
                  isLoading: viewModel.isLoading.value,
                )),
                const SizedBox(height: 20),
                Obx(() {
                  final resendSec = viewModel.resendCountdown.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive code? ",
                        style: TextStyle(fontSize: 13, color: AppColors.sfaTextGray),
                      ),
                      TextButton(
                        onPressed: resendSec > 0 || viewModel.isLoading.value ? null : viewModel.resendOtp,
                        child: Text(
                          resendSec > 0 ? 'Resend in ${resendSec}s' : 'Resend OTP',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: resendSec > 0 ? Colors.grey : const Color(0xFF0081C9),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInput(OtpVerificationViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 42,
          height: 42,
          child: RawKeyboardListener(
            focusNode: FocusNode(), // Temporary focus node for keyboard events
            onKey: (RawKeyEvent event) {
              if (event is RawKeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace &&
                  viewModel.otpControllers[index].text.isEmpty &&
                  index > 0) {
                viewModel.otpFocusNodes[index - 1].requestFocus();
              }
            },
            child: TextField(
              controller: viewModel.otpControllers[index],
              focusNode: viewModel.otpFocusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: AppColors.fieldBackground,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.sfaBlue, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.sfaBlue, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.sfaBlue),
                ),
              ),
              onChanged: (value) {
                if (value.length > 1) {
                  // Handle Paste
                  for (int i = 0; i < value.length && (index + i) < 5; i++) {
                    viewModel.otpControllers[index + i].text = value[i];
                  }
                  int nextFocus = index + value.length;
                  if (nextFocus > 4) nextFocus = 4;
                  viewModel.otpFocusNodes[nextFocus].requestFocus();
                  return;
                }
                if (value.isNotEmpty) {
                  if (index < 4) {
                    viewModel.otpFocusNodes[index + 1].requestFocus();
                  } else {
                    viewModel.otpFocusNodes[index].unfocus();
                  }
                }
              },
            ),
          ),
        );
      }),
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
