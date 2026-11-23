import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/route_names.dart';
import '../dashboard/dashboard_viewmodel.dart';
import 'tickets_viewmodel.dart';
import 'widgets/ticket_card.dart';
import 'widgets/empty_state_widget.dart';
import '../check_in/widgets/outside_radius_bottom_sheet.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  // Color constants matching Add Outlet screen & prototype redesign
  static const Color blueColor = Color(0xFF6A3FD6);
  static const Color blue50Color = Color(0xFFF0EBFC);
  static const Color blue100Color = Color(0xFFD6C8F8);
  static const Color inkColor = Color(0xFF17193F);
  static const Color slateColor = Color(0xFF6B6F93);
  static const Color lineColor = Color(0xFFDCDBEA);
  static const Color bgColor = Color(0xFFF4F3F9);

  void _handleBackNavigation(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else if (Get.isRegistered<DashboardViewModel>()) {
      Get.find<DashboardViewModel>().changeTabIndex(0);
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<TicketsViewModel>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation(context);
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Matching Add Outlet header design & prototype)
              Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                constraints: const BoxConstraints(minHeight: 60),
                decoration: BoxDecoration(
                  color: blueColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: blueColor.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
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
                      onPressed: () => _handleBackNavigation(context),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Visit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(RoutesName.create_plan_view),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: blueColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
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

              // 2. Custom Segmented Pill Tab Bar (.seg) - Compact & Overflow Free
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: blue50Color,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: blue100Color, width: 1),
                  ),
                  child: Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: _buildSegTab(
                            title: 'Planned',
                            badge: '${viewModel.plannedTickets.length}/0 visited',
                            isSelected: viewModel.selectedTabIndex.value == 0,
                            onTap: () => viewModel.changeTab(0),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: _buildSegTab(
                            title: 'Unplanned',
                            badge: '${viewModel.unplannedTickets.length} customers',
                            isSelected: viewModel.selectedTabIndex.value == 1,
                            onTap: () => viewModel.changeTab(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Search Bar & Filter Button (.sr)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: lineColor),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: slateColor, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child:TextField(
                                controller: viewModel.searchController,
                                onChanged: viewModel.onSearchQueryChanged,
                                style: const TextStyle(fontSize: 14.5, color: inkColor),
                                decoration: const InputDecoration(
                                  hintText: 'Search by name, city or owner',
                                  hintStyle: TextStyle(color: slateColor, fontSize: 14.5),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            Obx(() => viewModel.searchQuery.value.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 20, color: slateColor),
                                    onPressed: viewModel.clearSearch,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  )
                                : const SizedBox.shrink()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: blue50Color,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.tune,
                        color: blueColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Filter Chips Row (.chips) - Default 'All' selected and functional
              Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: viewModel.filterChips.map((chipLabel) {
                    final isSelected = viewModel.selectedChip.value == chipLabel;
                    return _buildNewFilterChip(
                      viewModel: viewModel,
                      label: chipLabel,
                      isSelected: isSelected,
                    );
                  }).toList(),
                ),
              )),

              // 5. Section Header (.sec)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Business Partner',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: inkColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 3),

                  ],
                ),
              ),

              // 6. Content Cards List Area
              Expanded(
                child: Obx(() {
                  if (viewModel.state.value == TicketsState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(color: blueColor),
                    );
                  }

                  if (viewModel.state.value == TicketsState.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Failed to load visit data',
                            style: TextStyle(color: slateColor, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: viewModel.fetchTickets,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blueColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Retry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  }

                  final isPlannedTab = viewModel.selectedTabIndex.value == 0;
                  final tickets = isPlannedTab
                      ? viewModel.plannedTickets
                      : viewModel.unplannedTickets;

                  if (tickets.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: viewModel.fetchTickets,
                      color: blueColor,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 80),
                          EmptyStateWidget(
                            message: isPlannedTab
                                ? 'No planned visits for today'
                                : 'No unplanned customers found',
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: viewModel.fetchTickets,
                    color: blueColor,
                    child: ListView.builder(
                      controller: viewModel.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: tickets.length + (viewModel.isLoadingMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == tickets.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(color: blueColor, strokeWidth: 2),
                            ),
                          );
                        }

                        VoidCallback? onCheckIn;

                        if (viewModel.selectedTabIndex.value == 1) {
                          if (index == 0) {
                            onCheckIn = () {
                              Get.toNamed(RoutesName.visit_check_in_view, arguments: tickets[index]);
                            };
                          } else if (index == 1) {
                            onCheckIn = () {
                              Get.bottomSheet(
                                OutsideRadiusBottomSheet(outlet: tickets[index], isInside: false),
                                isScrollControlled: true,
                              );
                            };
                          } else if (index == 2) {
                            onCheckIn = () {
                              Get.bottomSheet(
                                OutsideRadiusBottomSheet(outlet: tickets[index], isInside: true),
                                isScrollControlled: true,
                              );
                            };
                          } else {
                            onCheckIn = () {
                              Get.toNamed(RoutesName.visit_check_in_view, arguments: tickets[index]);
                            };
                          }
                        }

                        return TicketCard(
                          outlet: tickets[index],
                          onCheckIn: onCheckIn,
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Segmented Control Tab Item Helper (Responsive & Overflow Free)
  Widget _buildSegTab({
    required String title,
    required String badge,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? blueColor : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: blueColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : slateColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.22)
                    : blue100Color,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: isSelected ? Colors.white : blueColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter Chip Helper
  Widget _buildNewFilterChip({
    required TicketsViewModel viewModel,
    required String label,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => viewModel.selectChip(label),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? blueColor : blue50Color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: blueColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : blueColor,
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
        ),
      ),
    );
  }
}
