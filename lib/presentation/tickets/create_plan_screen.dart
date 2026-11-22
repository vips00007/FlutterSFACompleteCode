import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../dashboard/dashboard_viewmodel.dart';
import 'create_plan_viewmodel.dart';

class CreatePlanScreen extends StatelessWidget {
  const CreatePlanScreen({super.key});

  // Color Constants strictly matching Add Outlet theme & prototype
  static const Color bgColor = Color(0xFFF4F3F9);
  static const Color surfColor = Color(0xFFFFFFFF);
  static const Color txColor = Color(0xFF17193F);
  static const Color mutColor = Color(0xFF6B6F93);
  static const Color bdColor = Color(0xFFDCDBEA);
  static const Color priColor = Color(0xFF6A3FD6);
  static const Color pri2Color = Color(0xFFF0EBFC);
  static const Color okColor = Color(0xFF1B9A6C);
  static const Color okbColor = Color(0xFFE8F6F0);
  static const Color waColor = Color(0xFFD97706);
  static const Color wabColor = Color(0xFFFEF3C7);
  static const Color erColor = Color(0xFFD62839);
  static const Color erbColor = Color(0xFFFCE8EA);

  void _handleBackNavigation(BuildContext context, CreatePlanViewModel viewModel) {
    if (viewModel.currentScreen.value != 'list') {
      viewModel.go('list');
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else if (Get.isRegistered<DashboardViewModel>()) {
      Get.find<DashboardViewModel>().changeTabIndex(0);
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<CreatePlanViewModel>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation(context, viewModel);
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Obx(() {
            switch (viewModel.currentScreen.value) {
              case 'list':
                return _buildListScreen(context, viewModel);
              case 'create':
                return _buildCreateScreen(context, viewModel);
              case 'detail':
                return _buildDetailScreen(context, viewModel);
              default:
                return _buildListScreen(context, viewModel);
            }
          }),
        ),
      ),
    );
  }

  // --- 1. MY PLAN – TAB-BASED LISTING SCREEN ---
  Widget _buildListScreen(BuildContext context, CreatePlanViewModel viewModel) {
    final filters = ['All', 'Pending', 'Approved', 'Rejected'];

    return Column(
      children: [
        // Header matching Add Outlet screen header design
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          constraints: const BoxConstraints(minHeight: 60),
          decoration: BoxDecoration(
            color: priColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: priColor.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => _handleBackNavigation(context, viewModel),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Visit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: () => viewModel.newPlan(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: priColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '＋ Create Plan',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Main List Content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Section Label
              const Text(
                'MY PLAN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: mutColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() {
                  return Row(
                    children: filters.map((f) {
                      final isSelected = viewModel.currentFilter.value == f;
                      final count = viewModel.getPlanCountByStatus(f);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => viewModel.currentFilter.value = f,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? priColor : surfColor,
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(
                                color: isSelected ? priColor : bdColor,
                              ),
                            ),
                            child: Text(
                              '$f ($count)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : mutColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Plan Cards List
              Obx(() {
                final plansList = viewModel.filteredPlans;
                if (plansList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'No plans found.',
                        style: TextStyle(color: mutColor, fontSize: 14),
                      ),
                    ),
                  );
                }

                return Column(
                  children: plansList.map((plan) {
                    return _buildPlanCard(viewModel, plan);
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // Plan Card Component
  Widget _buildPlanCard(CreatePlanViewModel viewModel, PrototypePlan plan) {
    final zoneInfo = Z[plan.zone] ?? ['Unknown', 'Unknown'];

    // Status Styling
    Color statusBg = wabColor;
    Color statusTextColor = waColor;
    if (plan.status == 'Approved') {
      statusBg = okbColor;
      statusTextColor = okColor;
    } else if (plan.status == 'Rejected') {
      statusBg = erbColor;
      statusTextColor = erColor;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: surfColor,
        border: Border.all(color: bdColor),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(15, 27, 45, 0.05),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => viewModel.go('detail', openRef: plan.ref),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Ref & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plan.ref,
                      style: const TextStyle(
                        color: priColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        decorationThickness: 1.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        plan.status,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Row 2: Meta Info (Customers, Date, Location)
                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    Text(
                      '👥 ${plan.cust.length} Customers',
                      style: const TextStyle(color: mutColor, fontSize: 12.5),
                    ),
                    Text(
                      '📅 ${viewModel.formatPlanDateRange(plan)}',
                      style: const TextStyle(color: mutColor, fontSize: 12.5),
                    ),
                    Text(
                      '📍 ${zoneInfo[0]}, ${zoneInfo[1]}',
                      style: const TextStyle(color: mutColor, fontSize: 12.5),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Row 3: Tag & Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: pri2Color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        plan.mode,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: priColor,
                        ),
                      ),
                    ),
                    const Text(
                      'View details ›',
                      style: TextStyle(color: mutColor, fontSize: 12.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 2. CREATE PLAN – LOCAL & UPCOUNTRY SCREEN ---
  Widget _buildCreateScreen(BuildContext context, CreatePlanViewModel viewModel) {
    return Column(
      children: [
        // Header matching Add Outlet screen header design
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          constraints: const BoxConstraints(minHeight: 60),
          decoration: BoxDecoration(
            color: priColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: priColor.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => _handleBackNavigation(context, viewModel),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Create Plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scrollable Form Content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
            children: [
              // Plan Type Segmented Toggle
              const Text(
                'PLAN TYPE',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mutColor, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: pri2Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSegButton(
                        viewModel: viewModel,
                        mode: 'Local',
                        label: '🏙️ Local',
                      ),
                    ),
                    Expanded(
                      child: _buildSegButton(
                        viewModel: viewModel,
                        mode: 'Upcountry',
                        label: '🚚 Upcountry',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Select Beat / Select Territory Dropdown
              Obx(() => Text(
                viewModel.currentMode.value == 'Local' ? 'SELECT BEAT' : 'SELECT TERRITORY',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mutColor, letterSpacing: 0.5),
              )),
              const SizedBox(height: 8),
              Obx(() {
                final mode = viewModel.currentMode.value;
                final availableZones = Z.entries.where((e) => e.value[2] == mode).toList();

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: surfColor,
                    border: Border.all(color: bdColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: viewModel.currentZone.value.isEmpty ? null : viewModel.currentZone.value,
                      hint: Text(
                        '— Choose ${mode == 'Local' ? 'beat' : 'territory'} —',
                        style: const TextStyle(color: mutColor, fontSize: 14),
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: txColor),
                      items: availableZones.map((entry) {
                        final key = entry.key;
                        final info = entry.value;
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Text(
                            '${info[0]} · ${info[1]}',
                            style: const TextStyle(fontSize: 14, color: txColor),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        viewModel.currentZone.value = val ?? '';
                        viewModel.selectedCustomerIds.clear();
                      },
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Visit Date / Date Range
              Obx(() => Text(
                viewModel.currentMode.value == 'Local' ? 'VISIT DATE' : 'DATE RANGE',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mutColor, letterSpacing: 0.5),
              )),
              const SizedBox(height: 8),
              Obx(() {
                final isLocal = viewModel.currentMode.value == 'Local';
                if (isLocal) {
                  return _buildDatePickerField(
                    context: context,
                    value: viewModel.d1.value,
                    onDatePicked: (val) {
                      viewModel.d1.value = val;
                      viewModel.d2.value = val;
                    },
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('From date', style: TextStyle(color: mutColor, fontSize: 12)),
                            const SizedBox(height: 4),
                            _buildDatePickerField(
                              context: context,
                              value: viewModel.d1.value,
                              onDatePicked: (val) {
                                viewModel.d1.value = val;
                                if (viewModel.d2.value.compareTo(val) < 0) {
                                  viewModel.d2.value = val;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('To date', style: TextStyle(color: mutColor, fontSize: 12)),
                            const SizedBox(height: 4),
                            _buildDatePickerField(
                              context: context,
                              value: viewModel.d2.value,
                              minDate: viewModel.d1.value,
                              onDatePicked: (val) {
                                viewModel.d2.value = val;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
              const SizedBox(height: 18),

              // Unplanned Customers Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'UNPLANNED CUSTOMERS',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mutColor, letterSpacing: 0.5),
                  ),
                  Obx(() {
                    final customers = viewModel.filteredCustomers;
                    if (customers.isEmpty) return const SizedBox.shrink();
                    final allSel = viewModel.isAllVisibleSelected;
                    return GestureDetector(
                      onTap: () => viewModel.toggleAllVisibleCustomers(!allSel),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                        decoration: BoxDecoration(
                          color: surfColor,
                          border: Border.all(color: bdColor),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          allSel ? 'Clear all' : 'Select all',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: mutColor),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 8),

              // Customer Type Filter Chips
              Obx(() {
                final baseCustomers = viewModel.zoneAvailableCustomers;
                final types = ['All', 'D', 'R', 'M'];

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: types.map((t) {
                      final isSelected = viewModel.currentTypeFilter.value == t;
                      final label = t == 'All' ? 'All' : '${TN[t]}s';
                      final count = t == 'All'
                          ? baseCustomers.length
                          : baseCustomers.where((c) => c.type == t).length;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => viewModel.currentTypeFilter.value = t,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? priColor : surfColor,
                              border: Border.all(color: isSelected ? priColor : bdColor),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              '$label ($count)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : mutColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
              const SizedBox(height: 10),

              // Search Box
              TextField(
                onChanged: (val) => viewModel.searchQuery.value = val,
                decoration: InputDecoration(
                  hintText: 'Search customer or owner',
                  hintStyle: const TextStyle(color: mutColor, fontSize: 14),
                  filled: true,
                  fillColor: surfColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: bdColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: bdColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: priColor),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Customer Cards / Empty State
              Obx(() {
                if (viewModel.currentZone.value.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: Text(
                        'Select a ${viewModel.currentMode.value == 'Local' ? 'beat' : 'territory'} to see available customers.',
                        style: const TextStyle(color: mutColor, fontSize: 14),
                      ),
                    ),
                  );
                }

                final list = viewModel.filteredCustomers;
                if (list.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: Text(
                        'No unplanned customers available.',
                        style: TextStyle(color: mutColor, fontSize: 14),
                      ),
                    ),
                  );
                }

                return Column(
                  children: list.map((c) {
                    final isSel = viewModel.selectedCustomerIds.contains(c.id);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: isSel ? pri2Color : surfColor,
                        border: Border.all(color: isSel ? priColor : bdColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => viewModel.toggleCustomerSelection(c.id),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                // Checkbox
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: isSel ? priColor : surfColor,
                                    border: Border.all(color: isSel ? priColor : bdColor, width: 2),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: isSel
                                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 12),

                                // Type Avatar Circle
                                Container(
                                  width: 36,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: pri2Color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    TN[c.type]![0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: priColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Customer Name & Owner
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: txColor,
                                        ),
                                      ),
                                      Text(
                                        '${c.owner} · ${Z[c.zone]![0]}',
                                        style: const TextStyle(fontSize: 12, color: mutColor),
                                      ),
                                    ],
                                  ),
                                ),

                                // Tag
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: pri2Color,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    TN[c.type]!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: priColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),

        // Sticky Bottom Footer Bar matching Add Outlet screen button design
        Obx(() {
          final count = viewModel.selectedCustomerIds.length;
          final isValid = viewModel.isFormValid;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: const BoxDecoration(
              color: surfColor,
              border: Border(top: BorderSide(color: bdColor)),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$count',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: txColor),
                      ),
                      const Text(
                        'selected',
                        style: TextStyle(fontSize: 11, color: mutColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: (isValid && !viewModel.isSubmitting.value)
                          ? () => viewModel.savePlan()
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: priColor,
                        disabledBackgroundColor: priColor.withValues(alpha: 0.4),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: viewModel.isSubmitting.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'Create Plan',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Segmented control button helper
  Widget _buildSegButton({
    required CreatePlanViewModel viewModel,
    required String mode,
    required String label,
  }) {
    return Obx(() {
      final isSelected = viewModel.currentMode.value == mode;
      return GestureDetector(
        onTap: () {
          viewModel.currentMode.value = mode;
          viewModel.currentZone.value = '';
          viewModel.selectedCustomerIds.clear();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? surfColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color.fromRGBO(15, 27, 45, 0.07),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? priColor : mutColor,
            ),
          ),
        ),
      );
    });
  }

  // Date Picker Helper
  Widget _buildDatePickerField({
    required BuildContext context,
    required String value,
    required Function(String) onDatePicked,
    String? minDate,
  }) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        DateTime initial = DateTime.tryParse(value) ?? now;
        DateTime first = minDate != null ? (DateTime.tryParse(minDate) ?? now) : DateTime(now.year - 1);

        if (initial.isBefore(first)) initial = first;

        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: first,
          lastDate: DateTime(now.year + 2),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: priColor,
                  onPrimary: Colors.white,
                  onSurface: txColor,
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          onDatePicked(DateFormat('yyyy-MM-dd').format(picked));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: surfColor,
          border: Border.all(color: bdColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 14, color: txColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.calendar_today, size: 16, color: mutColor),
          ],
        ),
      ),
    );
  }

  // --- 3. PLAN DETAIL VIEW SCREEN ---
  Widget _buildDetailScreen(BuildContext context, CreatePlanViewModel viewModel) {
    return Obx(() {
      final ref = viewModel.openPlanRef.value;
      final plan = viewModel.plans.firstWhere(
        (p) => p.ref == ref,
        orElse: () => PrototypePlan(
          ref: ref.isNotEmpty ? ref : 'PLN-000000',
          mode: 'Local',
          zone: 'L1',
          from: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          to: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          cust: [1, 2],
          status: 'Approved',
        ),
      );

      final zoneInfo = Z[plan.zone] ?? ['Unknown', 'Unknown'];

      final planCustomers = plan.cust
          .map((id) => viewModel.customers.firstWhere((c) => c.id == id,
              orElse: () => PrototypeCustomer(
                    id: id,
                    zone: plan.zone,
                    type: 'R',
                    name: 'Customer #$id',
                    owner: 'Owner Name',
                    phone: '+91 9000000000',
                    addr: 'Shop Address',
                  )))
          .toList();

      // Status Styling
      Color statusBg = wabColor;
      Color statusTextColor = waColor;
      if (plan.status == 'Approved') {
        statusBg = okbColor;
        statusTextColor = okColor;
      } else if (plan.status == 'Rejected') {
        statusBg = erbColor;
        statusTextColor = erColor;
      }

      return Column(
        children: [
          // Header matching Add Outlet screen header design
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            constraints: const BoxConstraints(minHeight: 60),
            decoration: BoxDecoration(
              color: priColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: priColor.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => _handleBackNavigation(context, viewModel),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    plan.ref,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    plan.status,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: statusTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Detail Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Overview Summary Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: surfColor,
                    border: Border.all(color: bdColor),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(15, 27, 45, 0.07),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Key-Value Grid
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Plan type', style: TextStyle(color: mutColor, fontSize: 11.5)),
                                const SizedBox(height: 2),
                                Text(plan.mode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: txColor)),
                                const SizedBox(height: 12),
                                const Text('City', style: TextStyle(color: mutColor, fontSize: 11.5)),
                                const SizedBox(height: 2),
                                Text(zoneInfo[1], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: txColor)),
                                const SizedBox(height: 12),
                                const Text('Total customers', style: TextStyle(color: mutColor, fontSize: 11.5)),
                                const SizedBox(height: 2),
                                Text('${planCustomers.length}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: txColor)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(plan.mode == 'Local' ? 'Beat' : 'Territory', style: const TextStyle(color: mutColor, fontSize: 11.5)),
                                const SizedBox(height: 2),
                                Text(zoneInfo[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: txColor)),
                                const SizedBox(height: 12),
                                const Text('Date', style: TextStyle(color: mutColor, fontSize: 11.5)),
                                const SizedBox(height: 2),
                                Text(viewModel.formatPlanDateRange(plan), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: txColor)),
                                const SizedBox(height: 12),
                                const Text('Mix', style: TextStyle(color: mutColor, fontSize: 11.5)),
                                const SizedBox(height: 2),
                                Text(viewModel.getCustomerMixString(planCustomers), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: txColor)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Rejection Remark Banner if Rejected
                      if (plan.remark != null && plan.remark!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: erbColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: erColor, fontSize: 13),
                              children: [
                                const TextSpan(text: 'Rejection remark: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: plan.remark),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Planned Customers Section Header
                Text(
                  'PLANNED CUSTOMERS (${planCustomers.length})',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mutColor, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),

                // Planned Customer Cards
                Column(
                  children: planCustomers.map((c) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: surfColor,
                        border: Border.all(color: bdColor),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(15, 27, 45, 0.07),
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: pri2Color,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  TN[c.type]![0],
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: priColor, fontSize: 14),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: txColor)),
                                    Text(c.owner, style: const TextStyle(fontSize: 12, color: mutColor)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: pri2Color,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  TN[c.type]!,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: priColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('📞 ${c.phone}', style: const TextStyle(color: mutColor, fontSize: 12.5)),
                          const SizedBox(height: 4),
                          Text('📍 ${c.addr}', style: const TextStyle(color: mutColor, fontSize: 12.5)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
