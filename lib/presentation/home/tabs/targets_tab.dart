import 'package:flutter/material.dart';
import '../../../core/colors/app_colors.dart';

class TargetsTabContent extends StatelessWidget {
  const TargetsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.outlined_flag, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No active goal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Targets appear here once the admin sets up a goal period.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
