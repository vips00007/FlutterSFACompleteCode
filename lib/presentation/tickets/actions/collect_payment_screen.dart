import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/colors/app_colors.dart';

class CollectPaymentScreen extends StatefulWidget {
  const CollectPaymentScreen({super.key});

  @override
  State<CollectPaymentScreen> createState() => _CollectPaymentScreenState();
}

class _CollectPaymentScreenState extends State<CollectPaymentScreen> {
  String _selectedPaymentMode = 'UPI';

  // Dummy state for checkboxes
  bool _inv1Selected = true;
  bool _inv2Selected = false;
  bool _inv3Selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 16),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Collect payment',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Select invoices and record receipt',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInvoicesSection(),
            const SizedBox(height: 16),
            _buildFormSection(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Save receipt', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoicesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Select invoices',
                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                '1 selected',
                style: TextStyle(color: AppColors.primaryPurple, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInvoiceRow('INV-5521', 'Overdue 12 days', '₹11,00,000', _inv1Selected, (val) => setState(() => _inv1Selected = val!)),
          Divider(color: Colors.grey.shade200),
          _buildInvoiceRow('INV-5526', 'Overdue 1 days', '₹14,00,000', _inv2Selected, (val) => setState(() => _inv2Selected = val!)),
          Divider(color: Colors.grey.shade200),
          _buildInvoiceRow('INV-5521', 'Overdue 2 days', '₹23,00,000', _inv3Selected, (val) => setState(() => _inv3Selected = val!)),
        ],
      ),
    );
  }

  Widget _buildInvoiceRow(String id, String overdue, String amount, bool isSelected, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isSelected,
              onChanged: onChanged,
              activeColor: AppColors.primaryPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 60,
            child: Text(id, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(overdue, style: TextStyle(color: Colors.red.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const Spacer(),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Amount received (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.currency_rupee, color: AppColors.primaryPurple, size: 18),
              hintText: '27,000',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
          const SizedBox(height: 16),
          const Text('Payment mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPaymentModeChip('UPI'),
                const SizedBox(width: 8),
                _buildPaymentModeChip('NEFT'),
                const SizedBox(width: 8),
                _buildPaymentModeChip('CHEQUE'),
                const SizedBox(width: 8),
                _buildPaymentModeChip('CASH'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Reference / cheque number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'UTR or cheque no.',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          const SizedBox(height: 16),
          _buildPhotoUploader(),
        ],
      ),
    );
  }

  Widget _buildPaymentModeChip(String mode) {
    final isSelected = _selectedPaymentMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primaryPurple : Colors.grey.shade300),
        ),
        child: Text(
          mode,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primaryPurple,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUploader() {
    // We will simulate the dashed border using a container since we don't have dashed_rect available directly here without imports
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3), width: 1.5, style: BorderStyle.solid), // Fallback to solid, can use dashed_rect if needed
      ),
      child: Column(
        children: const [
          Icon(Icons.camera_alt_outlined, color: AppColors.primaryPurple),
          SizedBox(height: 8),
          Text(
            'Photo of receipt or cheque',
            style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          SizedBox(height: 4),
          Text(
            'Tap to open camera',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
