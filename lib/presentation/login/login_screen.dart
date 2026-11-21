import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../routes/route_names.dart';
import 'login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController mobileController;
  late final TextEditingController passwordController;
  final LoginViewModel viewModel = Get.find<LoginViewModel>();

  // Wave heights as a fraction of screen height (kept small / decorative)
  static const double _topWaveFactor = 0.07;
  static const double _bottomWaveFactor = 0.06;

  @override
  void initState() {
    super.initState();
    mobileController = TextEditingController(text: viewModel.savedMobile);
    passwordController = TextEditingController(text: viewModel.savedPassword);
  }

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomWaveHeight = size.height * _bottomWaveFactor;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F2FC),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            // 1. Top decorative waves (small, corners only)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(size.width, size.height * _topWaveFactor),
                painter: _TopWavePainter(),
              ),
            ),

            // 2. City skyline (behind the male character)
            Positioned(
              top: size.height * 0.05,
              right: 0,
              left: 0,
              height: size.height * 0.42,
              child: Image.asset(
                'assets/images/background_only.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),

            // 3. Middle transition curve
            Positioned(
              top: size.height * 0.35,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(size.width, size.height * 0.1),
                painter: _MiddleWavePainter(),
              ),
            ),

            // 4. Male sales representative image
            Positioned(
              top: size.height * 0.05,
              right: -20,
              child: SizedBox(
                width: size.width * 0.65,
                height: size.height * 0.42,
                child: Image.asset(
                  'assets/images/sales_person.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),

            // 5. Bottom decorative overlapping waves (thin)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(size.width, bottomWaveHeight),
                painter: _BottomWavesPainter(),
              ),
            ),

            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomWaveHeight),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),

                              // Logo & company name
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF311B92),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.flash_on,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dhruva.Ai',
                                          style: TextStyle(
                                            color: Color(0xFF2C1068),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          'Together for a Growing Tomorrow',
                                          style: TextStyle(
                                            color: Color(0xFF311B92),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // SFA text
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'SFA',
                                          style: TextStyle(
                                            fontSize: 56,
                                            fontWeight: FontWeight.w800,
                                            fontStyle: FontStyle.italic,
                                            color: Color(0xFF311B92),
                                            height: 1.0,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: const Offset(0, 8),
                                          child: Transform.rotate(
                                            angle: -math.pi / 4,
                                            child: const Icon(
                                              Icons.arrow_right_alt,
                                              color: Colors.orange,
                                              size: 36,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      'Sales Force Automation',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF311B92),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        _buildBulletText('Plan'),
                                        _buildBulletPoint(),
                                        _buildBulletText('Visit'),
                                        _buildBulletPoint(),
                                        _buildBulletText('Sell'),
                                        _buildBulletPoint(),
                                        _buildBulletText('Grow'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              // Login card
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(
                                        top: 85, left: 16, right: 16),
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 50, 20, 24),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Welcome Back!',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF311B92),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Login to access your SFA account',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF4A148C),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 24),

                                        // Mobile Number field
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF311B92)
                                                    .withValues(alpha: 0.05),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: TextField(
                                            controller: mobileController,
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(10),
                                            ],
                                            decoration: InputDecoration(
                                              hintText: 'Mobile Number',
                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 14,
                                              ),
                                              prefixIcon: const Icon(
                                                Icons.phone_android_outlined,
                                                color: Color(0xFF4A148C),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 14),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 1.2,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(16),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF4A148C),
                                                  width: 2.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 16),

                                        // Password field
                                        Obx(
                                          () => Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF311B92)
                                                      .withValues(alpha: 0.05),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: TextField(
                                              controller: passwordController,
                                              obscureText: !viewModel.isPasswordVisible.value,
                                              decoration: InputDecoration(
                                                hintText: 'Password',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 14,
                                                ),
                                                prefixIcon: const Icon(
                                                  Icons.lock_outline,
                                                  color: Color(0xFF4A148C),
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    viewModel.isPasswordVisible.value
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: const Color(0xFF4A148C),
                                                  ),
                                                  onPressed: viewModel.togglePasswordVisibility,
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 14),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(16),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 1.2,
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(16),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF4A148C),
                                                    width: 2.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 16),

                                        // Remember Me (left) + Forgot Password? (right)
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Obx(
                                                        () => SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: Checkbox(
                                                        value: viewModel
                                                            .rememberMe.value,
                                                        onChanged: (_) => viewModel
                                                            .toggleRememberMe(),
                                                        activeColor:
                                                        const Color(
                                                            0xFF4A148C),
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(4),
                                                        ),
                                                        side: const BorderSide(
                                                          color:
                                                          Color(0xFF4A148C),
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Flexible(
                                                    child: Text(
                                                      'Remember Me',
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Color(0xFF190933),
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            TextButton(
                                              onPressed: () => Get.toNamed(
                                                  RoutesName.forgot_password_view),
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: Size.zero,
                                                tapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                              ),
                                              child: const Text(
                                                'Forgot Password?',
                                                style: TextStyle(
                                                  color: Color(0xFF4A148C),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 24),

                                        // Login button
                                        Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(25),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF673AB7),
                                                Color(0xFF311B92)
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF311B92)
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Obx(
                                                () => ElevatedButton(
                                              onPressed:
                                              viewModel.isLoading.value
                                                  ? null
                                                  : () => viewModel.login(
                                                  mobileController.text,
                                                  passwordController.text),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(25),
                                                ),
                                              ),
                                              child: viewModel.isLoading.value
                                                  ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.0,
                                                ),
                                              )
                                                  : const Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Text(
                                                    'Login',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Top-center circular icon
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF673AB7),
                                            Color(0xFF311B92)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withValues(alpha: 0.15),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.group,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Bottom feature section
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFeatureItem(
                                        Icons.trending_up, 'Track\nVisits'),
                                    _buildVerticalDivider(),
                                    _buildFeatureItem(
                                        Icons.assignment_turned_in_outlined,
                                        'Manage\nOrders'),
                                    _buildVerticalDivider(),
                                    _buildFeatureItem(
                                        Icons.track_changes, 'Achieve\nTargets'),
                                    _buildVerticalDivider(),
                                    _buildFeatureItem(
                                        Icons.emoji_events_outlined,
                                        'Win\nRewards'),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Bottom tagline
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 1,
                                    width: 40,
                                    color: const Color(0xFF311B92)
                                        .withValues(alpha: 0.3),
                                  ),
                                  const Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Text(
                                      'Empowering Our Sales Team',
                                      style: TextStyle(
                                        color: Color(0xFF311B92),
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    width: 40,
                                    color: const Color(0xFF311B92)
                                        .withValues(alpha: 0.3),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF311B92),
      ),
    );
  }

  Widget _buildBulletPoint() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Icon(
        Icons.circle,
        size: 5,
        color: const Color(0xFF673AB7).withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF4A148C), size: 26),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 45,
      width: 1,
      color: Colors.grey.shade400,
      margin: const EdgeInsets.only(top: 8),
    );
  }
}

