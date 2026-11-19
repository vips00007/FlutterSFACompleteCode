import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import '../../data/models/my_visits_response.dart';
import 'create_plan_viewmodel.dart';

class CreatePlanScreen extends StatelessWidget {
  const CreatePlanScreen({super.key});

  // Colors based on the existing app theme
  static const Color bgColor = AppColors.background;
  static const Color surfColor = Colors.white;
  static const Color inkColor = AppColors.textPrimary;
  static const Color muteColor = AppColors.textSecondary;
  static const Color lineColor = Color(0xFFE0E0E0);
  static const Color accColor = AppColors.primaryPurple;
  static const Color accTColor = Color(0x1A8A2BE2);
  static const Color warnColor = Color(0xFFEF6C00);
  static const Color warnTColor = Color(0xFFFFF3E0);
  static const Color errColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<CreatePlanViewModel>();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Obx(() {
          switch (viewModel.currentScreen.value) {
            case 'list':
              return _buildListScreen(viewModel);
            case 'planType':
              return _buildPlanTypeScreen(context, viewModel);
            case 'geography':
              return _buildGeographyScreen(context, viewModel);
            case 'retailers':
              return _buildRetailersScreen(context, viewModel);
            case 'details':
              return _buildDetailsScreen(context, viewModel);
            case 'done':
              return _buildDoneScreen(viewModel);
            default:
              return _buildListScreen(viewModel);
          }
        }),
      ),
    );
  }

  // --- 1. List Screen (Dynamic My Plans API Response) ---
  Widget _buildListScreen(CreatePlanViewModel viewModel) {
    return Column(
      children: [
        _buildAppBar(title: 'My plans', showBack: true, onBackPressed: () => Get.back()),
        Expanded(
          child: Obx(() {
            if (viewModel.isVisitsLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: accColor),
              );
            }

            if (viewModel.visitsHasError.value) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: errColor, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        viewModel.visitsErrorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: inkColor, fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => viewModel.fetchMyVisits(refresh: true),
                        style: ElevatedButton.styleFrom(backgroundColor: accColor),
                        child: const Text('Retry', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            }

            final list = viewModel.myVisits;
            if (list.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => viewModel.fetchMyVisits(refresh: true),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 100),
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('No travel plans found.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: inkColor)),
                          SizedBox(height: 4),
                          Text('Tap + Create plan to create a new visit plan.', style: TextStyle(color: muteColor, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => viewModel.fetchMyVisits(refresh: true),
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                    viewModel.loadNextVisitsPage();
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(14),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: list.length + (viewModel.isVisitsLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == list.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(color: accColor, strokeWidth: 2),
                        ),
                      );
                    }
                    final plan = list[index];
                    return _buildPlanCard(plan);
                  },
                ),
              ),
            );
          }),
        ),
        _buildFooter(
          buttonText: '+ Create plan',
          onPressed: () => viewModel.startAddPlan(),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String rawStatus) {
    final status = rawStatus.toUpperCase();
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'COMPLETED':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        label = 'Completed';
        break;
      case 'IN_PROGRESS':
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFEF6C00);
        label = 'In Progress';
        break;
      case 'MISSED':
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        label = 'Missed';
        break;
      case 'PENDING_APPROVAL':
        bgColor = warnTColor;
        textColor = warnColor;
        label = 'Pending approval';
        break;
      case 'APPROVED':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        label = 'Approved';
        break;
      case 'PLANNED':
      default:
        bgColor = accTColor;
        textColor = accColor;
        label = status == 'PLANNED' ? 'Planned' : status.replaceAll('_', ' ').capitalizeFirst ?? status;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildPlanCard(GroupedPlan plan) {
    final isExpanded = false.obs;

    return Obx(() {
      final showAll = isExpanded.value || plan.customers.length <= 2;
      final displayedCustomers = showAll ? plan.customers : plan.customers.take(2).toList();

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: surfColor,
          border: Border.all(color: lineColor),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Plan Ref ID, Plan Type Tag, Status Badge
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          plan.displayId,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: inkColor),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: plan.planType == 'OUTSTATION' ? Colors.orange.shade50 : accTColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: plan.planType == 'OUTSTATION' ? Colors.orange.shade300 : accColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            plan.planType,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: plan.planType == 'OUTSTATION' ? Colors.orange.shade900 : accColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(plan.status),
                ],
              ),
            ),

            // Sub-Header Info Row (Date & Customer Count)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 13, color: muteColor),
                  const SizedBox(width: 4),
                  Text(
                    plan.when,
                    style: const TextStyle(fontSize: 13, color: inkColor, fontWeight: FontWeight.w600),
                  ),
                  const Text(' · ', style: TextStyle(color: muteColor)),
                  const Icon(Icons.storefront_outlined, size: 13, color: muteColor),
                  const SizedBox(width: 4),
                  Text(
                    '${plan.customerCount} retailer${plan.customerCount > 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 13, color: muteColor),
                  ),
                ],
              ),
            ),

            // Location Summary Row (Area & City)
            if (plan.place != null && plan.place!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: accColor),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        plan.place!,
                        style: const TextStyle(fontSize: 12, color: muteColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

            const Divider(height: 16, color: lineColor),

            // Retailer List Details with Area, City, and Code
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: displayedCustomers.map((c) {
                  final String locationStr = [
                    if (c.area != null && c.area!.trim().isNotEmpty) c.area!.trim(),
                    if (c.city != null && c.city!.trim().isNotEmpty) c.city!.trim(),
                  ].join(', ');

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                c.customerName ?? 'Unknown Retailer',
                                style: const TextStyle(fontSize: 13, color: inkColor, fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (c.customerCode != null && c.customerCode!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  c.customerCode!,
                                  style: const TextStyle(fontSize: 11, color: muteColor, fontWeight: FontWeight.w500),
                                ),
                              ),
                          ],
                        ),
                        if (locationStr.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.map_outlined, size: 12, color: muteColor),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  locationStr,
                                  style: const TextStyle(fontSize: 11, color: muteColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            // Expand / Collapse Footer Toggle
            if (plan.customers.length > 2)
              InkWell(
                onTap: () => isExpanded.value = !isExpanded.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: lineColor)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isExpanded.value
                            ? 'Show less'
                            : '+ ${plan.customers.length - 2} more retailer${plan.customers.length - 2 > 1 ? 's' : ''}',
                        style: const TextStyle(fontSize: 12, color: accColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 16,
                        color: accColor,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  // --- 2. First Step: Select Plan Type Screen ---
  Widget _buildPlanTypeScreen(BuildContext context, CreatePlanViewModel viewModel) {
    return Column(
      children: [
        _buildAppBar(
          title: 'Select Plan Type',
          showBack: true,
          onBackPressed: () => viewModel.go('list'),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Choose visit plan type:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: inkColor),
              ),
              const SizedBox(height: 12),
              _buildTypeOption(viewModel, 'Local', '🏙️', 'Same-day visits within your area'),
              const SizedBox(height: 12),
              _buildTypeOption(viewModel, 'Outstation', '🚆', 'Outstation visits, multi-day trip'),
              const SizedBox(height: 20),

              // Dynamic Plan Date Visibility (Only visible when Local is selected)
              Obx(() {
                final isLocal = viewModel.planType.value.toLowerCase() == 'local';
                if (!isLocal) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Plan Date',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: inkColor),
                    ),
                    const SizedBox(height: 6),
                    _buildDatePicker(
                      context,
                      viewModel.selectedDate.value,
                      (val) => viewModel.setSelectedDate(val),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
        Obx(() => _buildFooter(
          buttonText: 'Continue',
          onPressed: viewModel.planType.value.isNotEmpty
              ? () => viewModel.continueFromPlanType()
              : null,
        )),
      ],
    );
  }

  Widget _buildTypeOption(CreatePlanViewModel viewModel, String type, String emoji, String subtitle) {
    return Obx(() {
      final isSelected = viewModel.planType.value.toLowerCase() == type.toLowerCase();
      return GestureDetector(
        onTap: () => viewModel.setPlanType(type),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? accTColor : surfColor,
            border: Border.all(
              color: isSelected ? accColor : lineColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: inkColor),
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 13, color: muteColor)),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? accColor : muteColor,
              ),
            ],
          ),
        ),
      );
    });
  }

  // --- Helper Widget: Custom Checkbox ---
  Widget _buildCustomCheckbox(bool isSelected) {
    const blueColor = Color(0xFF2563EB);
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? blueColor : surfColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? blueColor : const Color(0xFF94A3B8),
          width: 2,
        ),
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 18,
            )
          : null,
    );
  }

  // --- 2.5 Outstation Step: Select Geography Screen ---
  Widget _buildGeographyScreen(BuildContext context, CreatePlanViewModel viewModel) {
    const blueColor = Color(0xFF2563EB);
    const lightBlueBg = Color(0xFFEFF6FF);

    return Column(
      children: [
        _buildAppBar(
          title: 'Select Geography',
          showBack: true,
          onBackPressed: () => viewModel.go('planType'),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Text(
                  'Select destination geography for outstation plan:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: inkColor),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (viewModel.isGeographyLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: accColor),
                    );
                  }

                  if (viewModel.geographyHasError.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: errColor, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              viewModel.geographyErrorMessage.value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: inkColor, fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => viewModel.fetchMyGeographies(),
                              style: ElevatedButton.styleFrom(backgroundColor: accColor),
                              child: const Text('Retry', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final list = viewModel.geographies;
                  if (list.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No geographies found.',
                          style: TextStyle(color: muteColor, fontSize: 14),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: list.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return Obx(() {
                        final isSelected = viewModel.selectedGeographyUuid.value == item.effectiveUuid;
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => viewModel.selectGeography(item),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected ? lightBlueBg : surfColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? blueColor : lineColor,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  _buildCustomCheckbox(isSelected),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            color: inkColor,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                        if (item.code != null || item.type != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            [if (item.code != null) 'Code: ${item.code}', if (item.type != null) 'Type: ${item.type}'].join(' · '),
                                            style: const TextStyle(fontSize: 13, color: muteColor),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        Obx(() => _buildFooter(
          buttonText: 'Continue',
          onPressed: viewModel.selectedGeographyUuid.value.isNotEmpty
              ? () => viewModel.continueFromGeography()
              : null,
        )),
      ],
    );
  }

  // --- 3. Second Step: Select Retailers Screen ---
  Widget _buildRetailersScreen(BuildContext context, CreatePlanViewModel viewModel) {
    const blueColor = Color(0xFF2563EB);
    const lightBlueBg = Color(0xFFEFF6FF);

    return Column(
      children: [
        _buildAppBar(
          title: 'Select retailers (${viewModel.planType.value})',
          showBack: true,
          onBackPressed: () => viewModel.go(viewModel.apiPlanType == 'OUTSTATION' ? 'geography' : 'planType'),
        ),
        Expanded(
          child: Column(
            children: [
              // Search Input
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: TextField(
                  onChanged: (val) => viewModel.searchQuery.value = val,
                  decoration: InputDecoration(
                    hintText: 'Search shop name, code or area',
                    prefixIcon: const Icon(Icons.search, color: muteColor),
                    filled: true,
                    fillColor: surfColor,
                    contentPadding: const EdgeInsets.all(11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: lineColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: lineColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: accColor, width: 2),
                    ),
                  ),
                ),
              ),
              // Select All Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Obx(() {
                  final isAllSelected = viewModel.isAllVisibleSelected;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => viewModel.selectAllVisible(!isAllSelected),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isAllSelected ? lightBlueBg : accTColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isAllSelected ? blueColor : Colors.transparent,
                            width: isAllSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildCustomCheckbox(isAllSelected),
                            const SizedBox(width: 12),
                            Text(
                              'Select all (${viewModel.filteredCustomers.length})',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isAllSelected ? blueColor : inkColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              // Customer List with Pagination & State Handling
              Expanded(
                child: Obx(() {
                  if (viewModel.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: accColor),
                    );
                  }

                  if (viewModel.hasError.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: errColor, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              viewModel.errorMessage.value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: inkColor, fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => viewModel.fetchUnplannedCustomers(refresh: true),
                              style: ElevatedButton.styleFrom(backgroundColor: accColor),
                              child: const Text('Retry', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final customers = viewModel.filteredCustomers;
                  if (customers.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No unplanned retailers found.',
                          style: TextStyle(color: muteColor, fontSize: 14),
                        ),
                      ),
                    );
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200) {
                        viewModel.loadNextPage();
                      }
                      return false;
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      itemCount: customers.length + (viewModel.isLoadingMore.value ? 1 : 0),
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (index == customers.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(color: accColor, strokeWidth: 2),
                            ),
                          );
                        }

                        final customer = customers[index];

                        return Obx(() {
                          final isSelected = viewModel.selectedCustomerUuids.contains(customer.uuid);

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => viewModel.toggleCustomerUuid(customer.uuid),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected ? lightBlueBg : surfColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? blueColor : lineColor,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _buildCustomCheckbox(isSelected),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            customer.shopName ?? 'Unknown Retailer',
                                            style: TextStyle(
                                              color: inkColor,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            'Code: ${customer.customerCode ?? 'N/A'}',
                                            style: const TextStyle(fontSize: 13, color: muteColor),
                                          ),
                                          const SizedBox(height: 1),
                                          Text(
                                            ([
                                              if (customer.area != null && customer.area!.isNotEmpty) 'Area: ${customer.area}',
                                              if (customer.city != null && customer.city!.isNotEmpty) 'City: ${customer.city}',
                                            ].isNotEmpty
                                                ? [
                                                    if (customer.area != null && customer.area!.isNotEmpty) 'Area: ${customer.area}',
                                                    if (customer.city != null && customer.city!.isNotEmpty) 'City: ${customer.city}',
                                                  ].join(' · ')
                                                : 'Area: N/A'),
                                            style: const TextStyle(fontSize: 12, color: muteColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        Obx(() => _buildFooter(
          buttonText: 'Add plan (${viewModel.selectedCustomerUuids.length})',
          onPressed: viewModel.selectedCustomerUuids.isNotEmpty
              ? () => viewModel.continueFromRetailers()
              : null,
        )),
      ],
    );
  }

  // --- 4. Third Step: Details Screen ---
  Widget _buildDetailsScreen(BuildContext context, CreatePlanViewModel viewModel) {
    return Column(
      children: [
        _buildAppBar(
          title: '${viewModel.planType.value} plan details',
          showBack: true,
          onBackPressed: () => viewModel.go('retailers'),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: surfColor,
                  border: Border.all(color: lineColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: accTColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        viewModel.planType.value,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: accColor),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(() => Text(
                        '${viewModel.selectedCustomerUuids.length} retailers selected',
                        style: const TextStyle(fontSize: 13, color: muteColor),
                      )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Date fields: Only visible for Outstation plan type.
              // For Local plan, the date was already picked on Step 1 and carried forward.
              Obx(() {
                final isOutstation = viewModel.apiPlanType == 'OUTSTATION';
                if (!isOutstation) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLayout(
                      label: 'From date',
                      error: 'from',
                      viewModel: viewModel,
                      child: Obx(() => _buildDatePicker(
                        context,
                        viewModel.fromDate.value,
                        (val) {
                          viewModel.fromDate.value = val;
                          if (viewModel.toDate.value.isNotEmpty && viewModel.toDate.value.compareTo(val) < 0) {
                            viewModel.toDate.value = val;
                          }
                        },
                      )),
                    ),
                    _buildFieldLayout(
                      label: 'To date',
                      error: 'to',
                      viewModel: viewModel,
                      child: Obx(() => _buildDatePicker(
                        context,
                        viewModel.toDate.value,
                        (val) => viewModel.toDate.value = val,
                        minDate: viewModel.fromDate.value,
                      )),
                    ),
                  ],
                );
              }),

              // Remark Section
              _buildFieldLayout(
                label: 'Remark',
                error: 'remark',
                viewModel: viewModel,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: TextEditingController(text: viewModel.remark.value)..selection = TextSelection.collapsed(offset: viewModel.remark.value.length),
                      onChanged: (val) => viewModel.remark.value = val,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'e.g. Supervisor visit',
                        filled: true,
                        fillColor: surfColor,
                        contentPadding: const EdgeInsets.all(11),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: lineColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: lineColor)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: accColor, width: 2)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: viewModel.remarksList.map((r) {
                        final isSelected = viewModel.remark.value == r;
                        return GestureDetector(
                          onTap: () => viewModel.remark.value = r,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? accColor : Colors.transparent,
                              border: Border.all(color: isSelected ? accColor : lineColor),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              r, 
                              style: TextStyle(
                                fontSize: 13, 
                                color: isSelected ? Colors.white : inkColor,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Obx(() => _buildFooter(
          buttonText: viewModel.isSubmitting.value ? 'Submitting...' : 'Submit for approval',
          onPressed: viewModel.isSubmitting.value ? null : () => viewModel.submit(),
          isLoading: viewModel.isSubmitting.value,
        )),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, String value, Function(String) onChanged, {String? minDate}) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final tomorrow = now.add(const Duration(days: 1));
        final tomorrowDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

        DateTime first = tomorrowDate;
        if (minDate != null && minDate.isNotEmpty) {
          final parsedMin = DateTime.tryParse(minDate) ?? tomorrowDate;
          if (parsedMin.isAfter(tomorrowDate)) {
            first = DateTime(parsedMin.year, parsedMin.month, parsedMin.day);
          }
        }

        final parsedInitial = value.isNotEmpty ? DateTime.tryParse(value) ?? tomorrowDate : tomorrowDate;
        final initialDate = parsedInitial.isBefore(first) ? first : parsedInitial;

        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: first,
          lastDate: DateTime.now().add(const Duration(days: 365)),
          selectableDayPredicate: (DateTime date) {
            final day = DateTime(date.year, date.month, date.day);
            return !day.isBefore(first);
          },
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: accColor,
                  onPrimary: surfColor,
                  onSurface: inkColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          final dateStr = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
          onChanged(dateStr);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: surfColor,
          border: Border.all(color: lineColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value.isEmpty ? 'YYYY-MM-DD' : value,
              style: TextStyle(color: value.isEmpty ? muteColor : inkColor, fontSize: 15),
            ),
            const Icon(Icons.calendar_today_outlined, color: accColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLayout({required String label, required String error, required CreatePlanViewModel viewModel, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 6),
          child,
          Obx(() {
            final errMsg = viewModel.errors[error];
            if (errMsg != null) {
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(errMsg, style: const TextStyle(color: errColor, fontSize: 13)),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  // --- 5. Fourth Step: Done Screen ---
  Widget _buildDoneScreen(CreatePlanViewModel viewModel) {
    final hasVisits = viewModel.myVisits.isNotEmpty;
    final planId = hasVisits ? viewModel.myVisits.first.displayId : 'PLN-SUBMITTED';
    final planType = hasVisits ? viewModel.myVisits.first.planType : viewModel.planType.value;
    final count = hasVisits ? viewModel.myVisits.first.customerCount : viewModel.selectedCustomerUuids.length;
    final when = hasVisits ? viewModel.myVisits.first.when : (viewModel.selectedDate.value.isNotEmpty ? viewModel.selectedDate.value : 'Date N/A');
    final remark = viewModel.remark.value.isNotEmpty ? viewModel.remark.value : 'Visit Plan';

    return Column(
      children: [
        _buildAppBar(title: 'Plan submitted'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: accTColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(child: Text('✓', style: TextStyle(fontSize: 36, color: accColor))),
                    ),
                    const SizedBox(height: 14),
                    const Text('Sent for approval', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: inkColor)),
                    const SizedBox(height: 4),
                    Text('$planId is waiting for your supervisor.', style: const TextStyle(color: muteColor), textAlign: TextAlign.center),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: surfColor,
                  border: Border.all(color: lineColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            planId,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: inkColor),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: warnTColor,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: const Text(
                            'Pending approval',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: warnColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$planType · $count retailers\n$when\nRemark: $remark',
                      style: const TextStyle(fontSize: 13, color: muteColor, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildFooter(
          buttonText: 'Back to my plans',
          onPressed: () => viewModel.reset(),
        ),
      ],
    );
  }

  // --- Shared Components ---
  Widget _buildAppBar({required String title, bool showBack = false, VoidCallback? onBackPressed}) {
    return Container(
      color: accColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: onBackPressed,
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              ),
            ),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildFooter({required String buttonText, VoidCallback? onPressed, bool isLoading = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: surfColor,
        border: Border(top: BorderSide(color: lineColor)),
      ),
      child: _buildButton(text: buttonText, onPressed: onPressed, isLoading: isLoading),
    );
  }

  Widget _buildButton({required String text, VoidCallback? onPressed, bool isGhost = false, bool isLoading = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isGhost ? accTColor : accColor,
          foregroundColor: isGhost ? accColor : surfColor,
          elevation: 0,
          padding: const EdgeInsets.all(13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: accColor.withValues(alpha: 0.4),
          disabledForegroundColor: surfColor,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
