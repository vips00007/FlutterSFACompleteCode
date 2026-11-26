import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'regularization_request_status_viewmodel.dart';

class RegularizationRequestStatusScreen extends StatelessWidget {
  const RegularizationRequestStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<RegularizationRequestStatusViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Request Status',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Obx(() {
        if (viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (viewModel.errorMessage.isNotEmpty) {
          return Center(child: Text(viewModel.errorMessage.value, style: const TextStyle(color: Colors.red)));
        }

        final data = viewModel.statusData.value;
        if (data == null) {
          return const Center(child: Text('No data found'));
        }

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              
              // Icon and Status Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7ED),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.access_time, color: Colors.orange, size: 48),
              ),
              const SizedBox(height: 24),
              const Text(
                'Request Submitted',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your regularization is awaiting manager review.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  data.status,
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              
              const SizedBox(height: 32),
              
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
                  children: [
                    _buildDetailRow('Request ID', data.requestId),
                    const Divider(height: 32, color: Color(0xFFF0F0F0)),
                    _buildDetailRow('Attendance date', data.attendanceDate),
                    const Divider(height: 32, color: Color(0xFFF0F0F0)),
                    _buildDetailRow('Corrected time', data.correctedTime),
                    const Divider(height: 32, color: Color(0xFFF0F0F0)),
                    _buildDetailRow('Reason', data.reason),
                    const Divider(height: 32, color: Color(0xFFF0F0F0)),
                    _buildDetailRow('Approver', data.approverName),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Done Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => viewModel.done(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF555ABC),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
