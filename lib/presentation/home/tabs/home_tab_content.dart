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
      color: const Color(0xFF8B5CF6),
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
                const Color(0xFF8B5CF6),
                null,
              ),
              _buildQuickActionCard(
                'New Order',
                Icons.inventory_2_outlined,
                const Color(0xFF6D28D9),
                2,
              ),
              _buildQuickActionCard(
                'Collect',
                Icons.attach_money_rounded,
                const Color(0xFF8B5CF6),
                5,
              ),
              _buildQuickActionCard(
                'Reports',
                Icons.description_outlined,
                const Color(0xFF6D28D9),
                null,
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
    int? badge,
  ) {
    return Expanded(
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
                    color: Color(0xFDECE9FA),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Color(0xFF6D28D9), size: 24),
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
    );
  }

  Widget _buildStartDayCard(HomeViewModel viewModel) {
    return Obx(() {
      final status = viewModel.attendanceStatus.value;
      final isLoading = viewModel.isAttendanceLoading.value;

      String title;
      String subtitle;
      String buttonLabel;
      VoidCallback? action;
      bool isCheckIn;

      if (status == 'CHECKED_OUT') {
        title = 'Attendance Completed';
        subtitle = 'You have completed your day';
        buttonLabel = 'Completed';
        action = null;
        isCheckIn = false;
      } else if (status == 'CHECKED_IN' || status == 'MARKED') {
        title = 'Currently on Duty';
        subtitle = 'Mark your day as completed';
        buttonLabel = 'Check Out';
        action = () => Get.toNamed(
          RoutesName.attendance_camera_view,
          arguments: {'isCheckIn': false},
        );
        isCheckIn = false;
      } else {
        title = 'Start Your Day';
        subtitle = 'Check in now to start your visits';
        buttonLabel = 'Start Day';
        action = () => Get.toNamed(
          RoutesName.attendance_camera_view,
          arguments: {'isCheckIn': true},
        );
        isCheckIn = true;
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFF3ECFF), Color(0xFFE6D9FF)],
            stops: [0.0, 0.55, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6D28D9).withValues(alpha: 0.35),
              blurRadius: 24,
              spreadRadius: -6,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: const Color(0xFF6D28D9).withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFA78BFA).withValues(alpha: 0.45),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 6,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFC4B5FD),
                        Color(0xFF7C3AED),
                        Color(0xFF4C1D95),
                      ],
                      stops: [0.0, 0.55, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4C1D95).withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(2, 0),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 54,
                          height: 54,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _rocketAnimationController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale:
                                        0.92 +
                                        (_rocketAnimationController.value *
                                            0.26),
                                    child: Opacity(
                                      opacity:
                                          0.95 -
                                          (_rocketAnimationController.value *
                                              0.4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              const Color(
                                                0xFFA78BFA,
                                              ).withValues(alpha: 0.6),
                                              Colors.transparent,
                                            ],
                                            stops: const [0.0, 0.68],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFC4B5FD),
                                      Color(0xFF7C3AED),
                                      Color(0xFF4C1D95),
                                    ],
                                    stops: [0.0, 0.55, 1.0],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF4C1D95,
                                      ).withValues(alpha: 0.45),
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    isCheckIn
                                        ? Icons.rocket_launch_rounded
                                        : Icons.check_circle_outline_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E1033),
                                  height: 1.25,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B6480),
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: isLoading ? null : action,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFB197FC),
                              Color(0xFF8B5CF6),
                              Color(0xFF6D28D9),
                            ],
                            stops: [0.0, 0.45, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            const BoxShadow(
                              color: Color(0xFF3B1578),
                              offset: Offset(0, 4),
                            ),
                            BoxShadow(
                              color: const Color(
                                0xFF4C1D95,
                              ).withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.access_time_filled,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      buttonLabel,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ), // spacing for the 3D button effect
                  ],
                ),
              ),
            ],
          ),
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
                  color: Color(0xFF8B5CF6),
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
                const Color(0xFF8B5CF6),
              ),
              _buildBusinessCard(
                'Retailer',
                'Secondary Sales',
                '72,500',
                '1,00,000',
                '9 Orders',
                '6 Pending',
                const Color(0xFF8B5CF6),
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
                  color: color.withValues(alpha: 0.1),
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
        color: const Color(0xFFFCF9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3ECFF)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.map_outlined,
                  color: Color(0xFF8B5CF6),
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
                      color: Color(0xFF4C1D95),
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
                          color: Color(0xFF8B5CF6),
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
                              const Color(0xFF4C1D95),
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
                              const Color(0xFF8B5CF6),
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
                      decoration: BoxDecoration(
                        color: const Color(0xFF6D28D9).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.track_changes_outlined,
                        color: Color(0xFF6D28D9),
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
                              color: Color(0xFF4C1D95),
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
                      color: Color(0xFF6366F1),
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
                        Color(0xFF6D28D9),
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
                      const Color(0xFF6D28D9),
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
    // Basic placeholder UI matching the screenshot
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
                  border: Border.all(color: const Color(0xFF8B5CF6)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Unplanned',
                  style: TextStyle(
                    color: Color(0xFF8B5CF6),
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
                  color: const Color(0xFF8B5CF6),
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
              color: const Color(0xFF8B5CF6),
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
                      color: Color(0xFF8B5CF6),
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
                  color: Color(0xFF8B5CF6),
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
                            color: const Color(
                              0xFF8B5CF6,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.business,
                            color: Color(0xFF8B5CF6),
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
                              color: Color(0xFF4C1D95),
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
                      color: Color(0xFF4C1D95),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.3,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF4C1D95),
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
                      const Color(0xFF8B5CF6),
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
                      color: const Color(0xFFF9F5FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Color(0xFF8B5CF6),
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
                      color: const Color(0xFFF9F5FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.bar_chart,
                      color: Color(0xFF8B5CF6),
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
                        Color(0xFF8B5CF6),
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
                          color: Color(0xFF1E1033),
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
                  color: const Color(0xFF8B5CF6),
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
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
          minHeight: 6,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }
}
