import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/colors/app_colors.dart';
import '../../../domain/entities/outlet.dart';
import 'review_plan_viewmodel.dart';

class ReviewPlanScreen extends StatelessWidget {
  const ReviewPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<ReviewPlanViewModel>();

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
          'Review Plan',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.primaryPurple.withOpacity(0.1), height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      _buildStepper(),
                      const SizedBox(height: 24),
                      _buildDateHeader(),
                      const SizedBox(height: 16),
                      _buildMetricsCard(viewModel),
                      const SizedBox(height: 16),
                      _buildCapacityBar(viewModel),
                    ],
                  ),
                ),
                Obx(() {
                  if (viewModel.isOverloaded) {
                    return _buildWarningBox();
                  }
                  return const SizedBox.shrink();
                }),
                _buildCustomerList(viewModel),
              ],
            ),
          ),
          _buildBottomActions(viewModel),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 15,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(child: Container(height: 2, color: Colors.green)),
                Expanded(child: Container(height: 2, color: Colors.grey.shade300)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStep(1, 'Select', true, isCompleted: true),
              _buildStep(2, 'Review', true, isCompleted: false),
              _buildStep(3, 'Done', false, isCompleted: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String label, bool isActive, {bool isCompleted = false}) {
    Color color = Colors.grey.shade400;
    if (isCompleted) color = Colors.green;
    else if (isActive) color = AppColors.primaryPurple;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: isCompleted 
                ? const Icon(Icons.check, color: Colors.green, size: 18)
                : Text(
                    '$number',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lightBlueBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.calendar_today_outlined, color: AppColors.primaryPurple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Friday, 16 Oct 2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 2),
                Text('Tap to add objective', style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildMetricsCard(ReviewPlanViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE8F0FE), Color(0xFFF1F5F9)], // Light blue to light grey
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.store_outlined, color: AppColors.primaryPurple, size: 20),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${viewModel.customers.length}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('customers', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 30, color: Colors.grey.shade300),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.route_outlined, color: AppColors.primaryPurple, size: 20),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('~${viewModel.totalDistance.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('km', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 30, color: Colors.grey.shade300),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.access_time_outlined, color: AppColors.primaryPurple, size: 20),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('~${viewModel.totalHours.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('hours', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCapacityBar(ReviewPlanViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        final isOverloaded = viewModel.isOverloaded;
        final color = isOverloaded ? Colors.red : Colors.green;
        final title = isOverloaded ? 'Overloaded' : 'Good';
        final subTitle = isOverloaded 
            ? 'Too much for one day -...' 
            : '${(9.0 - viewModel.totalHours).toStringAsFixed(1)}h still free';

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    children: [
                      const TextSpan(text: 'Day Capacity ', style: TextStyle(color: AppColors.textPrimary)),
                      TextSpan(text: title, style: TextStyle(color: color)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: '~${viewModel.totalHours.toStringAsFixed(1)}h', style: TextStyle(color: color)),
                      const TextSpan(text: ' / 9h', style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress Bar
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(3),
              ),
              child: isOverloaded 
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    )
                  : FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: viewModel.totalHours / 9.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${viewModel.visitHours.toStringAsFixed(1)}h visits · ${viewModel.travelHours.toStringAsFixed(1)}h travel · ',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  subTitle,
                  style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7E0), // Light Yellow/Orange
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Long-distance plan (1472 km)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFB06000)),
                ),
                SizedBox(height: 4),
                Text(
                  'Exceeds typical single-day driving. You can still proceed (e.g., flight or multi-day trip).',
                  style: TextStyle(fontSize: 13, color: Color(0xFFB06000), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList(ReviewPlanViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Start Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: const BoxDecoration(color: Color(0xFF1E293B), shape: BoxShape.circle),
                    child: const Icon(Icons.home, color: Colors.white, size: 16),
                  ),
                  Container(height: 20, width: 2, color: Colors.grey.shade300),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 4),
                    Text('Start from your location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 2),
                    Text('Advisory — visit in any order that works for you', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          
          // Customer Items
          Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.customers.length,
            itemBuilder: (context, index) {
              final outlet = viewModel.customers[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: const BoxDecoration(color: AppColors.primaryPurple, shape: BoxShape.circle),
                        child: Center(child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ),
                      if (index < viewModel.customers.length - 1 || !viewModel.isOverloaded)
                        Container(height: 70, width: 2, color: Colors.grey.shade300),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      outlet.firstName,
                                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: AppColors.textPrimary),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Text(' · ', style: TextStyle(color: AppColors.textSecondary)),
                                  const Icon(Icons.phone_outlined, size: 12, color: AppColors.textSecondary),
                                  const SizedBox(width: 2),
                                  Text(outlet.mobileNumber, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  const SizedBox(width: 20), // space for close icon
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('${outlet.city}, ${outlet.state}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(outlet.customerType, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          Positioned(
                            right: 0, top: 0,
                            child: GestureDetector(
                              onTap: () => viewModel.removeCustomer(outlet),
                              child: const Icon(Icons.close, size: 16, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          )),

          // End of day (if Good capacity)
          Obx(() {
            if (!viewModel.isOverloaded) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: const BoxDecoration(color: Color(0xFF1E293B), shape: BoxShape.circle),
                    child: const Icon(Icons.flag, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 4),
                      Text('End of Day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('Return to base', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBottomActions(ReviewPlanViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildActionBtn(
                    onPressed: () {},
                    icon: Icons.auto_awesome,
                    label: 'Add from AI',
                    bgColor: AppColors.lightBlueBackground,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildActionBtn(
                    onPressed: viewModel.addMoreCustomers,
                    icon: Icons.add,
                    label: 'Add Customer',
                    bgColor: Colors.white,
                  ),
                ),
                if (viewModel.isOverloaded) ...[
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildActionBtn(
                      onPressed: viewModel.optimizePlan,
                      icon: Icons.call_split,
                      label: 'Optimize',
                      bgColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: viewModel.createPlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Create Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActionBtn({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color bgColor,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          maxLines: 1,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryPurple,
        backgroundColor: bgColor,
        side: const BorderSide(color: AppColors.lightBlueBackground),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        minimumSize: const Size(0, 36),
      ),
    );
  }
}
