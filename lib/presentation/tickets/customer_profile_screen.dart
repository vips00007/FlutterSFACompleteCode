import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import '../../domain/entities/outlet.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Outlet? outlet = Get.arguments as Outlet?;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Customer Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: Colors.lightBlueAccent, height: 2),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. Profile Header Section
            _buildProfileHeaderCard(outlet),

            const SizedBox(height: 16),

            // 2. Business Info Section
            _buildInfoCard(
              icon: Icons.business,
              title: 'Business Info',
              details: [
                _DetailItem(
                  label: 'Type',
                  value: outlet?.customerType ?? 'Retailer',
                  icon: Icons.category_outlined,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 3. Contact Info Section
            _buildInfoCard(
              icon: Icons.phone_outlined,
              title: 'Contact Info',
              details: [
                _DetailItem(
                  label: 'Phone',
                  value: outlet?.mobileNumber ?? '9847973183',
                  icon: Icons.phone_outlined,
                ),
                _DetailItem(
                  label: 'Contact Person',
                  value:
                      '${outlet?.firstName ?? 'Suresh'} ${outlet?.lastName ?? 'K k'}',
                  icon: Icons.person_outline,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 4. Address Section
            _buildInfoCard(
              icon: Icons.location_on,
              title: 'Address',
              details: [
                _DetailItem(
                  label: 'Address',
                  value:
                      outlet?.address ??
                      '4F3M+R48, Perumbavoor,\nKerala 683542, India',
                  icon: Icons.location_on_outlined,
                ),
                _DetailItem(
                  label: 'City',
                  value: outlet?.city ?? 'Ernakulam',
                  icon: Icons.business_outlined,
                ),
                _DetailItem(
                  label: 'State',
                  value: outlet?.state ?? 'Kerala',
                  icon: Icons.map_outlined,
                ),
                _DetailItem(
                  label: 'Pincode',
                  value: outlet?.pinCode ?? '682011',
                  icon: Icons.location_on_outlined,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 5. Location Section
            _buildInfoCard(
              icon: Icons.center_focus_strong_outlined,
              title: 'Location',
              details: [
                _DetailItem(
                  label: 'Coordinates',
                  value: '10.104624, 76.483031',
                  icon: Icons.gps_fixed_outlined,
                ),
                _DetailItem(
                  label: 'Geofence\nRadius',
                  value: '200 m',
                  icon: Icons.track_changes_outlined,
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard(Outlet? outlet) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF8A2BE2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x408A2BE2),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFB9E6FE), width: 1),
            ),
            child: Text(
              outlet?.customerType ?? 'Retailer',
              style: const TextStyle(
                color: Color(0xFF0284C7),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<_DetailItem> details,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF0284C7), size: 22),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...details.asMap().entries.map((entry) {
            final index = entry.key;
            final detail = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == details.length - 1 ? 0 : 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(detail.icon, color: const Color(0xFFB9E6FE), size: 18),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: Text(
                      detail.label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      detail.value,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DetailItem {
  final String label;
  final String value;
  final IconData icon;

  _DetailItem({required this.label, required this.value, required this.icon});
}
