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
          bottomNavigationBar: Container(
            height: 85,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  viewModel: viewModel,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.add,
                  activeIcon: Icons.add,
                  label: 'Add Outlet',
                  viewModel: viewModel,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.calendar_month_outlined,
                  activeIcon: Icons.calendar_month,
                  label: 'Visits',
                  viewModel: viewModel,
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.menu,
                  activeIcon: Icons.menu,
                  label: 'Menu',
                  viewModel: viewModel,
                ),
              ],
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.sfaBlue : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.sfaBlue.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? Colors.white : Colors.grey.shade400,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.sfaBlue : Colors.grey.shade500,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
