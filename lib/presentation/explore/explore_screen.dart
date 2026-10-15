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
          'Create Customer',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Container(
            padding: const EdgeInsets.only(left: 56, bottom: 8),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.primaryPurple, width: 2),
              ),
            ),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                children: [
                  TextSpan(text: 'Customer Management › '),
                  TextSpan(
                    text: 'Create Customer',
                    style: TextStyle(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepProgress(viewModel),
            const SizedBox(height: 14),
            Obx(() => _buildStepContent(viewModel)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomDock(context, viewModel),
    );
  }

  Widget _buildStepProgress(AddOutletViewModel viewModel) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepIndicator(1, 'Basics', viewModel.currentStep.value),
          _buildStepDivider(1, viewModel.currentStep.value),
          _buildStepIndicator(2, 'Classification', viewModel.currentStep.value),
          _buildStepDivider(2, viewModel.currentStep.value),
          _buildStepIndicator(3, 'Details & Docs', viewModel.currentStep.value),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, int currentStep) {
    final isDone = currentStep > step;
    final isActive = currentStep == step;
    final color = isDone
        ? AppColors.textPrimary
        : isActive
        ? AppColors.primaryPurple
        : AppColors.textSecondary;

    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isDone ? AppColors.primaryPurple : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive || isDone
                    ? AppColors.primaryPurple
                    : AppColors.secondary,
                width: 2,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.lightBlueBackground,
                        spreadRadius: 4,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text(
                      '$step',
                      style: TextStyle(
                        color: isActive
                            ? AppColors.primaryPurple
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider(int step, int currentStep) {
    final isDone = currentStep > step;
    return Expanded(
      flex: 3,
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(top: 14),
        decoration: BoxDecoration(
          color: isDone
              ? AppColors.primaryPurple
              : AppColors.secondary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget _buildStepContent(AddOutletViewModel viewModel) {
    switch (viewModel.currentStep.value) {
      case 1:
        return _buildStep1(viewModel);
      case 2:
        return _buildStep2(viewModel);
      case 3:
        return _buildStep3(viewModel);
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Step 1 ---

  Widget _buildStep1(AddOutletViewModel viewModel) {
    return Column(
      children: [
        _buildCustomerTypeSelection(viewModel),
        _buildBasicInformation(viewModel),
        _buildAddressSection(viewModel),
      ],
    );
  }

  Widget _buildCustomerTypeSelection(AddOutletViewModel viewModel) {
    return _buildSectionCard(
      icon: Icons.receipt_long,
      title: 'Customer Type',
      isRequired: true,
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton(
              title: 'Retailer',
              subtitle: 'Shop / outlet',
              icon: '🏪',
              isSelected: viewModel.customerType.value == 'Retailer',
              onTap: () => viewModel.toggleCustomerType('Retailer'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildSegmentButton(
              title: 'Mechanic',
              subtitle: 'Workshop',
              icon: '🔧',
              isSelected: viewModel.customerType.value == 'Mechanic',
              onTap: () => viewModel.toggleCustomerType('Mechanic'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required String title,
    required String subtitle,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightBlueBackground : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColors.primaryPurple
                : AppColors.secondary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInformation(AddOutletViewModel viewModel) {
    return _buildSectionCard(
      icon: Icons.person_outline,
      title: 'Basic Information',
      child: Column(
        children: [
          _buildFieldLayout(
            label: 'Shop Name',
            isRequired: true,
            child: _buildTextField(viewModel.shopNameController, 'Enter name'),
          ),
          const SizedBox(height: 12),
          _buildFieldLayout(
            label: 'Contact Person',
            isRequired: true,
            child: _buildTextField(
              viewModel.contactPersonController,
              'Enter name',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFieldLayout(
                  label: 'Mobile',
                  isRequired: true,
                  child: _buildTextField(
                    viewModel.mobileController,
                    '10-digit mobile',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildFieldLayout(
                  label: 'Alt. Mobile',
                  child: _buildTextField(
                    viewModel.altMobileController,
                    'Optional',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFieldLayout(
            label: 'Email',
            child: _buildTextField(
              viewModel.emailController,
              'name@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 12),
          _buildFieldLayout(
            label: 'WhatsApp No.',
            child: _buildTextField(
              viewModel.whatsappController,
              'Optional',
              keyboardType: TextInputType.phone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(AddOutletViewModel viewModel) {
    return _buildSectionCard(
      icon: Icons.location_on_outlined,
      title: 'Address',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLayout(
            label: 'Address Line',
            isRequired: true,
            child: _buildTextField(
              viewModel.addressController,
              'Enter address',
              maxLines: 2,
              isTextArea: true,
            ),
          ),
          const SizedBox(height: 12),
          _buildFieldLayout(
            label: 'Pincode',
            isRequired: true,
            child: _buildTextField(
              viewModel.pinCodeController,
              '6-digit code',
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: viewModel.isPinMapped.value
                    ? AppColors.lightBlueBackground
                    : const Color(0xFFFFF4DC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        viewModel.isPinMapped.value
                            ? '✓ Mapped automatically from pincode'
                            : '⚠ Couldn’t confidently map — please review',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: viewModel.isPinMapped.value
                              ? AppColors.primaryPurple
                              : const Color(0xFF8A5B00),
                        ),
                      ),
                      const Text(
                        'Review / Change',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGeoValue('State', viewModel.state.value),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildGeoValue('City', viewModel.city.value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildGeoValue('Territory', viewModel.territory.value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeoValue(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10.5,
              color: AppColors.textSecondary,
              letterSpacing: 0.4,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 2 ---

  Widget _buildStep2(AddOutletViewModel viewModel) {
    return _buildSectionCard(
      icon: Icons.folder_open,
      title: 'Classification with Beats',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFieldLayout(
                  label: 'Sub Type',
                  isRequired: true,
                  child: _buildDropdown(
                    value: viewModel.subType.value,
                    items: ['Retailer', 'Wholesaler', 'Semi-Wholesaler'],
                    onChanged: (val) => viewModel.subType.value = val!,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildFieldLayout(
                  label: 'Channel',
                  isRequired: true,
                  child: _buildDropdown(
                    value: viewModel.channel.value,
                    items: ['General Trade', 'Modern Trade', 'Institutional'],
                    onChanged: (val) => viewModel.channel.value = val!,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFieldLayout(
                  label: 'Segment',
                  isRequired: true,
                  child: _buildDropdown(
                    value: viewModel.segment.value,
                    items: ['Automotive', 'Industrial', 'Hardware'],
                    onChanged: (val) => viewModel.segment.value = val!,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildFieldLayout(
                  label: 'Category',
                  isRequired: true,
                  child: _buildDropdown(
                    value: viewModel.category.value,
                    items: ['A', 'B', 'C'],
                    onChanged: (val) => viewModel.category.value = val!,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFieldLayout(
            label: 'Class',
            isRequired: true,
            child: _buildDropdown(
              value: viewModel.classificationClass.value,
              items: ['Premium', 'Standard', 'Economy'],
              onChanged: (val) => viewModel.classificationClass.value = val!,
            ),
          ),
          const SizedBox(height: 12),
          _buildFieldLayout(
            label: 'Beat Area',
            isRequired: true,
            child: Obx(
              () => _buildDropdown(
                value: viewModel.beatArea.value.isEmpty
                    ? null
                    : viewModel.beatArea.value,
                hint: 'Select beat area',
                items: viewModel.beatAreas,
                onChanged: (val) => viewModel.beatArea.value = val!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 3 ---

  Widget _buildStep3(AddOutletViewModel viewModel) {
    return Column(
      children: [
        _buildCollapsibleSection(
          icon: Icons.business,
          title: 'Business Information',
          isExpanded: viewModel.isBusinessInfoExpanded,
          child: Column(
            children: [
              _buildFieldLayout(
                label: 'Registration Number',
                child: _buildTextField(
                  viewModel.regNumberController,
                  'e.g. UDYAM-MP-23-0001234',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildFieldLayout(
                      label: 'Business Type',
                      child: _buildDropdown(
                        value: viewModel.businessType.value,
                        items: ['Proprietorship', 'Partnership', 'Pvt. Ltd.'],
                        onChanged: (val) => viewModel.businessType.value = val!,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildFieldLayout(
                      label: 'Est. Year',
                      child: _buildTextField(
                        viewModel.estYearController,
                        '2015',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildTypeSpecificDetails(viewModel),
        _buildCollapsibleSection(
          icon: Icons.badge_outlined,
          title: 'KYC / Tax',
          isExpanded: viewModel.isKycExpanded,
          child: Column(
            children: [
              _buildFieldLayout(
                label: 'PAN',
                child: _buildTextField(
                  viewModel.panController,
                  'ABCDE1234F',
                  maxLength: 10,
                ),
              ),
              const SizedBox(height: 12),
              _buildFieldLayout(
                label: 'GSTIN',
                child: _buildTextField(
                  viewModel.gstController,
                  '23ABCDE1234F1Z5',
                  maxLength: 15,
                ),
              ),
              const SizedBox(height: 12),
              _buildFieldLayout(
                label: 'KYC Document',
                child: _buildDropdown(
                  value: viewModel.kycDocType.value,
                  items: ['Aadhaar', 'Voter ID', 'Driving Licence'],
                  onChanged: (val) => viewModel.kycDocType.value = val!,
                ),
              ),
            ],
          ),
        ),
        _buildCollapsibleSection(
          icon: Icons.account_balance,
          title: 'Bank Details',
          isExpanded: viewModel.isBankExpanded,
          child: Column(
            children: [
              _buildFieldLayout(
                label: 'Bank Name',
                child: _buildTextField(
                  viewModel.bankNameController,
                  'e.g. State Bank of India',
                ),
              ),
              const SizedBox(height: 12),
              _buildFieldLayout(
                label: 'Account Holder Name',
                child: _buildTextField(
                  viewModel.accHolderController,
                  'As per bank records',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildFieldLayout(
                      label: 'Account Number',
                      child: _buildTextField(
                        viewModel.accNumberController,
                        '9–18 digits',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildFieldLayout(
                      label: 'IFSC Code',
                      child: _buildTextField(
                        viewModel.ifscController,
                        'SBIN0001234',
                        maxLength: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildAttachmentSection(viewModel),
        _buildReviewSection(viewModel),
      ],
    );
  }

  Widget _buildTypeSpecificDetails(AddOutletViewModel viewModel) {
    if (viewModel.customerType.value == 'Retailer') {
      return _buildSectionCard(
        icon: Icons.storefront,
        title: 'Retailer Details',
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildFieldLayout(
                    label: 'Shop Size',
                    child: _buildDropdown(
                      value: viewModel.shopSize.value,
                      items: ['Small (<200 sq ft)', 'Medium', 'Large'],
                      onChanged: (val) => viewModel.shopSize.value = val!,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFieldLayout(
                    label: 'Monthly Potential',
                    child: _buildDropdown(
                      value: viewModel.monthlyPotential.value,
                      items: ['₹1–3 L', '₹3–5 L', '₹5 L+'],
                      onChanged: (val) =>
                          viewModel.monthlyPotential.value = val!,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFieldLayout(
              label: 'Brands Stocked',
              child: _buildTextField(
                viewModel.brandsStockedController,
                'e.g. Bosch, Exide',
              ),
            ),
            const SizedBox(height: 12),
            _buildFieldLayout(
              label: 'Shop Timings',
              child: _buildTextField(
                viewModel.shopTimingsController,
                '10:00 AM – 8:00 PM',
              ),
            ),
          ],
        ),
      );
    } else {
      return _buildSectionCard(
        icon: Icons.handyman,
        title: 'Mechanic Details',
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildFieldLayout(
                    label: 'Workshop Type',
                    child: _buildDropdown(
                      value: viewModel.workshopType.value,
                      items: ['Two-wheeler', 'Four-wheeler', 'Commercial'],
                      onChanged: (val) => viewModel.workshopType.value = val!,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFieldLayout(
                    label: 'Experience (yrs)',
                    child: _buildTextField(
                      viewModel.experienceController,
                      '8',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFieldLayout(
              label: 'Specialization',
              child: _buildTextField(
                viewModel.specializationController,
                'Engine, Electrical…',
              ),
            ),
            const SizedBox(height: 12),
            _buildFieldLayout(
              label: 'Mechanics in Workshop',
              child: _buildTextField(
                viewModel.mechanicsCountController,
                '3',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildAttachmentSection(AddOutletViewModel viewModel) {
    return _buildSectionCard(
      icon: Icons.attach_file,
      title: 'Attachment',
      isRequired: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              viewModel.pickFile();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryPurple,
              elevation: 0,
              side: const BorderSide(
                color: AppColors.primaryPurple,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
              minimumSize: const Size(120, 44),
            ),
            child: Obx(
              () => Text(
                viewModel.selectedFileName.value.isEmpty
                    ? '＋ Choose file'
                    : '＋ Change file',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Obx(() {
            if (viewModel.selectedFileName.value.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Text('📄 '),
                    Expanded(
                      child: Text(
                        viewModel.selectedFileName.value,
                        style: const TextStyle(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () => viewModel.removeFile(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Remove',
                        style: TextStyle(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(height: 8),
          const Text(
            'PDF, JPG, JPEG or PNG · max 5 MB',
            style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(AddOutletViewModel viewModel) {
    return _buildSectionCard(
      icon: Icons.check_circle_outline,
      title: 'Review',
      child: Column(
        children: [
          _buildReviewRow('Type', viewModel.customerType.value),
          _buildReviewRow('Shop Name', viewModel.shopNameController.text),
          _buildReviewRow(
            'Contact',
            '${viewModel.contactPersonController.text} · ${viewModel.mobileController.text}',
          ),
          _buildReviewRow(
            'Address',
            '${viewModel.addressController.text}, ${viewModel.city.value} ${viewModel.pinCodeController.text}',
          ),
          _buildReviewRow('Territory', viewModel.territory.value),
          _buildReviewRow(
            'Classification',
            '${viewModel.subType.value} / ${viewModel.channel.value} / ${viewModel.segment.value} / ${viewModel.category.value} / ${viewModel.classificationClass.value}',
          ),
          _buildReviewRow(
            'Beat Area',
            viewModel.beatArea.value.isNotEmpty
                ? viewModel.beatArea.value
                : '—',
          ),
          _buildReviewRow(
            'Attachment',
            viewModel.selectedFileName.value.isNotEmpty
                ? viewModel.selectedFileName.value
                : '—',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.secondary.withValues(alpha: 0.3),
              style: BorderStyle.solid,
            ),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Reusable Components ---

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
    bool isRequired = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1114283C),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlueBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: AppColors.primaryPurple),
                ),
                const SizedBox(width: 10),
                RichText(
                  text: TextSpan(
                    text: title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    children: isRequired
                        ? const [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Color(0xFFD93A3A)),
                            ),
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.secondary.withValues(alpha: 0.3)),
          Padding(padding: const EdgeInsets.all(14.0), child: child),
        ],
      ),
    );
  }

  Widget _buildCollapsibleSection({
    required IconData icon,
    required String title,
    required RxBool isExpanded,
    required Widget child,
  }) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1114283C),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => isExpanded.toggle(),
              borderRadius: BorderRadius.circular(isExpanded.value ? 0 : 18),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.lightBlueBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        size: 18,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text(
                        'Optional',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isExpanded.value ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded.value)
              Divider(
                height: 1,
                color: AppColors.secondary.withValues(alpha: 0.3),
              ),
            if (isExpanded.value)
              Padding(padding: const EdgeInsets.all(14.0), child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLayout({
    required String label,
    required Widget child,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              children: isRequired
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Color(0xFFD93A3A)),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    bool isTextArea = false,
  }) {
    return TextField(controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
      decoration: InputDecoration(hintText: hint,
        counterText: '',
        hintStyle: const TextStyle(color: AppColors.secondary, fontSize: 15),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: isTextArea ? 10 : 0,
        ),
        constraints: BoxConstraints(minHeight: isTextArea ? 64 : 42),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isTextArea ? 18 : 99),
          borderSide: BorderSide(
            color: AppColors.secondary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isTextArea ? 18 : 99),
          borderSide: BorderSide(
            color: AppColors.secondary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isTextArea ? 18 : 99),
          borderSide: const BorderSide(
            color: AppColors.primaryPurple,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    String? hint,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: hint != null
              ? Text(
                  hint,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 15,
                  ),
                )
              : null,
          isExpanded: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.textSecondary,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildBottomDock(BuildContext context, AddOutletViewModel viewModel) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1F14283C),
            blurRadius: 14,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: viewModel.previousStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.textPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      side: BorderSide(
                        color: AppColors.secondary.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                      minimumSize: const Size(0, 40),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        viewModel.currentStep.value > 1 ? '← Back' : 'Cancel',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 5,
                child: ElevatedButton(
                  onPressed: () {}, // Save Draft logic
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryPurple,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    side: const BorderSide(
                      color: AppColors.primaryPurple,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                    minimumSize: const Size(0, 40),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Save Draft',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 5,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () => viewModel.nextStep(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      shadowColor: AppColors.primaryPurple.withValues(
                        alpha: 0.3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                      minimumSize: const Size(0, 40),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        viewModel.currentStep.value < 3 ? 'Next →' : '✓ Submit',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
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
}
