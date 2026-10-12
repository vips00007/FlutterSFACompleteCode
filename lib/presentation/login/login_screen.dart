import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import '../../routes/route_names.dart';
import '../../core/utils/shared_prefs_manager.dart';
import 'login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  final LoginViewModel viewModel = Get.find<LoginViewModel>();

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    // Load saved credentials if Remember Me is enabled
    if (SharedPrefsManager.isRememberMeEnabled()) {
      usernameController.text = SharedPrefsManager.getSavedUsername() ?? '';
      passwordController.text = SharedPrefsManager.getSavedPassword() ?? '';
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 130,
                    height: 55,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Smarter Sales. Stronger Tomorrow.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFeatureItem(Icons.trending_up, 'Sales\nAutomation'),
                      _buildFeatureItem(
                        Icons.location_on_outlined,
                        'Field\nTracking',
                      ),
                      _buildFeatureItem(Icons.groups_outlined, 'Engagement'),
                      _buildFeatureItem(
                        Icons.track_changes_outlined,
                        'Performance',
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/authentication.png',
                      width: 10,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Securely sign in to your SFA account ',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.loginButtonBlue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                    controller: usernameController,
                    hintText: 'Identifier',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => SizedBox(
                              width: 22,
                              height: 22,
                              child: Checkbox(
                                value: viewModel.rememberMe.value,
                                onChanged: (_) => viewModel.toggleRememberMe(),
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Remember me',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () =>
                            Get.toNamed(RoutesName.forgot_password_view),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.loginButtonBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: viewModel.isLoading.value
                            ? null
                            : () => viewModel.login(
                                usernameController.text.trim(),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.loginButtonBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                        ),
                        child: viewModel.isLoading.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Generate OTP',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.loginButtonBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info,
                          color: Color(0xFF0F172A),
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'We’ve verified your credentials. A secure OTP has been sent to your registered mobile number.',
                            style: TextStyle(
                              color: AppColors.loginButtonBlue,
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'CONNECT    ENABLE    GROW',
                    style: TextStyle(
                      color: AppColors.loginButtonBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Powered by Dhruva.Ai',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1.5,
            ),
            color: Colors.white.withValues(alpha: 0.15),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
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
        obscureText: isPassword && !isPasswordVisible,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 18),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }
}
