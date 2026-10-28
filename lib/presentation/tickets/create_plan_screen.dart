import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import 'create_plan_viewmodel.dart';

class CreatePlanScreen extends StatelessWidget {
  const CreatePlanScreen({super.key});

  // Colors based on the existing app theme
  static const Color bgColor = AppColors.background;
  static const Color surfColor = Colors.white;
  static const Color inkColor = AppColors.textPrimary;
  static const Color muteColor = AppColors.textSecondary;
  static const Color lineColor = Color(0xFFE0E0E0); // Colors.grey.shade300 equivalent
  static const Color accColor = AppColors.primaryPurple;
  static const Color accTColor = Color(0x1A8A2BE2); // primaryPurple with 0.1 alpha
  static const Color warnColor = Color(0xFFEF6C00); // Colors.orange.shade800 equivalent
  static const Color warnTColor = Color(0xFFFFF3E0); // Colors.orange.shade50 equivalent
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

  // --- 1. List Screen ---
  Widget _buildListScreen(CreatePlanViewModel viewModel) {
    return Column(
      children: [
        _buildAppBar(title: 'My plans', showBack: true, onBackPressed: () => Get.back()),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: viewModel.plans.length,
            itemBuilder: (context, index) {
              final plan = viewModel.plans[index];
              return _buildPlanCard(plan);
            },
          ),
        ),
        _buildFooter(
          buttonText: '+ Create plan',
          onPressed: () => viewModel.go('retailers'),
        ),
      ],
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final isApproved = plan['status'] == 'Approved';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
                  plan['id'],
                  style: const TextStyle(fontWeight: FontWeight.w600, color: inkColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: isApproved ? accTColor : warnTColor,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  plan['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isApproved ? accColor : warnColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${plan['type']} · ${plan['n']} retailers · ${plan['when']}',
            style: const TextStyle(fontSize: 13, color: muteColor),
          ),
        ],
      ),
    );
  }

  // --- 2. Retailers Screen ---
  Widget _buildRetailersScreen(BuildContext context, CreatePlanViewModel viewModel) {
    return Column(
      children: [
        _buildAppBar(
          title: 'Select retailers',
          showBack: true,
          onBackPressed: () => viewModel.go('list'),
        ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: TextField(
                  onChanged: (val) => viewModel.searchQuery.value = val,
                  decoration: InputDecoration(
                    hintText: 'Search retailer or area',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: accTColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CheckboxListTile(
                    value: viewModel.isAllSelected,
                    onChanged: (val) => viewModel.selectAll(val ?? false),
                    title: Obx(() => Text(
                      'Select all (${viewModel.filteredIndices.length})',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: inkColor),
                    )),
                    activeColor: accColor,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    dense: true,
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  final indices = viewModel.filteredIndices;
                  if (indices.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(14),
                      child: Text('No retailers match your search.', style: TextStyle(color: muteColor)),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: indices.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: lineColor),
                    itemBuilder: (context, index) {
                      final rIndex = indices[index];
                      final r = viewModel.retailersList[rIndex];
                      return CheckboxListTile(
                        value: viewModel.selectedRetailers.contains(rIndex),
                        onChanged: (val) => viewModel.toggleRetailer(rIndex),
                        title: Text(r[0], style: const TextStyle(color: inkColor)),
                        subtitle: Text('${r[1]}, ${r[2]}', style: const TextStyle(fontSize: 13, color: muteColor)),
                        activeColor: accColor,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        Obx(() => _buildFooter(
          buttonText: 'Add plan (${viewModel.selectedRetailers.length})',
          onPressed: viewModel.selectedRetailers.isNotEmpty
              ? () => _showTypeBottomSheet(context, viewModel)
              : null,
        )),
      ],
    );
  }

  void _showTypeBottomSheet(BuildContext context, CreatePlanViewModel viewModel) {
    viewModel.planType.value = ''; // Reset on open
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: surfColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose plan type', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: inkColor)),
            const SizedBox(height: 4),
            Obx(() => Text(
              '${viewModel.selectedRetailers.length} retailer${viewModel.selectedRetailers.length > 1 ? 's' : ''} selected',
              style: const TextStyle(color: muteColor),
            )),
            const SizedBox(height: 16),
            _buildTypeOption(viewModel, 'Local', '🏙️', 'Same-day visits within your area'),
            const SizedBox(height: 10),
            _buildTypeOption(viewModel, 'Upcountry', '🚆', 'Outstation visits, multi-day'),
            const SizedBox(height: 16),
            Obx(() => _buildButton(
              text: 'Continue',
              onPressed: viewModel.planType.value.isNotEmpty ? () => viewModel.continueFromTypeSheet() : null,
            )),
            const SizedBox(height: 8),
            _buildButton(
              text: 'Cancel',
              isGhost: true,
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildTypeOption(CreatePlanViewModel viewModel, String type, String emoji, String subtitle) {
    return Obx(() {
      final isSelected = viewModel.planType.value == type;
      return GestureDetector(
        onTap: () => viewModel.setPlanType(type),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? accTColor : Colors.transparent,
            border: Border.all(
              color: isSelected ? accColor : lineColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type, style: const TextStyle(fontWeight: FontWeight.bold, color: inkColor)),
                    Text(subtitle, style: const TextStyle(fontSize: 13, color: muteColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // --- 3. Details Screen ---
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
                        '${viewModel.selectedRetailers.length} retailers selected',
                        style: const TextStyle(fontSize: 13, color: muteColor),
                      )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              _buildFieldLayout(
                label: 'From date',
                error: 'from',
                viewModel: viewModel,
                child: _buildDatePicker(
                  context,
                  viewModel.fromDate.value,
                  (val) {
                    viewModel.fromDate.value = val;
                    if (viewModel.toDate.value.isNotEmpty && viewModel.toDate.value.compareTo(val) < 0) {
                      viewModel.toDate.value = val;
                    }
                  },
                ),
              ),
              
              _buildFieldLayout(
                label: 'To date',
                error: 'to',
                viewModel: viewModel,
                child: _buildDatePicker(
                  context,
                  viewModel.toDate.value,
                  (val) => viewModel.toDate.value = val,
                  minDate: viewModel.fromDate.value,
                ),
              ),

              _buildFieldLayout(
                label: 'Plan by',
                error: 'place',
                viewModel: viewModel,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Obx(() => Row(
                        children: ['Territory', 'City'].map((m) {
                          final isSelected = viewModel.mode.value == m;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => viewModel.setMode(m),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected ? accColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: isSelected ? [const BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))] : null,
                                ),
                                child: Text(
                                  m,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : muteColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                    ),
                    Obx(() {
                      final items = viewModel.mode.value == 'Territory' ? viewModel.territoryList : viewModel.cityList;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        decoration: BoxDecoration(
                          color: surfColor,
                          border: Border.all(color: lineColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: viewModel.selectedPlace.value.isEmpty ? null : viewModel.selectedPlace.value,
                            hint: Text('Select ${viewModel.mode.value.toLowerCase()}'),
                            isExpanded: true,
                            items: items.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                            onChanged: (val) => viewModel.selectedPlace.value = val ?? '',
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

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
                              )
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
        _buildFooter(
          buttonText: 'Submit for approval',
          onPressed: () => viewModel.submit(),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, String value, Function(String) onChanged, {String? minDate}) {
    return GestureDetector(
      onTap: () async {
        final initial = value.isNotEmpty ? DateTime.parse(value) : DateTime.now();
        final first = minDate != null && minDate.isNotEmpty ? DateTime.parse(minDate) : DateTime.now().subtract(const Duration(days: 365));
        final picked = await showDatePicker(
          context: context,
          initialDate: initial.isBefore(first) ? first : initial,
          firstDate: first,
          lastDate: DateTime.now().add(const Duration(days: 365)),
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
          // Format as YYYY-MM-DD
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
            Icon(Icons.calendar_today_outlined, color: accColor, size: 20),
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

  // --- 4. Done Screen ---
  Widget _buildDoneScreen(CreatePlanViewModel viewModel) {
    final x = viewModel.plans.first;
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
                    Text('${x['id']} is waiting for your supervisor.', style: const TextStyle(color: muteColor), textAlign: TextAlign.center),
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
                            x['id'],
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
                      '${x['type']} · ${x['n']} retailers\n${x['when']}\n${x['place']}\nRemark: ${x['remark']}',
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

  Widget _buildFooter({required String buttonText, VoidCallback? onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: surfColor,
        border: Border(top: BorderSide(color: lineColor)),
      ),
      child: _buildButton(text: buttonText, onPressed: onPressed),
    );
  }

  Widget _buildButton({required String text, VoidCallback? onPressed, bool isGhost = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isGhost ? accTColor : accColor,
          foregroundColor: isGhost ? accColor : surfColor,
          elevation: 0,
          padding: const EdgeInsets.all(13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: accColor.withValues(alpha: 0.4),
          disabledForegroundColor: surfColor,
        ),
        child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
