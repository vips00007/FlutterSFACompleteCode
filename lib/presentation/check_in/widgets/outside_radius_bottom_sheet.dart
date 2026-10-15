import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/colors/app_colors.dart';
import '../../../domain/entities/outlet.dart';
import 'radius_map_visualizer.dart';

class OutsideRadiusBottomSheet extends StatelessWidget {
  final Outlet outlet;
  final bool isInside;

  const OutsideRadiusBottomSheet({
    super.key, 
    required this.outlet,
    this.isInside = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isInside ? 'You\'re Within Range' : 'You\'re Outside the Allowed Radius',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isInside 
                  ? 'You are close enough to the customer. You can continue with check-in.' 
                  : 'Move closer to the customer\'s shop before checking in, then refresh your location.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              // Simple visualization of distance
              RadiusMapVisualizer(
                isInside: isInside,
                distanceText: isInside ? '64 m' : '350 m',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: AppColors.primaryPurple),
                  const SizedBox(width: 4),
                  const Text('Customer', style: TextStyle(fontSize: 12, color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  const Icon(Icons.circle, size: 8, color: Colors.orange),
                  const SizedBox(width: 4),
                  const Text('You', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  Icon(Icons.circle_outlined, size: 10, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text('Allowed radius', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isInside ? const Color(0xFFE6F4EA) : const Color(0xFFFCE8E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isInside ? 'You are 64 m from the customer.' : 'You are 350 m away from the customer.',
                      style: TextStyle(
                        fontSize: 14, 
                        color: isInside ? Colors.green.shade800 : Colors.red.shade800, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Required radius: 100 m.',
                      style: TextStyle(
                        fontSize: 14, 
                        color: isInside ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isInside ? 'Continue to Check-In' : 'Refresh Location',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
