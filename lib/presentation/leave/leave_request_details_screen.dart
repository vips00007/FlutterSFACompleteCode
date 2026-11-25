import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'leave_request_details_viewmodel.dart';

class LeaveRequestDetailsScreen extends StatelessWidget {
  const LeaveRequestDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<LeaveRequestDetailsViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apply Leave', // Text from screenshot, although 'Leave Request' is better
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Obx(() => Text(
              viewModel.leaveItem.value?.id ?? '',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            )),
          ],
        ),
      ),
      body: Obx(() {
        final item = viewModel.leaveItem.value;
        if (item == null) return const Center(child: Text('No data'));

        Color statusColor = Colors.green;
        Color statusBg = const Color(0xFFECFDF5);
        if (item.status.toLowerCase() == 'pending') {
          statusColor = Colors.orange;
          statusBg = const Color(0xFFFFF7ED);
        } else if (item.status.toLowerCase() == 'rejected' || item.status.toLowerCase() == 'cancelled') {
          statusColor = Colors.purple; // According to cancelled screenshot
          statusBg = const Color(0xFFF3E8FF);
          if(item.status.toLowerCase() == 'rejected') {
            statusColor = Colors.red;
            statusBg = const Color(0xFFFEF2F2);
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Details Card
              Container(
                padding: const EdgeInsets.all(24),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.leaveType, style: const TextStyle(color: Colors.grey, fontSize: 14)),
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
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(item.dateRange, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(item.duration, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFF0F0F0)),
                    const SizedBox(height: 24),
                    
                    _buildDetailRow('Applied on', item.appliedOn),
                    const SizedBox(height: 24),
                    _buildDetailRow('Reason', item.reason),
                    const SizedBox(height: 24),
                    _buildDetailRow('Reporting manager', item.reportingManager),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Timeline Card
              Container(
                padding: const EdgeInsets.all(24),
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
                    const Text('Request timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 24),
                    
                    if (item.submittedAt != null) ...[
                      _buildTimelineItem(
                        icon: Icons.check,
                        iconColor: Colors.green,
                        iconBg: const Color(0xFFECFDF5),
                        title: 'Request submitted',
                        subtitle: item.submittedAt!,
                        isLast: item.status.toLowerCase() == 'pending' ? false : (item.status.toLowerCase() == 'cancelled' ? false : true), // Simplified line drawing logic
                      ),
                    ],
                    
                    if (item.status.toLowerCase() == 'pending') ...[
                      _buildTimelineItem(
                        icon: Icons.access_time,
                        iconColor: Colors.orange,
                        iconBg: const Color(0xFFFFF7ED),
                        title: 'Awaiting approval',
                        subtitle: '${item.reportingManager} will review your request',
                        isLast: true,
                      ),
                    ],

                    if (item.status.toLowerCase() == 'cancelled' && item.cancelledAt != null) ...[
                      _buildTimelineItem(
                        icon: Icons.close,
                        iconColor: Colors.grey,
                        iconBg: const Color(0xFFF3F4F6),
                        title: 'Request cancelled',
                        subtitle: item.cancelledAt!,
                        isLast: true,
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Cancel Button (only if pending)
              if (item.status.toLowerCase() == 'pending')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showCancelBottomSheet(context, viewModel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEF2F2),
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Cancel Leave Request',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value, 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              if (!isLast) const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  void _showCancelBottomSheet(BuildContext context, LeaveRequestDetailsViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
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
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Cancel leave?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            const Text(
              'This request will be withdrawn and your leave balance will be restored.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text('Keep Request', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => viewModel.cancelLeave(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEF2F2),
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Cancel Leave', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
