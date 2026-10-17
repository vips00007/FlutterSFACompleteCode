import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import '../../routes/route_names.dart';
import 'favorites_viewmodel.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<FavoritesViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Blue Header Section
            _buildHeader(viewModel),

            // 2. Stats and Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildStatsCard(viewModel),
                  const SizedBox(height: 8),
                  _buildDetailRow(viewModel),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // 3. Menu Categories
            _buildMenuSection(
              title: 'ATTENDANCE & LEAVE',
              items: [
                _buildMenuItem(
                  Icons.fingerprint,
                  'Attendance',
                  const Color(0xFFF3E8FF),
                  const Color(0xFF8A2BE2),
                  onTap: () => Get.toNamed(RoutesName.attendance_list_view),
                ),
                _buildMenuItem(
                  Icons.beach_access_outlined,
                  'Leave Management',
                  const Color(0xFFF3E8FF),
                  const Color(0xFF8A2BE2),
                  onTap: () => Get.toNamed(RoutesName.leave_management_view),
                ),
              ],
            ),

            _buildMenuSection(
              title: 'PLANNING & VISITS',
              items: [
                _buildMenuItem(
                  Icons.route_outlined,
                  'Daily Visit Plans',
                  const Color(0xFFF3E8FF),
                  const Color(0xFF8A2BE2),
                  onTap: () => Get.toNamed(RoutesName.daily_visit_plans_view),
                ),
                _buildMenuItem(
                  Icons.calendar_month_outlined,
                  'Monthly Journey Plan',
                  const Color(0xFFF3E8FF),
                  const Color(0xFF8A2BE2),
                  onTap: () =>
                      Get.toNamed(RoutesName.monthly_journey_plan_view),
                ),
                _buildMenuItem(
                  Icons.history,
                  'Visit History',
                  const Color(0xFFF3E8FF),
                  const Color(0xFF8A2BE2),
                  onTap: () => Get.toNamed(RoutesName.visit_history_view),
                ),
              ],
            ),

            _buildMenuSection(
              title: 'EVENTS & MEETINGS',
              items: [
                _buildMenuItem(
                  Icons.groups_outlined,
                  'Meeting or Exhibition',
                  const Color(0xFFF3E8FF),
                  const Color(0xFF8A2BE2),
                  onTap: () => Get.toNamed(RoutesName.event_planner_view),
                ),
              ],
            ),

            _buildMenuSection(
              title: 'PRODUCTS & CATALOG',
              items: [
                _buildMenuItem(
                  Icons.inventory_2_outlined,
                  'Product Catalog',
                  const Color(0xFFF3E8FF),
                  const Color(0xFF8A2BE2),
                  onTap: () => Get.toNamed(RoutesName.product_catalogue_view),
                ),
              ],
            ),

            _buildMenuSection(
              title: 'PERFORMANCE',
              items: [
                _buildMenuItem(
                  Icons.auto_graph,
                  'My Performance',
                  const Color(0xFFF3E8FF),
                  const Color(0xFF8A2BE2),
                  onTap: () => Get.toNamed(RoutesName.my_performance_view),
                ),
              ],
            ),

            _buildMenuSection(
              title: 'FINANCE',
              items: [
                _buildMenuItem(
                  Icons.receipt_long_outlined,
                  'Expense / Claim',
                  const Color(0xFFF3E8FF),
                  const Color(0xFF8A2BE2),
                  onTap: () => Get.toNamed(RoutesName.expense_claim_view),
                ),
              ],
            ),

            _buildMenuSection(
              title: 'SUPPORT',
              items: [
                _buildMenuItem(
                  Icons.headset_mic_outlined,
                  'Help & Support',
                  const Color(0xFFF3E8FF),
                  const Color(0xFF8A2BE2),
                  onTap: () => Get.toNamed(RoutesName.help_support_view),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 4. Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () => viewModel.logout(),
                icon: const Icon(Icons.logout, size: 20),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF8A2BE2),
                  side: const BorderSide(color: Color(0xFF8A2BE2), width: 1.5),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 5. App Version
            Obx(
              () => Text(
                'App Version ${viewModel.appVersion.value}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(FavoritesViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 45, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6D28D9), Color(0xFF8A2BE2), Color(0xFFB197FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Arrow / Navigation
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => Get.toNamed(RoutesName.profile_view),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          viewModel.userName.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: Colors.white70,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Obx(
                              () => Text(
                                viewModel.role.value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone_outlined,
                            color: Colors.white70,
                            size: 12,
                          ),
                          const SizedBox(width: 6),
                          Obx(
                            () => Text(
                              viewModel.phone.value,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.email_outlined,
                            color: Colors.white70,
                            size: 12,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Obx(
                              () => Text(
                                viewModel.email.value,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
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
    );
  }

  Widget _buildStatsCard(FavoritesViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Visits Today', viewModel.visitsToday, Colors.green),
          _buildDivider(),
          _buildStatItem('Orders MTD', viewModel.ordersMTD, const Color(0xFF8A2BE2)),
          _buildDivider(),
          _buildStatItem('Achievement', viewModel.achievement, Colors.orange),
          _buildDivider(),
          _buildStatItem('Outlets', viewModel.outlets, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, RxString value, Color color) {
    return Column(
      children: [
        Obx(
          () => Text(
            value.value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 24, width: 1, color: Colors.grey.shade200);
  }

  Widget _buildDetailRow(FavoritesViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            Icons.location_on_outlined,
            'Region',
            viewModel.region,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildInfoCard(
            Icons.business_center_outlined,
            'Employee ID',
            viewModel.employeeId,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, RxString value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                const SizedBox(height: 1),
                Obx(
                  () => Text(
                    value.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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

  Widget _buildMenuSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6D28D9),
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, indent: 52, color: Colors.grey.shade50),
            itemBuilder: (context, index) => items[index],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    Color bgColor,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      dense: false,
      visualDensity: VisualDensity.standard,

      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),

      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),

      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 18),

      onTap: onTap,
    );
  }
}
