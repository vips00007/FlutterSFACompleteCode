import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import 'visit_plans_viewmodel.dart';

class DailyVisitPlansScreen extends StatelessWidget {
  const DailyVisitPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<VisitPlansViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Daily Visit Plans',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: AppColors.sfaBlue, height: 2),
        ),
      ),
      body: Column(
        children: [
          // 1. Self/Team Toggle
          _buildViewToggle(viewModel),

          // 2. Date Selector
          _buildDateSelector(viewModel),

          // 3. Visit Plans List
          Expanded(
            child: Obx(() {
              if (viewModel.selectedView.value == 'Team') {
                return _buildEmptyState(
                  'No Visit Plans',
                  'No travel plans found for the selected date.',
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: viewModel.visitPlans.length,
                itemBuilder: (context, index) {
                  final plan = viewModel.visitPlans[index];
                  return _buildPlanCard(plan);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle(VisitPlansViewModel viewModel) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Obx(
          () => Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  'Self',
                  viewModel.selectedView.value == 'Self',
                  () => viewModel.changeView('Self'),
                ),
              ),
              Expanded(
                child: _buildToggleButton(
                  'Team',
                  viewModel.selectedView.value == 'Team',
                  () => viewModel.changeView('Team'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.sfaBlue : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(VisitPlansViewModel viewModel) {
    final dates = [
      {'day': 'Wed', 'date': '19'},
      {'day': 'Thu', 'date': '20'},
      {'day': 'Fri', 'date': '21'},
      {'day': 'Sat', 'date': '22'},
      {'day': 'Sun', 'date': '23'},
      {'day': 'Mon', 'date': '24'},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 12),
      height: 80,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: dates.length + 1, // +1 for "All"
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildDateItem('All', '', true, () {});
          }
          final date = dates[index - 1];
          return _buildDateItem(date['day']!, date['date']!, false, () {});
        },
      ),
    );
  }

  Widget _buildDateItem(
    String day,
    String date,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 60,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.sfaBlue : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.sfaBlue : Colors.grey.shade300,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (day == 'All')
            Text(
              'All',
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )
          else ...[
            Text(
              day,
              style: TextStyle(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : Colors.grey,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              date,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlanCard(VisitPlan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    plan.status,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.keyboard_arrow_up,
                      color: AppColors.sfaBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${plan.customers.length} Customers',
                      style: const TextStyle(
                        color: AppColors.sfaBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...plan.customers.map(
                  (customer) => Padding(
                    padding: const EdgeInsets.only(left: 28, bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            customer.role,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          customer.phone,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
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

  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
