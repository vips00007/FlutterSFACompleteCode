import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'otp_verification_viewmodel.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OtpVerificationViewModel viewModel =
        Get.find<OtpVerificationViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8A2BE2), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.7],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Top Section
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.flash_on,
                                    color: Colors.black87,
                                    size: 50,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'FieldPro',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sales Force Automation',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bottom White Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, -5),
                              ),
                            ],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  InkWell(
                                    onTap: () => Get.back(),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.arrow_back_ios,
                                            color: Color(0xFF6B21A8),
                                            size: 14,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Back',
                                            style: TextStyle(
                                              color: Color(0xFF6B21A8),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Center(
                                    child: Text(
                                      'Lets Verify your OTP',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Sent to ${viewModel.maskedIdentifier}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'we send a 5 digit code to device it will\nautomatically verify once entered',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 32),
                              _buildOtpInput(viewModel),
                              const SizedBox(height: 20),
                              Obx(() {
                                final resendSec =
                                    viewModel.resendCountdown.value;
                                return TextButton(
                                  onPressed:
                                      resendSec > 0 || viewModel.isLoading.value
                                      ? null
                                      : viewModel.resendOtp,
                                  child: Text(
                                    resendSec > 0
                                        ? 'Resend in ${resendSec}s'
                                        : 'Resend',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: resendSec > 0
                                          ? Colors.grey
                                          : const Color(0xFF6B21A8),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(height: 16),
                              const Text(
                                'Trouble signing in? Contact your SMS or call 1800-102-4455',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInput(OtpVerificationViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        return SizedBox(
          width: 50,
          height: 55,
          child: KeyboardListener(
            focusNode: FocusNode(), // Temporary focus node for keyboard events
            onKeyEvent: (KeyEvent event) {
              if (event is KeyDownEvent &&
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xFF6B21A8),
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF6B21A8),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF6B21A8),
                    width: 2.0,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.length > 1) {
                  // Handle Paste
                  for (int i = 0; i < value.length && (index + i) < 5; i++) {
                    viewModel.otpControllers[index + i].text = value[i];
                  }
                  int nextFocus = index + value.length;
                  if (nextFocus > 4) {
                    viewModel.otpFocusNodes[4].unfocus();
                    viewModel.verifyOtp();
                  } else {
                    viewModel.otpFocusNodes[nextFocus].requestFocus();
                  }
                  return;
                }
                if (value.isNotEmpty) {
                  if (index < 4) {
                    viewModel.otpFocusNodes[index + 1].requestFocus();
                  } else {
                    viewModel.otpFocusNodes[index].unfocus();
                    viewModel.verifyOtp();
                  }
                }
              },
            ),
          ),
        );
      }),
    );
  }
}
