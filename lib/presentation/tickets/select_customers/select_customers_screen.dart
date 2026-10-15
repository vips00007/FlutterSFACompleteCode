import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/colors/app_colors.dart';
import '../../../domain/entities/outlet.dart';
import 'select_customers_viewmodel.dart';

class SelectCustomersScreen extends StatelessWidget {
  const SelectCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<SelectCustomersViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Add Customers',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          Obx(() {
            final count = viewModel.selectedCustomers.length;
            if (count == 0) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ElevatedButton(
                onPressed: viewModel.proceedToReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text('Add $count', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            );
          }),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.primaryPurple.withOpacity(0.1), height: 1),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: viewModel.customers.length,
                itemBuilder: (context, index) {
                  final customer = viewModel.customers[index];
                  return Obx(() => _buildCustomerCard(customer, viewModel));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search by name, code, city, type...',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Outlet customer, SelectCustomersViewModel viewModel) {
    final isSelected = viewModel.isSelected(customer);
    
    return GestureDetector(
      onTap: () => viewModel.toggleSelection(customer),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightBlueBackground : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          customer.firstName,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Text(' · ', style: TextStyle(color: AppColors.textSecondary)),
                      const Icon(Icons.phone_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 2),
                      Text(customer.mobileNumber, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${customer.city}, ${customer.state}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(customer.customerType, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryPurple : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primaryPurple : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  isSelected ? Icons.check : Icons.add,
                  color: isSelected ? Colors.white : Colors.grey.shade500,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