// ----------------- CUSTOM PAINTERS -----------------

// Small, thin waves in the top corners
class _TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Top-left outer light layer
    final path1 = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.55, 0)
      ..quadraticBezierTo(w * 0.30, h * 0.75, 0, h)
      ..close();
    canvas.drawPath(
      path1,
      Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFF673AB7).withValues(alpha: 0.3),
            const Color(0xFF8A2BE2).withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Top-left inner darker layer
    final path2 = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.28, 0)
      ..quadraticBezierTo(w * 0.17, h * 0.5, 0, h * 0.65)
      ..close();
    canvas.drawPath(
      path2,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF673AB7), Color(0xFF4A148C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Top-right small curve
    final path3 = Path()
      ..moveTo(w, 0)
      ..lineTo(w * 0.78, 0)
      ..quadraticBezierTo(w * 0.92, h * 0.45, w, h * 0.6)
      ..close();
    canvas.drawPath(
      path3,
      Paint()..color = const Color(0xFF673AB7).withValues(alpha: 0.25),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Sweeping curve behind the login card and person
class _MiddleWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(size.width, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.6, 0, 0, size.height * 0.8);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF673AB7).withValues(alpha: 0.5),
          const Color(0xFF311B92).withValues(alpha: 0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Thin overlapping bottom waves
class _BottomWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Layer 1 (back, lightest violet)
    final path1 = Path()
      ..moveTo(0, h * 0.45)
      ..quadraticBezierTo(w * 0.5, -h * 0.1, w, h * 0.4)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      path1,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0x697E57C2), Color(0xFF673AB7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Layer 2 (middle violet)
    final path2 = Path()
      ..moveTo(0, h * 0.65)
      ..quadraticBezierTo(w * 0.35, h * 0.2, w * 0.7, h * 0.65)
      ..quadraticBezierTo(w * 0.9, h * 0.85, w, h * 0.7)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      path2,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF673AB7), Color(0xFF311B92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Layer 3 (front, darkest)
    final path3 = Path()
      ..moveTo(0, h * 0.82)
      ..quadraticBezierTo(w * 0.4, h * 0.45, w * 0.75, h * 0.9)
      ..quadraticBezierTo(w * 0.92, h * 1.0, w, h * 0.85)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(path3, Paint()..color = const Color(0xFF2C1068));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
