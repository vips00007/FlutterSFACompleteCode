import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/route_names.dart';
import 'favorites_viewmodel.dart';

/// Compact, blue-themed More Options page matching Add Outlet / My Profile screen standards.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  // Color Constants matching Add Outlet & My Profile Screen (HtmlColors)
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
    final viewModel = Get.find<FavoritesViewModel>();

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Compact Blue Hero Header Section
            _buildHeroHeader(context, viewModel),

            // 2. Compact Stats Section
            _buildStatsSection(viewModel),

            // 3. Compact Info Cards Section (Region & Employee ID)
            _buildInfoCardsSection(viewModel),

            // 4. Menu Categories
            _buildCategoryHeader('ATTENDANCE & LEAVE'),
            _buildGroupCard([
              _buildRowItem(
                icon: Icons.fingerprint_rounded,
                title: 'Attendance',
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF60A5FA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => Get.toNamed(RoutesName.attendance_calendar_view),
              ),
              _buildRowItem(
                icon: Icons.beach_access_outlined,
                title: 'Leave Management',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF7A59), Color(0xFFFFB36B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => Get.toNamed(RoutesName.leave_management_view),
              ),
            ]),

            _buildCategoryHeader('PLANNING & VISITS'),
            _buildGroupCard([
              _buildRowItem(
                icon: Icons.alt_route_rounded,
                title: 'Daily Visit Plans',
                gradient: const LinearGradient(
                  colors: [Color(0xFF12B886), Color(0xFF63E6BE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => Get.toNamed(RoutesName.daily_visit_plans_view),
              ),
              _buildRowItem(
                icon: Icons.calendar_month_outlined,
                title: 'Monthly Journey Plan',
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => Get.toNamed(RoutesName.monthly_journey_plan_view),
              ),
              _buildRowItem(
                icon: Icons.history_rounded,
                title: 'Visit History',
                gradient: const LinearGradient(
                  colors: [Color(0xFFE64980), Color(0xFFFF8FB1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => Get.toNamed(RoutesName.visit_history_view),
              ),
            ]),

            _buildCategoryHeader('EVENTS & MEETINGS'),
            _buildGroupCard([
              _buildRowItem(
                icon: Icons.groups_outlined,
                title: 'Meeting or Exhibition',
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59F00), Color(0xFFFFD24A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => Get.toNamed(RoutesName.event_planner_view),
              ),
            ]),

            _buildCategoryHeader('PRODUCTS & CATALOG'),
            _buildGroupCard([
              _buildRowItem(
                icon: Icons.inventory_2_outlined,
                title: 'Product Catalog',
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF818CF8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => Get.toNamed(RoutesName.product_catalogue_view),
              ),
            ]),

            _buildCategoryHeader('PERFORMANCE'),
            _buildGroupCard([
              _buildRowItem(
                icon: Icons.auto_graph_rounded,
                title: 'My Performance',
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF6EE7B7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => Get.toNamed(RoutesName.my_performance_view),
              ),
            ]),

            _buildCategoryHeader('FINANCE'),
            _buildGroupCard([
              _buildRowItem(
                icon: Icons.receipt_long_outlined,
                title: 'Expense / Claim',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF7A59), Color(0xFFFFB36B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => Get.toNamed(RoutesName.expense_claim_view),
              ),
            ]),

            _buildCategoryHeader('SUPPORT'),
            _buildGroupCard([
              _buildRowItem(
                icon: Icons.headset_mic_outlined,
                title: 'Help & Support',
                gradient: const LinearGradient(
                  colors: [Color(0xFF0891B2), Color(0xFF67E8F9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => Get.toNamed(RoutesName.help_support_view),
              ),
            ]),

            const SizedBox(height: 16),

            // 5. Compact Blue Outlined Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: InkWell(
                onTap: () => viewModel.logout(),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryBlue, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: primaryBlue,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: primaryBlue,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 6. App Version
            Obx(
              () => Text(
                'App Version ${viewModel.appVersion.value}',
                style: const TextStyle(
                  color: slateColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 1. Compact Blue Hero Header matching Add Outlet theme
  Widget _buildHeroHeader(BuildContext context, FavoritesViewModel viewModel) {
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
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MORE · MY WORKSPACE',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.90),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    // Notification Bell Container
                    Container(
                      width: 36,
                      height: 36,
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
                            top: 8,
                            right: 9,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD166),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: primaryBlue,
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Compact Profile Row
                InkWell(
                  onTap: () => Get.toNamed(RoutesName.profile_view),
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

                      // Profile Info
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

                            // Contact Row
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
                                        viewModel.phone.value,
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

  // 2. Compact Stats Section Overlapping Hero
  Widget _buildStatsSection(FavoritesViewModel viewModel) {
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: lineColor),
            boxShadow: [
              BoxShadow(
                color: inkColor.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: _buildStatColumn(
                  'Visits Today',
                  viewModel.visitsToday,
                  const Color(0xFF16A34A),
                ),
              ),
              _buildStatDivider(),
              Expanded(
                child: _buildStatColumn(
                  'Orders MTD',
                  viewModel.ordersMTD,
                  primaryBlue,
                ),
              ),
              _buildStatDivider(),
              Expanded(
                child: _buildStatColumn(
                  'Achievement',
                  viewModel.achievement,
                  const Color(0xFFD97706),
                ),
              ),
              _buildStatDivider(),
              Expanded(
                child: _buildStatColumn(
                  'Outlets',
                  viewModel.outlets,
                  const Color(0xFF0284C7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, RxString value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => Text(
            value.value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: slateColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 26,
      color: lineColor,
    );
  }

  // 3. Compact Info Cards Section
  Widget _buildInfoCardsSection(FavoritesViewModel viewModel) {
    return Transform.translate(
      offset: const Offset(0, -18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.location_on_outlined,
                label: 'Region',
                value: viewModel.region,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.badge_outlined,
                label: 'Employee ID',
                value: viewModel.employeeId,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required RxString value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: lineColor),
        boxShadow: [
          BoxShadow(
            color: inkColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: primaryBlue,
              size: 17,
            ),
          ),
          const SizedBox(width: 8),
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
                Obx(
                  () => Text(
                    value.value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: inkColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 4. Category Section Header matching Add Outlet subsection standards
  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1.0,
              color: primaryBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: lineColor,
            ),
          ),
        ],
      ),
    );
  }

  // 5. Compact Group Container Card
  Widget _buildGroupCard(List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: lineColor),
          boxShadow: [
            BoxShadow(
              color: inkColor.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(items.length * 2 - 1, (index) {
              if (index.isEven) {
                return items[index ~/ 2];
              } else {
                return Container(
                  height: 1,
                  margin: const EdgeInsets.only(left: 58),
                  color: lineColor,
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  // 6. Compact Group Row Item
  Widget _buildRowItem({
    required IconData icon,
    required String title,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: [
            // Icon Tile
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

            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: inkColor,
                ),
              ),
            ),

            // Chevron
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
