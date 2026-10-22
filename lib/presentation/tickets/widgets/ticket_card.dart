import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/colors/app_colors.dart';
import '../../../domain/entities/outlet.dart';
import '../../../routes/route_names.dart';

class TicketCard extends StatelessWidget {
  final Outlet outlet;
  final VoidCallback? onCheckIn;

  const TicketCard({
    super.key,
    required this.outlet,
    this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    // Generate some mock data based on name length to vary the UI slightly
    // in the absence of real data in the Outlet entity.
    final String name = outlet.firmName.isNotEmpty
        ? outlet.firmName
        : '${outlet.firstName} ${outlet.lastName}';
    final bool isAtRisk = name.length % 3 == 0;
    // Mock the data format according to the new design
    final String outstanding = isAtRisk ? '₹94,000' : '₹58,000';
    final Color outstandingColor = const Color(0xFFD93A3A); // Red color from design
    final String locationText = '${outlet.city.isNotEmpty ? outlet.city : 'Vijay Nagar'} · 1.8km';
    final String id = 'KAH00456541215'; // Mock ID based on design

    return GestureDetector(
      onTap: onCheckIn ?? () {
        Get.toNamed(RoutesName.visit_details_view, arguments: outlet);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryPurple, width: 1),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Icon Box
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF), // light purple
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.storefront,
                      color: AppColors.primaryPurple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Middle Section (Name, Location, ID)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                locationText,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          id,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Right Section (Outstanding)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Outstanding',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        outstanding,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: outstandingColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Last order 12d',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Divider is replaced by grid directly in the image, or is there a light line? 
            // In the image, there is a very faint line dividing the sections
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 8),

            // Stats Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatRow('Channel', 'General trade'),
                        _buildStatRow('Group', 'Reached w/s'),
                        _buildStatRow('Class', 'General trade'),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 60, color: Colors.grey.shade200),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatRow('Tgt', '₹ 0'),
                          _buildStatRow('Ach', '₹ 0'),
                          _buildStatRow('Bal', '₹ 0'),
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, height: 60, color: Colors.grey.shade200),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatRow('AvgL3M', isAtRisk ? '₹ 98,000' : '₹ 58,000'),
                          _buildStatRow('Cov', '2'),
                          _buildStatRow('Prod', '5'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Bottom Icons
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400, width: 1.5),
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.location_on, color: Colors.green, size: 18),
                  const SizedBox(width: 6),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.primaryPurple,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
