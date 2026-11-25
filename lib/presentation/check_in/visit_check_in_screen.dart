import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../tickets/widgets/app_header_bar.dart';
import 'visit_check_in_controller.dart';
import 'widgets/dashed_rect.dart';

class VisitCheckInScreen extends StatelessWidget {
  const VisitCheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VisitCheckInController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F9),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar reusing shared AppHeaderBar
            AppHeaderBar(
              title: 'Visit Check-In',
              onBackPressed: () => Get.back(),
            ),

            // Body Content
            Expanded(
              child: Obx(() {
                if (controller.state.value == CheckInState.success) {
                  return _buildSuccessState(controller);
                }

                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              _buildCustomerHeader(controller),
                              const SizedBox(height: 14),
                              _buildLivePhotoSection(controller),
                              const SizedBox(height: 14),
                              _buildLocationSection(controller),
                              const SizedBox(height: 110), // Spacing for sticky bottom footer
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildFooterAction(controller),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // --- 1. Customer Info Header & Collapsible Details ---
  Widget _buildCustomerHeader(VisitCheckInController controller) {
    final outlet = controller.outlet.value;
    final name = (outlet?.firmName.isNotEmpty == true)
        ? outlet!.firmName
        : ((outlet?.firstName.isNotEmpty == true)
            ? '${outlet!.firstName} ${outlet.lastName}'.trim()
            : 'AGRAWAL AUTO SPARES');

    String customerId = '';
    if (outlet?.mobileNumber.isNotEmpty == true && outlet!.mobileNumber != 'Not Available') {
      customerId = outlet.mobileNumber;
    } else if (outlet?.id?.isNotEmpty == true && outlet!.id != 'Not Available') {
      customerId = outlet.id!;
    } else {
      customerId = 'CUS000023';
    }

    final area = (outlet?.area?.isNotEmpty == true)
        ? outlet!.area!
        : ((outlet?.city.isNotEmpty == true) ? outlet!.city : 'Vijay Nagar');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF3EEFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Store Top Row
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9B3BEA), Color(0xFF7A1FD3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.storefront_outlined, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: name,
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          if (customerId.isNotEmpty)
                            TextSpan(
                              text: ' (ID: $customerId)',
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7A1FD3),
                              ),
                            ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildBadge('First visit', color: const Color(0xFF7A1FD3), bg: const Color(0xFFE8EDFD)),
                        _buildBadge('Beat: $area', color: const Color(0xFF4B5563), bg: const Color(0xFFECEEF3), isBold: false),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Collapsible Details
          Obx(() {
            if (!controller.isHeaderExpanded.value) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE6E8F0)),
                  ),
                  child: Column(
                    children: [
                      _buildRowItem('Zone', 'MP NAGAR ZONE II', showDivider: false),
                      _buildRowItem('Visit date', '25 Nov 2026 · 06:12 pm'),
                      _buildRowItem('Last order', '12 Oct · ₹18,400'),
                      _buildRowItem('Pending collection', '₹0.0'),
                      _buildRowItem('Open scheme', 'Buy 10 get 1'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Saved Location Notice (When Expanded)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE6E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.location_on, color: Color(0xFFD9265B), size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Saved outlet location',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                          _buildBadge('✓ 18 m away', color: const Color(0xFF1B6B2F), bg: const Color(0xFFE3F4E7)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '23.2611° N, 77.4090° E',
                        style: TextStyle(fontSize: 12, color: Color(0xFF5B6478)),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'You are within the allowed 100 m. Photo and location were captured on the first visit.',
                        style: TextStyle(fontSize: 11, color: Color(0xFF5B6478), height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // 3 Stats Grid (Avg L3M, MTD, Class)
                Row(
                  children: [
                    Expanded(child: _buildStatBox('Avg L3M', '₹84,200')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatBox('MTD', '₹12,500')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatBox('Class', 'A')),
                  ],
                ),
              ],
            );
          }),

          const SizedBox(height: 10),
          // View More / View Less Toggle Button
          Center(
            child: Obx(() {
              final expanded = controller.isHeaderExpanded.value;
              return InkWell(
                onTap: controller.toggleHeaderExpanded,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1E8FC),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        expanded ? 'View less' : 'View more',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A1FD3),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF7A1FD3),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // --- 2. Live Photo Section ---
  Widget _buildLivePhotoSection(VisitCheckInController controller) {
    final outlet = controller.outlet.value;
    final shopName = outlet?.firmName.isNotEmpty == true ? outlet!.firmName : 'AGRAWAL AUTO SPARES';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(106, 63, 214, 0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'LIVE PHOTO',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Color(0xFF5B6478),
                ),
              ),
              Obx(() {
                final taken = controller.isPhotoTaken.value;
                return taken
                    ? _buildBadge('✓ Captured', color: const Color(0xFF1B6B2F), bg: const Color(0xFFE3F4E7))
                    : _buildBadge('Step 1 of 2', color: const Color(0xFF7A1FD3), bg: const Color(0xFFF1E8FC));
              }),
            ],
          ),
          const SizedBox(height: 12),

          // Photo Box / Dashed Box
          Obx(() {
            final taken = controller.isPhotoTaken.value;

            if (!taken) {
              return DashedRect(
                color: const Color(0xFF6A3FD6).withValues(alpha: 0.4),
                strokeWidth: 1.8,
                gap: 6,
                child: Container(
                  height: 105,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6FE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0EBFC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF6A3FD6),
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Capture a live photo of the shop',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF17193F)),
                      ),
                      const SizedBox(height: 3),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline, size: 12, color: Color(0xFF6B6F93)),
                          SizedBox(width: 4),
                          Text(
                            'Gallery uploads are not allowed',
                            style: TextStyle(fontSize: 11.5, color: Color(0xFF6B6F93)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF17193F), Color(0xFF6A3FD6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6A3FD6).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 8,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF17193F).withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              shopName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Live photo · 06:12 pm',
                            style: TextStyle(color: Colors.white70, fontSize: 11.0, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),

          // Capture / Retake Button Matching Start Visit Styling
          Obx(() {
            final taken = controller.isPhotoTaken.value;
            return InkWell(
              onTap: taken ? controller.retakePhoto : controller.capturePhoto,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8A2BE2), Color(0xFF6A3FD6)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6A3FD6).withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3.5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        taken ? Icons.refresh_rounded : Icons.camera_alt_rounded,
                        color: const Color(0xFF6A3FD6),
                        size: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      taken ? 'Retake Photo' : 'Capture Photo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- 3. Location Section ---
  Widget _buildLocationSection(VisitCheckInController controller) {
    final state = controller.state.value;

    String status = 'Fetching…';
    Color statusBgColor = const Color(0xFFE8EDFD);
    Color statusTextColor = const Color(0xFF7A1FD3);

    String lat = '—';
    String lng = '—';
    String acc = '—';

    if (state == CheckInState.ready || state == CheckInState.loading) {
      status = '✓ Location fixed';
      statusBgColor = const Color(0xFFE3F4E7);
      statusTextColor = const Color(0xFF1B6B2F);
      lat = '23.2611° N';
      lng = '77.4090° E';
      acc = '±18 m';
    } else if (state == CheckInState.errorPermissionDenied) {
      status = 'Blocked';
      statusBgColor = const Color(0xFFFCE8E6);
      statusTextColor = Colors.red.shade700;
    } else if (state == CheckInState.errorWeakGps) {
      status = 'Weak signal';
      statusBgColor = const Color(0xFFFEF7E0);
      statusTextColor = Colors.orange.shade800;
      lat = '23.2611° N';
      lng = '77.4090° E';
      acc = '±86 m';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'LOCATION',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Color(0xFF5B6478),
                ),
              ),
              _buildBadge(status, color: statusTextColor, bg: statusBgColor),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildLocationGridCell('Latitude', lat)),
              const SizedBox(width: 8),
              Expanded(child: _buildLocationGridCell('Longitude', lng)),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLocationGridCell(
                  'Accuracy',
                  acc,
                  bgColor: const Color(0xFFEAF6EC),
                  valColor: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 4. Footer Action Bar ---
  Widget _buildFooterAction(VisitCheckInController controller) {
    final state = controller.state.value;
    final isPhotoTaken = controller.isPhotoTaken.value;
    final isLocReady = state == CheckInState.ready || state == CheckInState.loading;
    final isCheckedIn = state == CheckInState.success;
    final canCheckIn = isPhotoTaken && isLocReady && !isCheckedIn;

    String footerNote = 'Photo and location are required to check in';
    if (isCheckedIn) {
      footerNote = 'Visit marked successfully';
    } else if (canCheckIn) {
      footerNote = 'All set. Tap to mark your visit';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF4F5F8),
        border: Border(top: BorderSide(color: Color(0xFFE1E4EB))),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              footerNote,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF4B5563)),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: canCheckIn ? controller.markVisit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCheckedIn
                      ? const Color(0xFF2E7D32)
                      : (canCheckIn ? const Color(0xFF7C22D6) : const Color(0xFFB4C3E3)),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFB4C3E3),
                  disabledForegroundColor: Colors.white,
                  elevation: canCheckIn ? 2 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isCheckedIn
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('✓ Visit marked', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      )
                    : const Text(
                        'Check In / Mark Visit',
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
    );
  }

  // --- Success State View ---
  Widget _buildSuccessState(VisitCheckInController controller) {
    final outlet = controller.outlet.value;
    final name = outlet?.firmName.isNotEmpty == true ? outlet!.firmName : 'AGRAWAL AUTO SPARES';

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.withValues(alpha: 0.1)),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.withValues(alpha: 0.2)),
                  ),
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2E7D32)),
                    child: const Icon(Icons.check, color: Colors.white, size: 32),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Visit marked successfully',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
              ),
              const SizedBox(height: 6),
              Text(
                '$name · 06:12 PM',
                style: const TextStyle(fontSize: 15, color: Color(0xFF5B6478)),
              ),
              const SizedBox(height: 36),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE6E8F0)),
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Photo', style: TextStyle(color: Color(0xFF5B6478), fontSize: 14.5)),
                        Text('Uploaded', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF2E7D32))),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Location', style: TextStyle(color: Color(0xFF5B6478), fontSize: 14.5)),
                        Text('23.2611° N, 77.4090° E', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF1F2937))),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Accuracy', style: TextStyle(color: Color(0xFF5B6478), fontSize: 14.5)),
                        Text('±18 m', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF2E7D32))),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.finishCheckIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C22D6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // --- Small Helper Widgets ---
  Widget _buildBadge(String label, {required Color color, required Color bg, bool isBold = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildRowItem(String label, String value, {bool showDivider = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: showDivider
          ? const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE6E8F0))))
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280))),
          Text(value, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: Color(0xFF1F2937))),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E8F0)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF5B6478)),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationGridCell(String label, String value, {Color? bgColor, Color? valColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor ?? const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF5B6478)),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: valColor ?? const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }
}
