import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'attendance_regularization_viewmodel.dart';

class AttendanceRegularizationScreen extends StatelessWidget {
  const AttendanceRegularizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<AttendanceRegularizationViewModel>();

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Attendance',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Obx(() => Text(
              viewModel.date.value,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(20),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Day status', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 4),
                          Obx(() => Text(
                            viewModel.status.value,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Obx(() => Text(
                          viewModel.status.value.toLowerCase(),
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Login', style: TextStyle(color: Colors.grey, fontSize: 10)),
                              const SizedBox(height: 4),
                              Obx(() => Text(
                                viewModel.loginTime.value,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              )),
                              const SizedBox(height: 4),
                              Obx(() => Text(
                                viewModel.loginLocation.value,
                                style: const TextStyle(color: Colors.grey, fontSize: 10),
                              )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Logout', style: TextStyle(color: Colors.grey, fontSize: 10)),
                              const SizedBox(height: 4),
                              Obx(() => Text(
                                viewModel.logoutTime.value,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              )),
                              const SizedBox(height: 4),
                              Obx(() => Text(
                                viewModel.logoutLocation.value,
                                style: const TextStyle(color: Colors.grey, fontSize: 10),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total work hours', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Obx(() => Text(
                        viewModel.totalWorkHours.value,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Verification Details Card
            Container(
              padding: const EdgeInsets.all(20),
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
                  const Text('Verification details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 20),
                  _buildVerificationItem(
                    icon: Icons.location_on_outlined,
                    title: 'Location verified',
                    subtitle: 'GPS accuracy: 12 metres',
                  ),
                  const SizedBox(height: 20),
                  _buildVerificationItem(
                    icon: Icons.camera_alt_outlined,
                    title: 'Selfie verified',
                    subtitle: 'Face match successful',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Regularize Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => viewModel.regularize(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: const Text(
                  'Regularize Attendance',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationItem({required IconData icon, required String title, required String subtitle}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF555ABC), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        const Icon(Icons.check_circle_outline, color: Colors.green, size: 24),
      ],
    );
  }
}
