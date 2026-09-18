import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/colors/app_colors.dart';
import '../home_viewmodel.dart';

class LoyaltyTabContent extends StatelessWidget {
  const LoyaltyTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Get.find<HomeViewModel>();

    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Time Selector
            _buildTimeSelector(viewModel),

            const SizedBox(height: 20),

            // 2. Coupons Section
            Text(
              'COUPONS • ${viewModel.selectedPeriod.value.toUpperCase()}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            _buildCouponsCard(viewModel),

            const SizedBox(height: 20),

            // 3. Invoices Section
            Text(
              'INVOICES • ${viewModel.selectedPeriod.value.toUpperCase()}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            _buildInvoicesCard(viewModel),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTimeChip(
              'Today',
              viewModel.selectedPeriod.value == 'Today',
              () => viewModel.changePeriod('Today'),
            ),
          ),
          Expanded(
            child: _buildTimeChip(
              'Week',
              viewModel.selectedPeriod.value == 'Week',
              () => viewModel.changePeriod('Week'),
            ),
          ),
          Expanded(
            child: _buildTimeChip(
              'Month',
              viewModel.selectedPeriod.value == 'Month',
              () => viewModel.changePeriod('Month'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sfaBlue : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCouponsCard(HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sfaBlue.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              color: AppColors.sfaBlue,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          _buildStatColumn('SCANNED', viewModel.scannedCoupons.value),
          const Spacer(),
          _buildStatColumn(
            'POINTS',
            viewModel.loyaltyPoints.value,
            valueColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicesCard(HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long,
              color: Colors.orange,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildStatColumn(
                    'INVOICES',
                    viewModel.invoiceCount.value,
                  ),
                ),
                Expanded(
                  child: _buildStatColumn('QTY', viewModel.invoiceQty.value),
                ),
                Expanded(
                  child: _buildStatColumn(
                    'VALUE',
                    viewModel.invoiceValue.value,
                  ),
                ),
                Expanded(
                  child: _buildStatColumn(
                    'POINTS',
                    viewModel.loyaltyPoints.value,
                    valueColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.sfaBlue,
          ),
        ),
      ],
    );
  }
}
