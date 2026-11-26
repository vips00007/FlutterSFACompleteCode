import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'leave_dashboard_viewmodel.dart';

class LeaveDashboardScreen extends StatelessWidget {
  const LeaveDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<LeaveDashboardViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Leave',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              '22 September 2026',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.group_outlined, color: Color(0xFF555ABC), size: 24),
          ),
        ],
      ),
      body: Obx(() {
        if (viewModel.isLoading.value && viewModel.balance.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final bal = viewModel.balance.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Total Balance Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF17193F), Color(0xFF555ABC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total available balance',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                bal?.totalAvailable.toString() ?? '0',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'days',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => viewModel.goToApplyLeave(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF555ABC),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Apply Leave', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // 2. Leave Balance Breakdowns
              const Text('Leave balance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildBalanceCard(
                      abbr: 'CL',
                      color: const Color(0xFFEEF2FF),
                      textColor: const Color(0xFF6366F1),
                      title: 'Casual Leave',
                      available: bal?.clAvailable ?? 0,
                      total: bal?.clTotal ?? 0,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBalanceCard(
                      abbr: 'SL',
                      color: const Color(0xFFECFDF5),
                      textColor: const Color(0xFF10B981),
                      title: 'Sick Leave',
                      available: bal?.slAvailable ?? 0,
                      total: bal?.slTotal ?? 0,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBalanceCard(
                      abbr: 'EL',
                      color: const Color(0xFFF0F9FF),
                      textColor: const Color(0xFF0EA5E9),
                      title: 'Earned Leave',
                      available: bal?.elAvailable ?? 0,
                      total: bal?.elTotal ?? 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // 3. Manager Tools
              const Text('Manager tools', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.people_outline, color: Colors.orange),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Leave Approvals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text('${viewModel.pendingApprovals.value} requests awaiting your review', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${viewModel.pendingApprovals.value}',
                        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // 4. Leave History
              const Text('Leave history', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.history.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = viewModel.history[index];
                  Color statusColor = Colors.green;
                  Color statusBg = const Color(0xFFECFDF5);
                  if (item.status.toLowerCase() == 'pending') {
                    statusColor = Colors.orange;
                    statusBg = const Color(0xFFFFF7ED);
                  } else if (item.status.toLowerCase() == 'rejected' || item.status.toLowerCase() == 'cancelled') {
                    statusColor = Colors.red;
                    statusBg = const Color(0xFFFEF2F2);
                  }

                  return GestureDetector(
                    onTap: () => viewModel.goToRequestDetails(item),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.leaveType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(item.dateRange, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.status,
                              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBalanceCard({
    required String abbr,
    required Color color,
    required Color textColor,
    required String title,
    required int available,
    required int total,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              abbr,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            available.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'of $total days',
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
