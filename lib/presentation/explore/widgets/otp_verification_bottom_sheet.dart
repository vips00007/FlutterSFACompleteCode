import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../add_outlet_viewmodel.dart';
import '../explore_screen.dart'; // For HtmlColors

class OtpVerificationBottomSheet extends StatefulWidget {
  final AddOutletViewModel viewModel;
  final String mobileNumber;

  const OtpVerificationBottomSheet({
    super.key,
    required this.viewModel,
    required this.mobileNumber,
  });

  static Future<void> show(BuildContext context, AddOutletViewModel viewModel) async {
    final mobile = viewModel.mobileController.text.trim();
    final sent = await viewModel.sendMobileOtp();
    if (!sent) return;

    if (!context.mounted) return;

    Get.bottomSheet(
      OtpVerificationBottomSheet(
        viewModel: viewModel,
        mobileNumber: mobile,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      enterBottomSheetDuration: const Duration(milliseconds: 350),
      exitBottomSheetDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  State<OtpVerificationBottomSheet> createState() => _OtpVerificationBottomSheetState();
}

class _OtpVerificationBottomSheetState extends State<OtpVerificationBottomSheet> {
  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String _maskMobile(String phone) {
    final clean = phone.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 10) {
      return '+91 ${clean.substring(0, 2)}******${clean.substring(8)}';
    }
    return phone;
  }

  String get _currentOtp => _controllers.map((c) => c.text).join();

  void _onVerifyPressed() async {
    final otp = _currentOtp;
    if (otp.length < 5) {
      Get.snackbar(
        'Incomplete OTP',
        'Please enter all 5 digits of the OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
      return;
    }

    final success = await widget.viewModel.verifyMobileOtp(otp);
    if (success) {
      if (mounted && Get.isBottomSheetOpen == true) {
        Get.back();
      }
      Get.snackbar(
        'Mobile Number Verified',
        'Your mobile number has been successfully verified.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE8F5E9),
        colorText: const Color(0xFF1B5E20),
        icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32)),
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _handlePaste(String text, int startIndex) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;

    for (int i = 0; i < digits.length && (startIndex + i) < 5; i++) {
      _controllers[startIndex + i].text = digits[i];
    }

    int nextIndex = startIndex + digits.length;
    if (nextIndex >= 5) {
      _focusNodes[4].unfocus();
      if (_currentOtp.length == 5) {
        _onVerifyPressed();
      }
    } else {
      _focusNodes[nextIndex].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: HtmlColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: HtmlColors.lineConnector,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Header Icon & Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: HtmlColors.pri.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        color: HtmlColors.pri,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verify Mobile Number',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: HtmlColors.ink,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Enter the 5-digit verification code',
                          style: TextStyle(
                            fontSize: 12,
                            color: HtmlColors.mut,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close_rounded, color: HtmlColors.mut),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Masked Number Display Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: HtmlColors.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: HtmlColors.line),
              ),
              child: Row(
                children: [
                  const Icon(Icons.phone_iphone_rounded, size: 20, color: HtmlColors.pri),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Code sent to ',
                        style: const TextStyle(fontSize: 13, color: HtmlColors.mut),
                        children: [
                          TextSpan(
                            text: _maskMobile(widget.mobileNumber),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: HtmlColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 5 OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                return SizedBox(
                  width: 52,
                  height: 60,
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: (KeyEvent event) {
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.backspace &&
                          _controllers[index].text.isEmpty &&
                          index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                    },
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 5,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: HtmlColors.pri,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _controllers[index].text.isNotEmpty
                                ? HtmlColors.pri
                                : HtmlColors.line,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: HtmlColors.pri,
                            width: 2.2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length > 1) {
                          _handlePaste(value, index);
                          return;
                        }

                        if (value.isNotEmpty) {
                          if (index < 4) {
                            _focusNodes[index + 1].requestFocus();
                          } else {
                            _focusNodes[index].unfocus();
                            if (_currentOtp.length == 5) {
                              _onVerifyPressed();
                            }
                          }
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Resend OTP Countdown
            Obx(() {
              final seconds = widget.viewModel.resendCountdown.value;
              final isSending = widget.viewModel.isSendingOtp.value;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(fontSize: 13, color: HtmlColors.mut),
                  ),
                  if (seconds > 0)
                    Text(
                      'Resend in ${seconds}s',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: HtmlColors.mut,
                      ),
                    )
                  else
                    InkWell(
                      onTap: isSending
                          ? null
                          : () async {
                              final sent = await widget.viewModel.resendMobileOtp();
                              if (sent) {
                                for (var c in _controllers) {
                                  c.clear();
                                }
                                _focusNodes[0].requestFocus();
                              }
                            },
                      child: Text(
                        isSending ? 'Sending...' : 'Resend OTP',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: HtmlColors.pri,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              );
            }),
            const SizedBox(height: 28),

            // Submit / Verify OTP Button
            Obx(() {
              final isVerifying = widget.viewModel.isVerifyingOtp.value;

              return SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isVerifying ? null : _onVerifyPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HtmlColors.pri,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isVerifying
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Verify OTP',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                ),
              );
            }),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
