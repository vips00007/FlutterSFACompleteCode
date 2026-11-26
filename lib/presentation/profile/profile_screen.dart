import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/route_names.dart';
import 'profile_viewmodel.dart';

/// Redesigned My Profile screen following the exact header style, blue theme,
/// typography, and spacing of the More Options page (FavoritesScreen).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Color Constants matching More Options Page (Add Outlet / SFA Theme)

  // Color Constants matching Add Outlet Screen (HtmlColors)
  static const Color primaryBlue = Color(0xFF555ABC); // Vibrant Primary Blue
  static const Color primaryDarkBlue = Color(0xFF17193F); // Deep Header Blue
  static const Color primaryLightBlue = Color(0xFF8B8ED3); // Light Accent Blue
  static const Color bgColor = Color(0xFFF4F3F9); // Add Outlet Page Background
  static const Color cardColor = Colors.white;
  static const Color inkColor = Color(0xFF17193F); // Dark Text Color
  static const Color slateColor = Color(0xFF6B6F93); // Muted Label Text Color
  static const Color lineColor = Color(0xFFDCDBEA); // Subtle Line Border Color

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(ProfileViewModel());

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Blue Hero Header matching More Options Page Header
            _buildHeroHeader(context, viewModel),

            // 2. Contact Information Card Section
            _buildContactInfoCard(viewModel),

            // 3. Work Information Card Section
            _buildWorkInfoCard(viewModel),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 1. Hero Header Section matching More Options Page
  Widget _buildHeroHeader(BuildContext context, ProfileViewModel viewModel) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

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
          // Background Glow Circles
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
            padding: EdgeInsets.fromLTRB(14, statusBarHeight + 10, 14, 46),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Navigation Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    Text(
                      'MY PROFILE',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.90),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    // Edit Button
                    InkWell(
                      onTap: () => Get.toNamed(RoutesName.edit_profile_view),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Compact Profile Row
                InkWell(
                  onTap: () => Get.toNamed(RoutesName.edit_profile_view),
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    children: [
                      // Avatar Badge
                      Container(
                        width: 60,
                        height: 60,
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
                                    : 'G',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Profile Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                viewModel.userName.value,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 3),

                            // Role Chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.person_outline_rounded,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                  const SizedBox(width: 4),
                                  Obx(
                                    () => Text(
                                      viewModel.role.value,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Contact Detail Row
                            Obx(
                              () => Wrap(
                                spacing: 10,
                                runSpacing: 2,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.phone_outlined,
                                        color: Colors.white.withValues(alpha: 0.90),
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        viewModel.mobile.value,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.90),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.email_outlined,
                                        color: Colors.white.withValues(alpha: 0.90),
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        viewModel.email.value,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.90),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Contact Information Card Section matching HTML design (.card.first)
  Widget _buildContactInfoCard(ProfileViewModel viewModel) {
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: lineColor),
            boxShadow: [
              BoxShadow(
                color: inkColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Header (.ch)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 3,
                        height: 12,
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'CONTACT INFORMATION',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.0,
                          color: primaryBlue,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Get.toNamed(RoutesName.edit_profile_view),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: primaryBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Mobile Row (.row)
              Obx(
                () => _buildInfoRow(
                  icon: Icons.phone_outlined,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  label: 'Mobile',
                  value: viewModel.mobile.value,
                  onTap: () => Get.toNamed(RoutesName.edit_profile_view),
                ),
              ),

              Container(
                height: 1,
                margin: const EdgeInsets.only(left: 46),
                color: lineColor,
              ),

              // Email Row (.row)
              Obx(
                () => _buildInfoRow(
                  icon: Icons.email_outlined,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF12B886), Color(0xFF63E6BE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  label: 'Email',
                  value: viewModel.email.value,
                  onTap: () => Get.toNamed(RoutesName.edit_profile_view),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Work Information Card Section matching HTML design (.card)
  Widget _buildWorkInfoCard(ProfileViewModel viewModel) {
    return Transform.translate(
      offset: const Offset(0, -16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: lineColor),
            boxShadow: [
              BoxShadow(
                color: inkColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Header (.ch)
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 12,
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'WORK INFORMATION',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.0,
                      color: primaryBlue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Designation Row (.row)
              Obx(
                () => _buildInfoRow(
                  icon: Icons.badge_outlined,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF818CF8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  label: 'Designation',
                  value: viewModel.designation.value,
                  showChevron: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Information Row Item matching HTML redesign specification
  Widget _buildInfoRow({
    required IconData icon,
    required LinearGradient gradient,
    required String label,
    required String value,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Tile Icon (.tile)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Content (label & value)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: slateColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: inkColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            if (showChevron)
              const Icon(
                Icons.chevron_right_rounded,
                color: slateColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
