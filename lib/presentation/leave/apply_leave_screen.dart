import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'apply_leave_viewmodel.dart';

class ApplyLeaveScreen extends StatelessWidget {
  const ApplyLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<ApplyLeaveViewModel>();

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
              'Apply Leave',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'New leave request',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Type
            const Text('Leave type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: viewModel.leaveType.value,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  items: viewModel.leaveTypes.map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) viewModel.leaveType.value = newValue;
                  },
                ),
              )),
            ),
            const SizedBox(height: 16),
            
            // Dates
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('From date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => viewModel.selectFromDate(context),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => Text(
                                viewModel.fromDate.value == null 
                                    ? 'Select' 
                                    : DateFormat('dd MMM yyyy').format(viewModel.fromDate.value!),
                                style: TextStyle(color: viewModel.fromDate.value == null ? Colors.grey : Colors.black, fontSize: 14),
                              )),
                              const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('To date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => viewModel.selectToDate(context),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => Text(
                                viewModel.toDate.value == null 
                                    ? 'Select' 
                                    : DateFormat('dd MMM yyyy').format(viewModel.toDate.value!),
                                style: TextStyle(color: viewModel.toDate.value == null ? Colors.grey : Colors.black, fontSize: 14),
                              )),
                              const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Duration
            const Text('Duration', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildDurationOption(viewModel, 'Full Day')),
                const SizedBox(width: 8),
                Expanded(child: _buildDurationOption(viewModel, 'First Half')),
                const SizedBox(width: 8),
                Expanded(child: _buildDurationOption(viewModel, 'Second Half')),
              ],
            ),
            const SizedBox(height: 16),
            
            // Reason
            const Text('Reason', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              onChanged: (val) => viewModel.reason.value = val,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Attachment
            const Text('Attachment (optional)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                if (viewModel.attachmentName.value.isEmpty) {
                  viewModel.pickAttachment();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFC7D2FE), width: 1, style: BorderStyle.solid),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.description_outlined, color: Colors.grey, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                            viewModel.attachmentName.value.isEmpty ? 'Upload document' : viewModel.attachmentName.value,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          const SizedBox(height: 2),
                          Obx(() => Text(
                            viewModel.attachmentName.value.isEmpty 
                                ? 'PDF, JPG or PNG · Max 5 MB' 
                                : viewModel.attachmentSize.value,
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                          )),
                        ],
                      ),
                    ),
                    Obx(() => viewModel.attachmentName.value.isEmpty 
                      ? const Icon(Icons.add, color: Color(0xFF555ABC), size: 20)
                      : GestureDetector(
                          onTap: () => viewModel.removeAttachment(),
                          child: const Icon(Icons.close, color: Colors.red, size: 20),
                        ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Requested', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                          viewModel.requestedDurationString.isEmpty ? '—' : viewModel.requestedDurationString,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Balance after', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      const Text(
                        '3 days',
                        style: TextStyle(color: Color(0xFF555ABC), fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                onPressed: viewModel.isLoading.value ? null : () => viewModel.submit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF555ABC),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: viewModel.isLoading.value
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text(
                        'Submit Leave Request',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
              )),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationOption(ApplyLeaveViewModel viewModel, String label) {
    return GestureDetector(
      onTap: () => viewModel.duration.value = label,
      child: Obx(() {
        final isSelected = viewModel.duration.value == label;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? const Color(0xFF555ABC) : Colors.grey.shade300),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF555ABC) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        );
      }),
    );
  }
}
