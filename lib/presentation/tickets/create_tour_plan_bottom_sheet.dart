import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import 'create_tour_plan_viewmodel.dart';

class CreateTourPlanBottomSheet extends StatelessWidget {
  const CreateTourPlanBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<CreateTourPlanViewModel>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Create Tour Plan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            // Tabs
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _buildTabItem(
                      title: 'Local',
                      isSelected: viewModel.selectedTabIndex.value == 0,
                      onTap: () => viewModel.setTab(0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTabItem(
                      title: 'Outstation',
                      isSelected: viewModel.selectedTabIndex.value == 1,
                      onTap: () => viewModel.setTab(1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Date Selection Row
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => _buildInputField(
                      hint: viewModel.startDateText,
                      icon: Icons.calendar_today_outlined,
                      onTap: () => viewModel.selectStartDate(context),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('—', style: TextStyle(color: Colors.grey)),
                ),
                Expanded(
                  child: Obx(
                    () => _buildInputField(
                      hint: viewModel.endDateText,
                      icon: Icons.calendar_today_outlined,
                      onTap: () => viewModel.selectEndDate(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Travel Purpose
            _buildInputField(
              hint: 'Travel purpose',
              maxLines: 3,
              onChanged: (val) => viewModel.travelPurpose.value = val,
            ),
            const SizedBox(height: 16),

            // Outstation Specific: Places to Visit
            Obx(
              () => viewModel.selectedTabIndex.value == 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Places to Visit',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInputField(
                          hint: 'Tap to select cities...',
                          icon: Icons.keyboard_arrow_down,
                          onTap: () {
                            // Logic for city selection
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            // Create Plan Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => viewModel.createPlan(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sfaBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Create Plan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sfaBlue : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.sfaBlue : Colors.grey.shade300,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    IconData? icon,
    VoidCallback? onTap,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: maxLines > 1
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Expanded(
              child: maxLines == 1
                  ? Text(
                      hint,
                      style: TextStyle(
                        color:
                            hint.contains('date') ||
                                hint.contains('select') ||
                                hint.contains('purpose')
                            ? Colors.grey.shade600
                            : AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    )
                  : TextField(
                      maxLines: maxLines,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 20, color: Colors.grey.shade500),
            ],
          ],
        ),
      ),
    );
  }
}
