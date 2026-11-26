import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/route_names.dart';
import '../home_viewmodel.dart';

class HomeTabContent extends StatefulWidget {
  const HomeTabContent({super.key});

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent>
    with SingleTickerProviderStateMixin {
  // Color Constants matching My Profile Screen (ProfileScreen)
  static const Color primaryBlue = Color(0xFF555ABC);
  static const Color primaryDarkBlue = Color(0xFF17193F);
  static const Color primaryLightBlue = Color(0xFF8B8ED3);
  static const Color softBlueBg = Color(0xFFEFF6FF);
  static const Color lineColor = Color(0xFFDCDBEA);

  late AnimationController _rocketAnimationController;

  @override
  void initState() {
    super.initState();
    _rocketAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rocketAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Get.find<HomeViewModel>();

    return RefreshIndicator(
      onRefresh: viewModel.refreshHome,
      color: primaryBlue,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickActions(),
            _buildStartDayCard(viewModel),
            _buildTodaysBusiness(viewModel),
            _buildTodaysJourney(viewModel),
            _buildTodaysTarget(viewModel),
            _buildUnplannedVisits(viewModel),
            _buildCustomerCoverage(viewModel),
            _buildMyPerformance(viewModel),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Quick Action',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickActionCard(
                'Travel Plan',
                Icons.location_on_outlined,
                primaryBlue,
                null,
              ),
              _buildQuickActionCard(
                'New Order',
                Icons.inventory_2_outlined,
                primaryDarkBlue,
                2,
              ),
              _buildQuickActionCard(
                'Collect',
                Icons.attach_money_rounded,
                primaryBlue,
                5,
              ),
              _buildQuickActionCard(
                'Reports',
                Icons.description_outlined,
                primaryDarkBlue,
                null,
                onTap: () => Get.toNamed(RoutesName.reports_view),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    int? badge, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: softBlueBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: primaryBlue, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              if (badge != null)
                Positioned(
                  top: -8,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartDayCard(HomeViewModel viewModel) {
    return Obx(() {
      final status = viewModel.attendanceStatus.value;
      final isLoading = viewModel.isAttendanceLoading.value;

      String title;
      String timeText = '';
      String subtitle;
      String buttonLabel;
      VoidCallback? action;
      bool isCheckIn;

      if (status == 'CHECKED_OUT') {
        title = 'Checked Out';
        subtitle = 'Day completed';
        buttonLabel = 'Completed';
        action = null;
        isCheckIn = false;
      } else if (status == 'CHECKED_IN' || status == 'MARKED') {
        title = 'Checked In';
        timeText = '09:12 AM'; // Placeholder
        subtitle = 'Working Hours 4h 32m'; // Placeholder
        buttonLabel = 'End Day';
        action = () => Get.toNamed(
          RoutesName.attendance_camera_view,
          arguments: {'isCheckIn': false},
        );
        isCheckIn = false;
      } else {
        title = 'Not Started';
        subtitle = 'Start working hours';
        buttonLabel = 'Start Day';
        action = () => Get.toNamed(
          RoutesName.attendance_camera_view,
          arguments: {'isCheckIn': true},
        );
        isCheckIn = true;
      }

      final isCompleted = status == 'CHECKED_OUT';
      final isStarted = status == 'CHECKED_IN' || status == 'MARKED';

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: isStarted || isCompleted
                          ? const Color(0xFF00C853)
                          : Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.w800,
                                fontSize: 13.5,
                              ),
                            ),
                            if (timeText.isNotEmpty)
                              Text(
                                timeText,
                                style: const TextStyle(
                                  color: primaryBlue,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: Colors.grey, size: 13),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                subtitle,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
            const SizedBox(width: 10),
            InkWell(
              onTap: isLoading ? null : action,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.grey.shade300
                      : (isCheckIn ? primaryBlue : const Color(0xFFDC2626)),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isCompleted
                      ? null
                      : [
                          BoxShadow(
                            color: (isCheckIn ? primaryBlue : const Color(0xFFDC2626))
                                .withValues(alpha: 0.22),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isCompleted) ...[
                            Icon(
                              isCheckIn ? Icons.play_arrow_rounded : Icons.logout_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            buttonLabel,
                            style: TextStyle(
                              color: isCompleted ? Colors.grey.shade700 : Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTodaysBusiness(HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Today's Business",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              Text(
                'View all >',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 185,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildBusinessCard(
                'Distributor',
                'Primary Sales',
                viewModel.revenue.value,
                '1,50,000',
                '3 Orders',
                '2 Pending',
                primaryBlue,
              ),
              _buildBusinessCard(
                'Retailer',
                'Secondary Sales',
                '72,500',
                '1,00,000',
                '9 Orders',
                '6 Pending',
                primaryBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessCard(
    String title,
    String subtitle,
    String amount,
    String target,
    String orders,
    String pending,
    Color color,
  ) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: softBlueBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.store_mall_directory_outlined,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black45, size: 20),
            ],
          ),
          const Spacer(),
          Text(
            '₹$amount',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: [
              Text(
                orders,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                pending,
                style: const TextStyle(fontSize: 11, color: Colors.black45),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 6),
          Text(
            'Target ₹$target',
            style: const TextStyle(fontSize: 10, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysJourney(HomeViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F3F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lineColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: softBlueBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.map_outlined,
                  color: primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Today's Journey",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: primaryDarkBlue,
                    ),
                  ),
                  Text(
                    "Track & Plan Route",
                    style: TextStyle(fontSize: 10, color: Colors.black45),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Start now',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _buildJourneyMetric(
                              'Plan',
                              '50',
                              primaryDarkBlue,
                            ),
                          ),
                          Expanded(
                            child: _buildJourneyMetric(
                              'Done',
                              '33',
                              Colors.green,
                            ),
                          ),
                          Expanded(
                            child: _buildJourneyMetric(
                              'Prod',
                              '20',
                              primaryBlue,
                            ),
                          ),
                          Expanded(
                            child: _buildJourneyMetric(
                              'Unpl',
                              '04',
                              Colors.orange,
                            ),
                          ),
                          Expanded(
                            child: _buildJourneyMetric(
                              'Miss',
                              '02',
                              Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'NEXT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'MSA Auto Parts',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Near MP Nagar',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                '2.3 KM',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'ETA 8 min',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.location_on, color: Colors.red, size: 20),
                          Text('Map View', style: TextStyle(fontSize: 9)),
                        ],
                      ),
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

  Widget _buildJourneyMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Colors.black54),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysTarget(HomeViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: softBlueBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.track_changes_outlined,
                        color: primaryBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Today's Target",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: primaryDarkBlue,
                            ),
                          ),
                          Text(
                            "Track progress. Stay consistent.",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: primaryBlue,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Pick Date',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        primaryBlue,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        '75%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'ACHIEVED',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTargetRow(
                      'TARGET',
                      '2,80,000',
                      primaryBlue,
                      '+2.1%',
                    ),
                    const SizedBox(height: 8),
                    _buildTargetRow(
                      'ACHIEVED',
                      '80,000',
                      Colors.green,
                      '+3.7%',
                    ),
                    const SizedBox(height: 8),
                    _buildTargetRow('REMAINING', '28,000', Colors.red, '-4.1%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetRow(
    String label,
    String amount,
    Color color,
    String percent,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              percent,
              style: TextStyle(
                fontSize: 10,
                color: color == Colors.red ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '₹$amount',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUnplannedVisits(HomeViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD4E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Unplanned Visits",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Track and convert unexpected client stops",
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: primaryBlue),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Unplanned',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildUnplannedMetric('3', 'Dist.', Icons.business),
              ),
              Expanded(
                child: _buildUnplannedMetric('5', 'Retail', Icons.store),
              ),
              Expanded(child: _buildUnplannedMetric('1', 'Mech.', Icons.build)),
              Expanded(
                child: _buildUnplannedMetric(
                  '5',
                  'Prod.',
                  Icons.track_changes,
                  color: primaryBlue,
                ),
              ),
              Expanded(
                child: _buildUnplannedMetric('4', 'Orders', Icons.shopping_bag),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primaryDarkBlue, primaryBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.currency_rupee,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'UNPLANNED REVENUE',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹68,000 Generated',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Details >',
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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

  Widget _buildUnplannedMetric(
    String value,
    String label,
    IconData icon, {
    Color color = Colors.black54,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color == Colors.black54 ? Colors.black87 : color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCustomerCoverage(HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Customer Coverage',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              Text(
                'Details >',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: softBlueBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.business,
                            color: primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Distributor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: primaryDarkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '30% Coverage',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: primaryDarkBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.3,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  primaryDarkBlue,
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildJourneyMetric('Planned', '5', Colors.black54),
                  ),
                  Expanded(
                    child: _buildJourneyMetric('Visited', '3', Colors.green),
                  ),
                  Expanded(
                    child: _buildJourneyMetric(
                      'Prod',
                      '3',
                      primaryBlue,
                    ),
                  ),
                  Expanded(
                    child: _buildJourneyMetric('Unpl', '0', Colors.orange),
                  ),
                  Expanded(
                    child: _buildJourneyMetric('Missed', '1', Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMyPerformance(HomeViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'MY PERFORMANCE',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: softBlueBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: primaryBlue,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Rank',
                        style: TextStyle(fontSize: 9, color: Colors.black54),
                      ),
                      Text(
                        '#3',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: softBlueBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.bar_chart,
                      color: primaryBlue,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '6%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      Text(
                        'Growth vs Last\nMonth',
                        style: TextStyle(fontSize: 8, color: Colors.black54, height: 1.15),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: CircularProgressIndicator(
                      value: 0.86,
                      strokeWidth: 10,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        primaryBlue,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '86',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: primaryDarkBlue,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 1,
                        color: Colors.grey.shade300,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      const Text(
                        '/100',
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  children: [
                    _buildPerformanceBar('Sales', 0.92, '92%', Icons.domain),
                    const SizedBox(height: 12),
                    _buildPerformanceBar('Coverage', 0.88, '88%', Icons.check_circle),
                    const SizedBox(height: 12),
                    _buildPerformanceBar('Productivity', 0.81, '81%', Icons.pie_chart),
                    const SizedBox(height: 12),
                    _buildPerformanceBar('Collection', 0.90, '90%', Icons.account_balance_wallet),
                    const SizedBox(height: 12),
                    _buildPerformanceBar('New Business', 0.78, '78%', Icons.trending_up),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceBar(String label, double value, String percent, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: primaryBlue,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12, 
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              percent,
              style: const TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey.shade100,
          valueColor: const AlwaysStoppedAnimation<Color>(primaryBlue),
          minHeight: 6,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }
}
