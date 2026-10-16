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
    final String outstanding = isAtRisk ? '₹0' : '₹${(name.length * 12000)}';
    final Color outstandingColor = isAtRisk ? AppColors.textPrimary : const Color(0xFFD93A3A);
    final String lastOrderDays = '${name.length + 2}d';
    final String locationText = '${outlet.city.isNotEmpty ? outlet.city : 'Location'} · 1.8km';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlueBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.store_mall_directory_rounded,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Middle Section (Name, Location, Badges)
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
                            size: 12,
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
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (isAtRisk)
                            _buildStatusChip('At Risk')
                          else ...[
                            _buildStatusChip('Active'),
                            const SizedBox(width: 6),
                            _buildStatusChip('In plan'),
                          ],
                        ],
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
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      outstanding,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: outstandingColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Last order $lastOrderDays',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.primaryPurple.withValues(alpha: 0.2),
          ),
          
          // Bottom Actions
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onCheckIn ?? () {
                      Get.toNamed(RoutesName.visit_details_view, arguments: outlet);
                    },
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Check-In',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppColors.primaryPurple.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(RoutesName.visit_details_view, arguments: outlet);
                    },
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.summarize,
                            size: 16,
                            color: AppColors.primaryPurple,),
                          SizedBox(width: 6),
                          Text(
                            'View Summary',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.fieldBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
