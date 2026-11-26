import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_viewmodel.dart';
import 'tabs/home_tab_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Color Constants matching My Profile Screen (ProfileScreen)
  static const Color primaryBlue = Color(0xFF555ABC);
  static const Color primaryDarkBlue = Color(0xFF17193F);
  static const Color primaryLightBlue = Color(0xFF8B8ED3);

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Get.find<HomeViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header Section matching My Profile header design
            _buildHeader(viewModel),

            // 2. Main Content Area
            const Expanded(child: HomeTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(HomeViewModel viewModel) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryDarkBlue, primaryBlue, primaryLightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Glow Circles matching My Profile Header
          Positioned(
            right: -40,
            top: -50,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Header Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar Badge matching My Profile Header style
                    Container(
                      width: 52,
                      height: 52,
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Color(0xFFFFD166),
                            Color(0xFF60A5FA),
                            Color(0xFF93C5FD),
                            Color(0xFFFFD166),
                          ],
                        ),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF171B78),
                        ),
                        child: Center(
                          child: Obx(
                            () => Text(
                              viewModel.userName.value.isNotEmpty
                                  ? viewModel.userName.value[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Obx(
                                  () => Text(
                                    'Hi, ${viewModel.userName.value}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text('👋', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Obx(
                            () => Text(
                              'Today – ${viewModel.currentDate.value}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.90),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Notification Bell matching My Profile/Dashboard style
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          Positioned(
                            top: 6,
                            right: 7,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wb_sunny_outlined, color: Colors.yellow, size: 12),
                        SizedBox(width: 4),
                        Text(
                          '28°C Vijay Nagar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
