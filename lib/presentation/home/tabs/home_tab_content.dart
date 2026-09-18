import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/colors/app_colors.dart';
import '../../../routes/route_names.dart';
import '../home_viewmodel.dart';

class HomeTabContent extends StatelessWidget {
  const HomeTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Get.find<HomeViewModel>();

    return RefreshIndicator(
      onRefresh: viewModel.refreshHome,
      color: AppColors.sfaBlue,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Start Your Day Card
            _buildStartDayCard(viewModel),

            // 2. Revenue Section
            _buildRevenueSection(viewModel),

            // 3. Summary Metrics Cards
            _buildSummaryCards(viewModel),

            // 4. Today At A Glance
            _buildAtAGlance(viewModel),

            // 5. Upcoming Events
            _buildUpcomingEvents(),

            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildStartDayCard(HomeViewModel viewModel) {
    return Obx(() {
      final status = viewModel.attendanceStatus.value;
      final isLoading = viewModel.isAttendanceLoading.value;

      if (status == 'CHECKED_OUT') {
        return _buildStatusCard(
          'Attendance Completed',
          'You have completed your day',
          Icons.check_circle,
          Colors.green,
          null,
          isLoading,
        );
      }

      if (status == 'CHECKED_IN' || status == 'MARKED') {
        return _buildStatusCard(
          'Checked In',
          'Currently on duty',
          Icons.timer,
          AppColors.sfaBlue,
          () => Get.toNamed(
            RoutesName.attendance_camera_view,
            arguments: {'isCheckIn': false},
          ),
          isLoading,
          buttonLabel: 'Check Out',
        );
      }

      return _buildStatusCard(
        'Start Your Day',
        'Mark attendance to begin visits',
        Icons.wb_sunny_outlined,
        Colors.orange,
        () => Get.toNamed(
          RoutesName.attendance_camera_view,
          arguments: {'isCheckIn': true},
        ),
        isLoading,
        buttonLabel: 'Start Day',
      );
    });
  }

  Widget _buildStatusCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback? onButtonPressed,
    bool isLoading, {
    String? buttonLabel,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: color, width: 4),
          right: BorderSide(color: color, width: 0.5),
          top: BorderSide(color: color, width: 0.5),
          bottom: BorderSide(color: color, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
              if (isLoading)
                const Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
            ],
          ),
          if (buttonLabel != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isLoading ? null : onButtonPressed,
              icon: const Icon(Icons.access_time, size: 18),
              label: Text(
                buttonLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color == Colors.orange ? AppColors.sfaBlue : color,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCards(HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          _buildSummaryCard(
            'Visits',
            viewModel.visitsCount,
            Icons.location_on_outlined,
            AppColors.metricBlue,
            AppColors.metricBlueBg,
          ),
          _buildSummaryCard(
            'Ordered',
            viewModel.orderedCount,
            Icons.shopping_bag_outlined,
            AppColors.metricGreen,
            AppColors.metricGreenBg,
          ),
          _buildSummaryCard(
            'New Cust.',
            viewModel.newCustCount,
            Icons.person_add_outlined,
            const Color(0xFF1E293B), // Dark color for New Cust value
            AppColors.metricTealBg,
          ),
          _buildSummaryCard(
            'KM',
            viewModel.distanceKM,
            Icons.directions_car_outlined,
            AppColors.sfaBlue,
            const Color(0xFFF3E8FF), // Light purple bg for car
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    RxString value,
    IconData icon,
    Color color,
    Color bgColor,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color == const Color(0xFF1E293B)
                    ? AppColors.metricTeal
                    : color,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Text(
                value.value,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueSection(HomeViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.sfaBlue, AppColors.sfaBlue.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.sfaBlue.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              'REVENUE • ${viewModel.selectedPeriod.value.toUpperCase()} PROGRESS',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      '₹${viewModel.revenue.value}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Obx(
                        () => Text(
                          'of ₹${viewModel.targetRevenue.value}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 10,
                            ),
                            Text(
                              ' 64%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: CircularProgressIndicator(
                      value: 0.1,
                      strokeWidth: 5,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        '0%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        '100%',
                        style: TextStyle(color: Colors.white70, fontSize: 7),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  '₹${viewModel.revenue.value.replaceAll(',', '')} done',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              const Text(
                'Gap ₹0',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAtAGlance(HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            'TODAY AT A GLANCE',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: _buildGlanceCard(
                  'Present',
                  viewModel.presentStatus,
                  'All in',
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildGlanceCard(
                  'Audits',
                  viewModel.auditsCount,
                  '3 tickets',
                  Colors.red,
                ),
              ),
              Expanded(
                child: _buildGlanceCard(
                  'Beat Plan',
                  viewModel.beatPlanProgress,
                  '0/0',
                  Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlanceCard(
    String title,
    RxString value,
    String subValue,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Obx(
            () => Text(
              value.value.split(' ')[0],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(subValue, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            'UPCOMING EVENTS',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'No events today or tomorrow',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Scheduled events for the next 24h show here',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
