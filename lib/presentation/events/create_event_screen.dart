import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import 'create_event_viewmodel.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<CreateEventViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Create Event',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.sfaBlue, height: 2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Date
            _buildField(
              label: 'Event Date',
              hint: 'Event Date',
              suffixIcon: Icons.calendar_month_outlined,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) viewModel.setDate(date);
              },
              controller: TextEditingController(text: viewModel.formattedDate),
              readOnly: true,
            ),
            const SizedBox(height: 16),

            // Event Type
            _buildField(
              label: 'Event Type',
              hint: 'Event Type',
              suffixIcon: Icons.keyboard_arrow_down,
            ),
            const SizedBox(height: 16),

            // Search Partner
            _buildField(
              label: 'Search partner / customer...',
              hint: 'Search partner / customer...',
            ),
            const SizedBox(height: 16),

            // Venue
            _buildField(label: 'Venue', hint: 'Venue'),
            const SizedBox(height: 16),

            // Remark
            _buildField(
              label: 'Remark *',
              hint: 'Remark *',
              maxLines: 3,
              suffixIcon: Icons.mic_none_outlined,
              isRemark: true,
            ),
            const SizedBox(height: 16),

            // Expected Invitees
            _buildField(
              label: 'Expected invitees *',
              hint: 'Expected invitees *',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Budget
            _buildField(
              label: '₹ Budget per invitee *',
              hint: '₹ Budget per invitee *',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Shared with partner Switch
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shared with partner',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Obx(
                    () => Switch(
                      value: viewModel.isSharedWithPartner.value,
                      onChanged: viewModel.toggleSharedWithPartner,
                      activeThumbColor: AppColors.sfaBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Event Photos
            const Text(
              'Event Photos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // Photo picker logic
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Icon(Icons.add, color: Colors.grey, size: 30),
              ),
            ),

            const SizedBox(height: 40),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Submit logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sfaBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Submit Event',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    IconData? suffixIcon,
    VoidCallback? onTap,
    TextEditingController? controller,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isRemark = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isRemark ? 16 : 30),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              border: InputBorder.none,
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, color: Colors.grey.shade400, size: 22)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
