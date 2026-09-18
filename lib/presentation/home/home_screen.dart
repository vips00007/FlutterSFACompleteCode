import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import 'home_viewmodel.dart';
import 'tabs/home_tab_content.dart';
import 'tabs/team_tab.dart';
import 'tabs/orders_tab.dart';
import 'tabs/beat_tab.dart';
import 'tabs/loyalty_tab.dart';
import 'tabs/events_tab.dart';
import 'tabs/targets_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Get.find<HomeViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header Section
            _buildHeader(viewModel),

            const SizedBox(height: 8),

            // 2. Horizontal Navigation Tabs (Pill Tabs)
            _buildHorizontalTabs(viewModel),

            // 3. Main Content Area
            Expanded(
              child: Obx(() {
                switch (viewModel.selectedTopTabIndex.value) {
                  case 0:
                    return const HomeTabContent();
                  case 1:
                    return const OrdersTabContent();
                  case 2:
                    return const TeamTabContent();
                  case 3:
                    return const BeatTabContent();
                  case 4:
                    return const LoyaltyTabContent();
                  case 5:
                    return const EventsTabContent();
                  case 6:
                    return const TargetsTabContent();
                  default:
                    return const HomeTabContent();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.sfaBlue,
            child: Obx(
              () => Text(
                viewModel.userName.value.isNotEmpty
                    ? viewModel.userName.value[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    'Welcome, ${viewModel.userName.value}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Obx(
                        () => Text(
                          viewModel.role.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => Text(
                        viewModel.currentDate.value,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.sfaBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: AppColors.textPrimary,
              size: 26,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
          // Logo resized slightly larger
          Image.asset(
            'assets/images/logo.png',
            width: 44,
            height: 44,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalTabs(HomeViewModel viewModel) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(
          () => Row(
            children: [
              _buildPillTab(0, 'Home', Icons.home_rounded, viewModel),
              const SizedBox(width: 10),
              _buildPillTab(2, 'Team', Icons.groups_rounded, viewModel),
              const SizedBox(width: 10),
              _buildPillTab(1, 'Orders', Icons.shopping_bag_rounded, viewModel),
              const SizedBox(width: 10),
              _buildPillTab(3, 'Beat', Icons.route_rounded, viewModel),
              const SizedBox(width: 10),
              _buildPillTab(
                4,
                'Loyalty',
                Icons.card_giftcard_rounded,
                viewModel,
              ),
              const SizedBox(width: 10),
              _buildPillTab(5, 'Events', Icons.event_rounded, viewModel),
              const SizedBox(width: 10),
              _buildPillTab(
                6,
                'Targets',
                Icons.track_changes_rounded,
                viewModel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillTab(
    int index,
    String label,
    IconData icon,
    HomeViewModel viewModel,
  ) {
    final bool isSelected = viewModel.selectedTopTabIndex.value == index;
    return GestureDetector(
      onTap: () => viewModel.changeTopTabIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sfaBlue : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.sfaBlue : Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.sfaBlue.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
