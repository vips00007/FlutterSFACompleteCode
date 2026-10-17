import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import '../home/home_screen.dart';
import '../explore/explore_screen.dart';
import '../tickets/tickets_screen.dart';
import '../favorites/favorites_screen.dart';
import 'dashboard_viewmodel.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardViewModel viewModel = Get.find<DashboardViewModel>();

    return Obx(
      () => PopScope(
        canPop: viewModel.selectedIndex == 0,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (!didPop) {
            viewModel.changeTabIndex(0);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: viewModel.selectedIndex,
            children: const [
              HomeScreen(),
              AddOutletScreen(),
              TicketsScreen(),
              FavoritesScreen(),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 70,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.grid_view_rounded,
                    activeIcon: Icons.grid_view_rounded,
                    label: 'Home',
                    viewModel: viewModel,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.add_business_outlined,
                    activeIcon: Icons.add_business,
                    label: 'Add Outlet',
                    viewModel: viewModel,
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag,
                    label: 'Visit',
                    viewModel: viewModel,
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.more_horiz,
                    activeIcon: Icons.more_horiz,
                    label: 'More',
                    viewModel: viewModel,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required DashboardViewModel viewModel,
  }) {
    final isSelected = viewModel.selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => viewModel.changeTabIndex(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? const Color(0xFF8A2BE2)
                  : Colors.grey.shade500,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF8A2BE2)
                    : Colors.grey.shade500,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
