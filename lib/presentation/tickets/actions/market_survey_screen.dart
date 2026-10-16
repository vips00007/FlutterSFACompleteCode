import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/colors/app_colors.dart';

class MarketSurveyScreen extends StatefulWidget {
  const MarketSurveyScreen({super.key});

  @override
  State<MarketSurveyScreen> createState() => _MarketSurveyScreenState();
}

class _MarketSurveyScreenState extends State<MarketSurveyScreen> {
  String _stockStatus = 'Yes';
  String _competitorActivity = 'Price cut';
  String _brandingDisplay = 'Done';
  int _satisfactionRating = 5;

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
              'Market survey',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Quick distributor feedback, 1 minute',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChoiceSection('Are focus products in stock?', ['Yes', 'No', 'Partly', 'None'], _stockStatus, (val) => setState(() => _stockStatus = val)),
              const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1)),
              _buildChoiceSection('Competitor activity seen', ['Price cut', 'New product', 'New scheme', 'None'], _competitorActivity, (val) => setState(() => _competitorActivity = val)),
              const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1)),
              _buildChoiceSection('Our branding and display', ['Done', 'Expired', 'Need work', 'Not available'], _brandingDisplay, (val) => setState(() => _brandingDisplay = val)),
              const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1)),
              _buildRatingSection(),
              const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1)),
              _buildRemarksSection(),
            ],
          ),
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
                  Text('Submit Survey', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceSection(String title, List<String> options, String selectedValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryPurple : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? AppColors.primaryPurple : Colors.grey.shade300),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Distributor satisfaction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        Row(
          children: [
            ...List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _satisfactionRating = index + 1),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.star,
                    color: index < _satisfactionRating ? const Color(0xFFFFC107) : Colors.grey.shade300,
                    size: 32,
                  ),
                ),
              );
            }),
            const SizedBox(width: 8),
            Text('$_satisfactionRating / 5', style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        )
      ],
    );
  }

  Widget _buildRemarksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Remarks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3), width: 1.5),
          ),
          child: const TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Issue, request, market feedback',
              hintStyle: TextStyle(color: AppColors.textSecondary),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
