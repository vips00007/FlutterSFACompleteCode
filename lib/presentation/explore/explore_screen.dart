import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import '../dashboard/dashboard_viewmodel.dart';
import 'add_outlet_viewmodel.dart';

class AddOutletScreen extends StatelessWidget {
  const AddOutletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<AddOutletViewModel>();
    final dashboardViewModel = Get.find<DashboardViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => dashboardViewModel.changeTabIndex(0),
        ),
        title: const Text(
          'Add New Outlet',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.sfaBlue, height: 2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Outlet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Fill in the details to register a new customer outlet',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            // 1. Classification
            _buildSectionCard(
              icon: Icons.list_alt,
              title: 'Classification',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Customer Type'),
                  const SizedBox(height: 4),
                  Obx(
                    () => _buildDropdown(
                      value: viewModel.customerType.value.isEmpty
                          ? null
                          : viewModel.customerType.value,
                      hint: 'Select customer type',
                      items: viewModel.customerTypes,
                      onChanged: (val) => viewModel.customerType.value = val!,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. Personal Details
            _buildSectionCard(
              icon: Icons.person_outline,
              title: 'Personal Details',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('First Name'),
                            const SizedBox(height: 4),
                            _buildTextField(
                              viewModel.firstNameController,
                              'Enter first na...',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Last Name'),
                            const SizedBox(height: 4),
                            _buildTextField(
                              viewModel.lastNameController,
                              'Enter last na...',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel('Firm / Party Name'),
                      Row(
                        children: [
                          Obx(
                            () => SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: viewModel.isSameAsName.value,
                                onChanged: viewModel.toggleSameAsName,
                                activeColor: AppColors.sfaBlue,
                              ),
                            ),
                          ),
                          const Text(
                            'Same as name',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildTextField(
                    viewModel.firmNameController,
                    'Enter firm name',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Mobile Number'),
                            const SizedBox(height: 4),
                            _buildTextField(
                              viewModel.mobileController,
                              '10-digit mobi...',
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Email'),
                            const SizedBox(height: 4),
                            _buildTextField(
                              viewModel.emailController,
                              'Email address',
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 3. Location
            _buildSectionCard(
              icon: Icons.location_on_outlined,
              title: 'Location',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildLocationButton(
                          Icons.my_location,
                          'Current\nLocation',
                          true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildLocationButton(
                          Icons.map_outlined,
                          'Search on Map',
                          false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Address'),
                  const SizedBox(height: 4),
                  _buildTextField(
                    viewModel.addressController,
                    'Street address, area, landmark...',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('State'),
                            const SizedBox(height: 4),
                            Obx(
                              () => _buildDropdown(
                                value: viewModel.state.value.isEmpty
                                    ? null
                                    : viewModel.state.value,
                                hint: 'Select state',
                                items: viewModel.states,
                                onChanged: (val) =>
                                    viewModel.state.value = val!,
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
                            _buildLabel('District'),
                            const SizedBox(height: 4),
                            Obx(
                              () => _buildDropdown(
                                value: viewModel.district.value.isEmpty
                                    ? null
                                    : viewModel.district.value,
                                hint: 'Select distri...',
                                items: viewModel.districts,
                                onChanged: (val) =>
                                    viewModel.district.value = val!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('City'),
                            const SizedBox(height: 4),
                            Obx(
                              () => _buildDropdown(
                                value: viewModel.city.value.isEmpty
                                    ? null
                                    : viewModel.city.value,
                                hint: 'Select city',
                                items: viewModel.cities,
                                onChanged: (val) => viewModel.city.value = val!,
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
                            _buildLabel('Pin Code'),
                            const SizedBox(height: 4),
                            _buildTextField(
                              viewModel.pinCodeController,
                              '6-digit code',
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 4. Attachments
            _buildSectionCard(
              icon: Icons.attach_file,
              title: 'Attachments',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Photos / Documents'),
                  const SizedBox(height: 12),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.fieldBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 45,
              child: Obx(
                () => ElevatedButton(
                  onPressed: viewModel.isLoading.value
                      ? null
                      : viewModel.saveOutlet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.sfaBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 1,
                  ),
                  child: viewModel.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Save Outlet',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.sfaLightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: AppColors.sfaBlue),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(12.0), child: child),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.secondary, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.sfaBlue),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(color: AppColors.secondary, fontSize: 13),
          ),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildLocationButton(IconData icon, String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.sfaBlue : Colors.black12,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? AppColors.sfaBlue : AppColors.textPrimary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.sfaBlue : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
