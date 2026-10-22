import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import '../../routes/route_names.dart';
import 'tickets_viewmodel.dart';
import 'widgets/ticket_card.dart';
import 'widgets/empty_state_widget.dart';
import '../check_in/widgets/outside_radius_bottom_sheet.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<TicketsViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.textPrimary,
              size: 16,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Visits',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Beat plan and journey approval',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Obx(() => GestureDetector(
                onTap: () => viewModel.changeTab(
                    viewModel.selectedTabIndex.value == 0 ? 1 : 0),
                child: Container(
                  margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    viewModel.selectedTabIndex.value == 0
                        ? 'Planned'
                        : 'Unplanned',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade200,
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar & Filter Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primaryPurple.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search name, area or owner',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary
                                .withValues(alpha: 0.7),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryPurple.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
            ),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildNewFilterChip('All', isSelected: true, isOutline: true),
                  _buildNewFilterChip('FR', isSelected: true, isOutline: false),
                  _buildNewFilterChip('A-Z'),
                  _buildNewFilterChip('L3M'),
                  _buildNewFilterChip('MTD'),
                  _buildNewFilterChip('BL'),
                  _buildNewFilterChip('UN'),
                  _buildNewFilterChip('IN'),
                ],
              ),
            ),

            // List Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Business Partner',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Saturday, 12 September',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: Obx(() {
                if (viewModel.state.value == TicketsState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tickets = viewModel.selectedTabIndex.value == 0
                    ? viewModel.plannedTickets
                    : viewModel.unplannedTickets;

                if (tickets.isEmpty) {
                  return const EmptyStateWidget(message: 'No results found');
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    VoidCallback? onCheckIn;
                    
                    if (viewModel.selectedTabIndex.value == 1) {
                      // Logic for Unplanned list (Index 1)
                      if (index == 0) {
                        onCheckIn = () {
                          Get.toNamed(RoutesName.visit_check_in_view,
                              arguments: tickets[index]);
                        };
                      } else if (index == 1) {
                        onCheckIn = () {
                          Get.bottomSheet(
                            OutsideRadiusBottomSheet(
                                outlet: tickets[index], isInside: false),
                            isScrollControlled: true,
                          );
                        };
                      } else if (index == 2) {
                        onCheckIn = () {
                          Get.bottomSheet(
                            OutsideRadiusBottomSheet(
                                outlet: tickets[index], isInside: true),
                            isScrollControlled: true,
                          );
                        };
                      }
                    }

                    return TicketCard(
                      outlet: tickets[index],
                      onCheckIn: onCheckIn,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewFilterChip(String label,
      {bool isSelected = false, bool isOutline = false}) {
    Color bgColor;
    Color textColor;
    Color borderColor = Colors.transparent;

    if (isOutline) {
      bgColor = Colors.white;
      textColor = AppColors.primaryPurple;
      borderColor = AppColors.primaryPurple;
    } else if (isSelected) {
      bgColor = AppColors.primaryPurple;
      textColor = Colors.white;
    } else {
      bgColor = const Color(0xFFF3E8FF); // light purple
      textColor = AppColors.primaryPurple;
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
