import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import 'visit_check_in_controller.dart';
import 'widgets/dashed_rect.dart';

class VisitCheckInScreen extends StatelessWidget {
  const VisitCheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VisitCheckInController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Visit Check-In',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
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
                      _buildHeader(controller),
                      const SizedBox(height: 16),
                      _buildPhotoSection(controller),
                      const SizedBox(height: 16),
                      _buildLocationSection(controller),
                      const SizedBox(height: 100), // spacing for bottom action
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomAction(controller),
            ),
            // Developer toggles to show error states easily
            if (controller.state.value == CheckInState.ready)
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: controller.simulatePermissionDenied,
                      child: const Text('Dev: Perm Denied', style: TextStyle(fontSize: 10)),
                    ),
                    TextButton(
                      onPressed: controller.simulateWeakGps,
                      child: const Text('Dev: Weak GPS', style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(VisitCheckInController controller) {
    final outlet = controller.outlet.value;
    final name = outlet?.firmName ?? 'Store Name';
    final idAndType = 'CUST-${outlet?.id ?? "000"} · ${outlet?.customerType ?? "Retailer"}';
    final address = outlet?.address ?? 'Location Address';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            idAndType,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE), // Light Blue
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'First visit',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F4), // Light Grey
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Beat: Vijay Nagar',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(VisitCheckInController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LIVE PHOTO',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          if (!controller.isPhotoTaken.value)
            DashedRect(
              color: const Color(0xFFB8C2CC),
              strokeWidth: 2,
              gap: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F0FE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_outlined, color: AppColors.primaryPurple),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Capture a live photo of the shop',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Gallery uploads are not allowed',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFC7CDD6),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  // Mock building drawing
                  Positioned(
                    bottom: 0, left: 30, right: 30,
                    child: Container(height: 120, color: const Color(0xFFE6D6B8)), // walls
                  ),
                  Positioned(
                    bottom: 120, left: 20, right: 20,
                    child: Container(height: 40, color: const Color(0xFFC9533B)), // roof
                  ),
                  Positioned(
                    bottom: 0, left: 100, right: 100,
                    child: Container(height: 80, color: const Color(0xFF6A798C)), // door
                  ),
                  Positioned(
                    bottom: 40, left: 50, right: 210,
                    child: Container(height: 40, color: Colors.white), // left window
                  ),
                  Positioned(
                    bottom: 40, left: 210, right: 50,
                    child: Container(height: 40, color: Colors.white), // right window
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Live photo · 10:42 AM',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: !controller.isPhotoTaken.value
                ? ElevatedButton.icon(
                    onPressed: controller.capturePhoto,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Capture Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                : OutlinedButton.icon(
                    onPressed: controller.retakePhoto,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Retake', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryPurple,
                      side: const BorderSide(color: AppColors.primaryPurple),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(VisitCheckInController controller) {
    final state = controller.state.value;
    
    String status = 'Fetching…';
    Color statusBgColor = const Color(0xFFE8F0FE);
    Color statusTextColor = AppColors.primaryPurple;
    IconData? statusIcon;
    
    String lat = '—';
    String lng = '—';
    String acc = '—';
    Widget? errorWidget;

    if (state == CheckInState.ready || state == CheckInState.loading) {
      status = 'Verified';
      statusBgColor = const Color(0xFFE6F4EA);
      statusTextColor = Colors.green.shade700;
      statusIcon = Icons.check;
      lat = '22.753310';
      lng = '75.893742';
      acc = '±8 m · Good';
    } else if (state == CheckInState.errorPermissionDenied) {
      status = 'Blocked';
      statusBgColor = const Color(0xFFFCE8E6);
      statusTextColor = Colors.red.shade700;
      statusIcon = Icons.block;
      errorWidget = Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFCE8E6), // Light Red Box
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location permission denied', style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Text('Allow location access so we can confirm you are at the customer\'s shop.', style: TextStyle(color: Colors.red.shade800, fontSize: 14)),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple, foregroundColor: Colors.white, elevation: 0),
                  child: const Text('Open Settings', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: controller.retryLocation,
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryPurple, side: const BorderSide(color: AppColors.primaryPurple)),
                  child: const Text('Try Again', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      );
    } else if (state == CheckInState.errorWeakGps) {
      status = 'Weak signal';
      statusBgColor = const Color(0xFFFEF7E0);
      statusTextColor = Colors.orange.shade800;
      statusIcon = Icons.error_outline;
      lat = '22.753102';
      lng = '75.894210';
      acc = '±86 m · Needs ±50 m';
      errorWidget = Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF7E0), // Light Orange Box
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GPS accuracy is too low. Move to an open area and retry.', style: TextStyle(color: Colors.orange.shade900, fontSize: 14)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: controller.retryLocation,
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryPurple, side: const BorderSide(color: AppColors.primaryPurple)),
                child: const Text('Retry Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      );
    } else {
      // Fetching state
      statusIcon = Icons.circle_outlined;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: state == CheckInState.errorWeakGps 
            ? Colors.orange 
            : (state == CheckInState.errorPermissionDenied ? Colors.red : Colors.grey.shade200)
        ),
      ),
      padding: const EdgeInsets.all(16),
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
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    if (statusIcon != null) ...[
                      Icon(statusIcon, size: 14, color: statusTextColor),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Latitude', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              Text(lat, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Longitude', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              Text(lng, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Accuracy', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              Text(acc, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: state == CheckInState.errorWeakGps ? Colors.orange.shade800 : Colors.green.shade700)),
            ],
          ),
          if (errorWidget != null) ...[
            const SizedBox(height: 16),
            errorWidget,
          ]
        ],
      ),
    );
  }

  Widget _buildBottomAction(VisitCheckInController controller) {
    final state = controller.state.value;
    final isReady = state == CheckInState.ready;
    final isLoading = state == CheckInState.loading;
    final hasErrors = state == CheckInState.errorPermissionDenied || state == CheckInState.errorWeakGps;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isReady && !isLoading && !hasErrors) ...[
              const Text(
                'Photo and location are required to check in',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isReady ? controller.markVisit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  disabledBackgroundColor: const Color(0xFFB4C5E4),
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Marking visit...', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      )
                    : const Text(
                        'Check In / Mark Visit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(VisitCheckInController controller) {
    final outlet = controller.outlet.value;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Rings Visualization
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.withOpacity(0.1)),
                  ),
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.withOpacity(0.2)),
                  ),
                  Container(
                    width: 60, height: 60,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                    child: const Icon(Icons.check, color: Colors.white, size: 36),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Visit marked successfully',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                '${outlet?.firmName ?? "Store Name"} · 10:42 AM',
                style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Photo', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                        Text('Uploaded', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Location', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                        Text('22.753310, 75.893742', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Accuracy', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                        Text('±8 m', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.finishCheckIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Done', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
