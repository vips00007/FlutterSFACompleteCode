import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/my_geographies_response.dart';
import '../../data/models/visit_plan_models.dart';
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
                  onPressed: () => _showPlanTypeBottomSheet(context, viewModel),
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
                if (viewModel.isLoading.value && viewModel.apiVisitPlans.isEmpty && viewModel.plans.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: priColor),
                    ),
                  );
                }

                if (viewModel.apiVisitPlans.isNotEmpty) {
                  final apiPlansList = viewModel.filteredApiPlans;
                  if (apiPlansList.isEmpty) {
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
                    children: apiPlansList.map((plan) {
                      return _buildApiPlanCard(viewModel, plan);
                    }).toList(),
                  );
                }

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
              Expanded(
                child: Obx(() {
                  final mode = viewModel.currentMode.value;
                  return Text(
                    'Create Plan ($mode)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                }),
              ),
              GestureDetector(
                onTap: () => _showPlanTypeBottomSheet(context, viewModel),
                child: Obx(() {
                  final mode = viewModel.currentMode.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          mode == 'Local' ? '🏙️ Local' : '🚚 Upcountry',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        // Scrollable Form Content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
            children: [
              // Horizontal Row: Select Beat / Territory (Left) & Visit Date / Date Range (Right)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Select Beat / Select Territory Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                          viewModel.currentMode.value == 'Local' ? 'SELECT BEAT' : 'SELECT TERRITORY',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mutColor, letterSpacing: 0.5),
                        )),
                        const SizedBox(height: 8),
                        Obx(() {
                          final mode = viewModel.currentMode.value;
                          final geos = viewModel.geographies;

                          if (viewModel.isGeographiesLoading.value && geos.isEmpty) {
                            return Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: surfColor,
                                border: Border.all(color: bdColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: priColor, strokeWidth: 2),
                              ),
                            );
                          }

                          List<GeographyItem> displayGeos = geos;
                          if (mode == 'Upcountry') {
                            final nonPrimary = geos.where((g) => g.isPrimary == false).toList();
                            if (nonPrimary.isNotEmpty) {
                              displayGeos = nonPrimary;
                            }
                          } else {
                            final primary = geos.where((g) => g.isPrimary == true).toList();
                            if (primary.isNotEmpty) {
                              displayGeos = primary;
                            }
                          }

                          if (displayGeos.isEmpty && geos.isNotEmpty) {
                            displayGeos = geos;
                          }

                          if (displayGeos.isNotEmpty) {
                            final currentValue = viewModel.selectedGeography.value?.effectiveUuid.isNotEmpty == true
                                ? viewModel.selectedGeography.value!.effectiveUuid
                                : (viewModel.currentZone.value.isNotEmpty ? viewModel.currentZone.value : null);

                            final validValue = displayGeos.any((g) => g.effectiveUuid == currentValue)
                                ? currentValue
                                : (displayGeos.isNotEmpty ? displayGeos.first.effectiveUuid : null);

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: surfColor,
                                border: Border.all(color: bdColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: validValue,
                                  hint: Text(
                                    '— Choose ${mode == 'Local' ? 'beat' : 'territory'} —',
                                    style: const TextStyle(color: mutColor, fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down, color: txColor),
                                  items: displayGeos.map((g) {
                                    return DropdownMenuItem<String>(
                                      value: g.effectiveUuid,
                                      child: Text(
                                        g.name,
                                        style: const TextStyle(fontSize: 13, color: txColor),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    final selected = displayGeos.firstWhereOrNull((g) => g.effectiveUuid == val);
                                    viewModel.onGeographySelected(selected);
                                  },
                                ),
                              ),
                            );
                          }

                          // Fallback static prototype dropdown if no geographies returned
                          final availableZones = Z.entries.where((e) => e.value[2] == mode).toList();

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  style: const TextStyle(color: mutColor, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
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
                                      style: const TextStyle(fontSize: 13, color: txColor),
                                      overflow: TextOverflow.ellipsis,
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Right Column: Visit Date / Date Range
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                viewModel.onDate1Changed(val);
                              },
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDatePickerField(
                                  context: context,
                                  value: viewModel.d1.value,
                                  label: 'From',
                                  onDatePicked: (val) {
                                    viewModel.onDate1Changed(val);
                                  },
                                ),
                                const SizedBox(height: 6),
                                _buildDatePickerField(
                                  context: context,
                                  value: viewModel.d2.value,
                                  label: 'To',
                                  minDate: viewModel.d1.value,
                                  onDatePicked: (val) {
                                    viewModel.onDate2Changed(val);
                                  },
                                ),
                              ],
                            );
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              ),
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
                    if (viewModel.apiCustomers.isNotEmpty) {
                      final allSel = viewModel.isAllApiCustomersSelected;
                      return GestureDetector(
                        onTap: () => viewModel.toggleAllApiCustomers(!allSel),
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
                    }

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

              // Customer Category Filter Chips (Always exact 4 category tabs)
              Obx(() {
                final categoryTypes = [
                  {'key': 'All', 'label': 'All'},
                  {'key': 'D', 'label': 'Distributor'},
                  {'key': 'R', 'label': 'Retailer'},
                  {'key': 'M', 'label': 'Mechanics'},
                ];

                final isApiMode = viewModel.apiCustomers.isNotEmpty || viewModel.isCustomersLoading.value;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categoryTypes.map((t) {
                      final key = t['key']!;
                      final label = t['label']!;
                      final isSelected = viewModel.currentTypeFilter.value == key;

                      final count = isApiMode
                          ? viewModel.getApiCustomerCountForType(key)
                          : viewModel.getPrototypeCustomerCountForType(key);

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            viewModel.currentTypeFilter.value = key;
                          },
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
                if (viewModel.isCustomersLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: priColor),
                    ),
                  );
                }

                if (viewModel.customersError.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            viewModel.customersError.value,
                            style: const TextStyle(color: Colors.red, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => viewModel.fetchCustomers(),
                            style: ElevatedButton.styleFrom(backgroundColor: priColor),
                            child: const Text('Retry', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final apiList = viewModel.filteredApiCustomers;
                if (apiList.isNotEmpty) {
                  return Column(
                    children: apiList.map((c) {
                      final isSel = viewModel.selectedCustomerUuids.contains(c.uuid);
                      final shopName = c.shopName?.isNotEmpty == true ? c.shopName! : 'Unknown Shop';
                      final code = c.customerCode?.isNotEmpty == true ? c.customerCode! : 'N/A';
                      final areaCity = [c.area, c.city].where((s) => s != null && s.trim().isNotEmpty).join(', ');

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
                            onTap: () => viewModel.toggleApiCustomerSelection(c.uuid),
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

                                  // Avatar Circle
                                  Container(
                                    width: 36,
                                    height: 36,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: pri2Color,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      shopName[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: priColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Name & Location
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          shopName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: txColor,
                                          ),
                                        ),
                                        Text(
                                          'Code: $code${areaCity.isNotEmpty ? ' · $areaCity' : ''}',
                                          style: const TextStyle(fontSize: 12, color: mutColor),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Planned/Unplanned Badge
                                  if (c.planned == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: okbColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Planned',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: okColor,
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
                }

                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      'No customers available.',
                      style: TextStyle(color: mutColor, fontSize: 14),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        // Sticky Bottom Footer Bar matching Add Outlet screen button design
        Obx(() {
          final count = viewModel.selectedCustomerUuids.isNotEmpty
              ? viewModel.selectedCustomerUuids.length
              : viewModel.selectedCustomerIds.length;
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

  // Bottom Dialog for Local / Upcountry Plan Selection
  void _showPlanTypeBottomSheet(BuildContext context, CreatePlanViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Plan Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: txColor,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close, color: mutColor, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Choose the type of visit plan you want to create',
                style: TextStyle(fontSize: 13, color: mutColor),
              ),
              const SizedBox(height: 20),

              // Option 1: Local
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    viewModel.newPlan('Local');
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: pri2Color,
                      border: Border.all(color: priColor.withValues(alpha: 0.25)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: priColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('🏙️', style: TextStyle(fontSize: 22)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Local',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: txColor,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Daily visit plan for local beats & market routes',
                                style: TextStyle(fontSize: 12, color: mutColor),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: priColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Option 2: Upcountry
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    viewModel.newPlan('Upcountry');
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: pri2Color,
                      border: Border.all(color: priColor.withValues(alpha: 0.25)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: priColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('🚚', style: TextStyle(fontSize: 22)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upcountry',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: txColor,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Tour plan for outstation territories & travel',
                                style: TextStyle(fontSize: 12, color: mutColor),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: priColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }



  // Date Picker Helper
  Widget _buildDatePickerField({
    required BuildContext context,
    required String value,
    required Function(String) onDatePicked,
    String? minDate,
    String? label,
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                label != null ? '$label: $value' : value,
                style: const TextStyle(fontSize: 13, color: txColor, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.calendar_today, size: 15, color: mutColor),
          ],
        ),
      ),
    );
  }

  // Plan Card Component for API Visit Plan Model
  Widget _buildApiPlanCard(CreatePlanViewModel viewModel, VisitPlanModel plan) {
    final status = plan.displayStatus;

    // Status Styling
    Color statusBg = wabColor;
    Color statusTextColor = waColor;
    if (status == 'Approved') {
      statusBg = okbColor;
      statusTextColor = okColor;
    } else if (status == 'Rejected') {
      statusBg = erbColor;
      statusTextColor = erColor;
    }

    final locationText = plan.destinationGeographyName?.isNotEmpty == true
        ? plan.destinationGeographyName!
        : (plan.customers.isNotEmpty
            ? plan.customers.first.displayLocation
            : 'Not Available');

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
          onTap: () {
            viewModel.selectedApiPlan.value = plan;
            viewModel.go('detail', openRef: plan.uuid);
          },
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
                      plan.displayId, // e.g. PLN-C006
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
                        status, // Pending / Approved / Rejected
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
                      '👥 ${plan.totalCustomerCount} Customers',
                      style: const TextStyle(color: mutColor, fontSize: 12.5),
                    ),
                    Text(
                      '📅 ${plan.displayDateRange}',
                      style: const TextStyle(color: mutColor, fontSize: 12.5),
                    ),
                    Text(
                      '📍 $locationText',
                      style: TextStyle(
                        color: locationText == 'Not Available' ? erColor : mutColor,
                        fontSize: locationText == 'Not Available' ? 10.5 : 12.5,
                      ),
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
                        plan.displayPlanType,
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

  // --- 3. PLAN DETAIL VIEW SCREEN ---
  Widget _buildDetailScreen(BuildContext context, CreatePlanViewModel viewModel) {
    return Obx(() {
      if (viewModel.selectedApiPlan.value != null) {
        return _buildApiDetailScreen(context, viewModel, viewModel.selectedApiPlan.value!);
      }

      final ref = viewModel.openPlanRef.value;

      final apiMatch = viewModel.apiVisitPlans.firstWhereOrNull((p) => p.uuid == ref || p.displayId == ref);
      if (apiMatch != null) {
        return _buildApiDetailScreen(context, viewModel, apiMatch);
      }

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

  Widget _buildApiDetailScreen(BuildContext context, CreatePlanViewModel viewModel, VisitPlanModel plan) {
    final status = plan.displayStatus;

    Color statusBg = wabColor;
    Color statusTextColor = waColor;
    if (status == 'Approved') {
      statusBg = okbColor;
      statusTextColor = okColor;
    } else if (status == 'Rejected') {
      statusBg = erbColor;
      statusTextColor = erColor;
    }

    final String planTypeStr = plan.displayPlanType;
    final String dateStr = plan.displayDateRange;
    final String totalCustStr = '${plan.totalCustomerCount}';
    final String remarkStr = plan.displayRemark;

    final String locationText = plan.destinationGeographyName?.isNotEmpty == true
        ? plan.destinationGeographyName!
        : (plan.customers.isNotEmpty
            ? plan.customers.first.displayLocation
            : 'Not Available');

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
                onPressed: () {
                  viewModel.selectedApiPlan.value = null;
                  _handleBackNavigation(context, viewModel);
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  plan.displayId, // e.g. PLN-C006
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
                  status,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Plan type', style: TextStyle(color: mutColor, fontSize: 11.5)),
                              const SizedBox(height: 2),
                              Text(
                                planTypeStr,
                                style: TextStyle(
                                  fontWeight: planTypeStr == 'Not Available' ? FontWeight.w500 : FontWeight.bold,
                                  fontSize: planTypeStr == 'Not Available' ? 12.0 : 14.0,
                                  color: planTypeStr == 'Not Available' ? erColor : txColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text('Location', style: TextStyle(color: mutColor, fontSize: 11.5)),
                              const SizedBox(height: 2),
                              Text(
                                locationText,
                                style: TextStyle(
                                  fontWeight: locationText == 'Not Available' ? FontWeight.w500 : FontWeight.bold,
                                  fontSize: locationText == 'Not Available' ? 12.0 : 14.0,
                                  color: locationText == 'Not Available' ? erColor : txColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text('Total customers', style: TextStyle(color: mutColor, fontSize: 11.5)),
                              const SizedBox(height: 2),
                              Text(totalCustStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: txColor)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Status', style: TextStyle(color: mutColor, fontSize: 11.5)),
                              const SizedBox(height: 2),
                              Text(status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: txColor)),
                              const SizedBox(height: 12),
                              const Text('Date', style: TextStyle(color: mutColor, fontSize: 11.5)),
                              const SizedBox(height: 2),
                              Text(dateStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: txColor)),
                              const SizedBox(height: 12),
                              const Text('Plan Start / End', style: TextStyle(color: mutColor, fontSize: 11.5)),
                              const SizedBox(height: 2),
                              Text('${plan.displayFromDate} / ${plan.displayToDate}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: txColor)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Remark Banner (if remark present)
                    if (remarkStr != 'Not Available') ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: status == 'Rejected' ? erbColor : pri2Color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: status == 'Rejected' ? erColor : priColor,
                              fontSize: 13,
                            ),
                            children: [
                              const TextSpan(text: 'Remark: ', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: remarkStr),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Daily Customer Details Breakdown if days[] exists
              if (plan.days.isNotEmpty) ...[
                const Text(
                  'DAILY CUSTOMER DETAILS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mutColor, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                ...plan.days.map((day) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month, size: 16, color: priColor),
                            const SizedBox(width: 6),
                            Text(
                              day.displayDate,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: txColor),
                            ),
                            if (day.removedByApprover) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: erbColor, borderRadius: BorderRadius.circular(4)),
                                child: const Text('Removed by Approver', style: TextStyle(fontSize: 10, color: erColor, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (day.removedNote != null && day.removedNote!.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('Note: ${day.removedNote}', style: const TextStyle(fontSize: 12, color: erColor)),
                        ),
                      ...day.customers.map((c) => _buildCustomerCard(c)),
                    ],
                  );
                }),
                const SizedBox(height: 16),
              ],

              // Planned Customers Section Header
              Text(
                'PLANNED CUSTOMERS (${plan.customers.length})',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mutColor, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),

              // Customer List
              if (plan.customers.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text('No customers listed for this plan.', style: TextStyle(color: mutColor, fontSize: 13)),
                  ),
                )
              else
                Column(
                  children: plan.customers.map((c) => _buildCustomerCard(c)).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerCard(VisitPlanCustomerModel c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfColor,
        border: Border.all(color: c.removedByApprover ? erColor.withValues(alpha: 0.5) : bdColor),
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
                  (c.displayShopName.isNotEmpty && c.displayShopName != 'Not Available')
                      ? c.displayShopName[0].toUpperCase()
                      : 'C',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: priColor, fontSize: 14),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.displayShopName,
                      style: TextStyle(
                        fontWeight: c.displayShopName == 'Not Available' ? FontWeight.w500 : FontWeight.bold,
                        fontSize: c.displayShopName == 'Not Available' ? 12.0 : 14.0,
                        color: c.displayShopName == 'Not Available' ? erColor : txColor,
                      ),
                    ),
                    Text(
                      'Code: ${c.displayCustomerCode}',
                      style: TextStyle(
                        fontSize: c.displayCustomerCode == 'Not Available' ? 10.5 : 12.0,
                        color: c.displayCustomerCode == 'Not Available' ? erColor : mutColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (c.removedByApprover)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: erbColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Removed',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: erColor),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: (c.displayArea == 'Not Available' || c.displayCity == 'Not Available') ? erColor : mutColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Area: ${c.displayArea} · City: ${c.displayCity}',
                  style: TextStyle(
                    color: (c.displayArea == 'Not Available' || c.displayCity == 'Not Available') ? erColor : mutColor,
                    fontSize: (c.displayArea == 'Not Available' && c.displayCity == 'Not Available') ? 10.5 : 12.5,
                  ),
                ),
              ),
            ],
          ),
          if (c.ownerName != null && c.ownerName!.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('Owner: ${c.displayOwnerName}', style: const TextStyle(color: mutColor, fontSize: 12)),
          ],
          if (c.phone != null && c.phone!.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('📞 ${c.displayPhone}', style: const TextStyle(color: mutColor, fontSize: 12)),
          ],
          if (c.removedNote != null && c.removedNote!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: erbColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Removal note: ${c.removedNote}',
                style: const TextStyle(fontSize: 11.5, color: erColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
