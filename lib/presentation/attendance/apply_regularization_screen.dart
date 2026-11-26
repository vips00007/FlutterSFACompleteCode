import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'apply_regularization_viewmodel.dart';

class ApplyRegularizationScreen extends StatelessWidget {
  const ApplyRegularizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<ApplyRegularizationViewModel>();

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
          children: const [
            Text(
              'Regularize Attendance',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Correct a missed or incorrect entry',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Date
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: Color(0xFF6366F1), size: 24),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selected date', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Obx(() => Text(
                        viewModel.date.value,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Reason
            const Text('Reason', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: viewModel.reason.value,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  items: viewModel.reasonsList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) viewModel.reason.value = newValue;
                  },
                ),
              )),
            ),
            const SizedBox(height: 24),
            
            // Correct Login / Logout
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Correct login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => viewModel.selectLoginTime(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Obx(() => Text(
                            viewModel.correctLogin.value.isEmpty ? 'Select time' : viewModel.correctLogin.value,
                            style: TextStyle(color: viewModel.correctLogin.value.isEmpty ? Colors.grey : Colors.black),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Correct logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => viewModel.selectLogoutTime(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Obx(() => Text(
                            viewModel.correctLogout.value.isEmpty ? 'Select time' : viewModel.correctLogout.value,
                            style: TextStyle(color: viewModel.correctLogout.value.isEmpty ? Colors.grey : Colors.black),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Note
            const Text('Note (optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              onChanged: (val) => viewModel.note.value = val,
              decoration: InputDecoration(
                hintText: 'Add supporting details',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Warning Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED), // Light orange
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: const Text(
                'Your manager will review this correction. Submitted details cannot be edited.',
                style: TextStyle(color: Color(0xFF9A3412), fontSize: 14),
              ),
            ),
            const SizedBox(height: 32),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                onPressed: viewModel.isLoading.value ? null : () => viewModel.submitRequest(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF555ABC),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: viewModel.isLoading.value
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text(
                        'Submit Request',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
