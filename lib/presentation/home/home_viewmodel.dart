import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../../core/utils/shared_prefs_manager.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../data/models/attendance_request.dart';

class HomeViewModel extends GetxController {
  final AttendanceRepository _attendanceRepository;

  HomeViewModel(this._attendanceRepository);

  final userName = 'User'.obs;
  final role = 'Field User'.obs;
  final currentDate = 'SAT 22 AUG'.obs;

  // SFA Data Observables
  final revenue = '14,715'.obs;
  final targetRevenue = '0.0'.obs;
  final revenueProgress = 0.0.obs;

  final visitsCount = '0/0'.obs;
  final orderedCount = '0'.obs;
  final newCustCount = '0'.obs;
  final distanceKM = '0.0'.obs;

  final presentStatus = 'All in'.obs;
  final auditsCount = '3 tickets'.obs;
  final beatPlanProgress = '0/0'.obs;

  // Loyalty Data Observables
  final scannedCoupons = '0'.obs;
  final loyaltyPoints = '0'.obs;
  final invoiceCount = '0'.obs;
  final invoiceQty = '0'.obs;
  final invoiceValue = '₹0.0'.obs;

  final isDayStarted = false.obs;
  final attendanceStatus = ''.obs; // CHECKED_IN, CHECKED_OUT
  final attendanceUuid = RxnString();
  final isAttendanceLoading = false.obs;

  // Top Tab Navigation
  final selectedTopTabIndex = 0.obs;

  // Period Selector Logic
  final selectedPeriod = 'Today'.obs;

  void changeTopTabIndex(int index) {
    selectedTopTabIndex.value = index;
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    updateMetricsForPeriod(period);
  }

  void updateMetricsForPeriod(String period) {
    // Simulating dynamic data updates based on period
    switch (period) {
      case 'Today':
        revenue.value = '14,715';
        targetRevenue.value = '25,000';
        visitsCount.value = '1/5';
        orderedCount.value = '1';
        newCustCount.value = '0';
        distanceKM.value = '12.5';
        beatPlanProgress.value = '1/5';

        // Loyalty
        scannedCoupons.value = '2';
        loyaltyPoints.value = '50';
        invoiceCount.value = '1';
        invoiceQty.value = '5';
        invoiceValue.value = '₹12,400';
        break;
      case 'Week':
        revenue.value = '84,250';
        targetRevenue.value = '1,50,000';
        visitsCount.value = '12/35';
        orderedCount.value = '8';
        newCustCount.value = '3';
        distanceKM.value = '145.8';
        beatPlanProgress.value = '12/35';

        // Loyalty
        scannedCoupons.value = '15';
        loyaltyPoints.value = '450';
        invoiceCount.value = '8';
        invoiceQty.value = '42';
        invoiceValue.value = '₹68,500';
        break;
      case 'Month':
        revenue.value = '3,20,400';
        targetRevenue.value = '5,00,000';
        visitsCount.value = '45/150';
        orderedCount.value = '32';
        newCustCount.value = '12';
        distanceKM.value = '620.0';
        beatPlanProgress.value = '45/150';

        // Loyalty
        scannedCoupons.value = '58';
        loyaltyPoints.value = '1,850';
        invoiceCount.value = '32';
        invoiceQty.value = '185';
        invoiceValue.value = '₹2,95,000';
        break;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    updateMetricsForPeriod('Today');
    fetchTodayAttendanceStatus();
  }

  Future<void> fetchTodayAttendanceStatus() async {
    try {
      isAttendanceLoading.value = true;
      final response = await _attendanceRepository.getTodayAttendance();
      if (response.success && response.data != null) {
        final status = response.data!.status;
        attendanceStatus.value = status;
        if (status == 'MARKED' || status == 'CHECKED_IN') {
          isDayStarted.value = true;
          presentStatus.value = 'Marked';
        }
      }
    } catch (e) {
      // Error handling removed from debugPrint
    } finally {
      isAttendanceLoading.value = false;
    }
  }

  void loadUserData() {
    final savedName = SharedPrefsManager.getName();
    if (savedName != null && savedName.isNotEmpty) {
      userName.value = savedName;
    }

    final savedRoles = SharedPrefsManager.getRoles();
    if (savedRoles.isNotEmpty) {
      role.value = savedRoles.join(', ');
    }
  }

  Future<void> performAttendance(String imagePath, bool isCheckIn) async {
    isAttendanceLoading.value = true;
    try {
      // 1. Get Location
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // 2. Prepare Selfie - Resize and Compress
      final File imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception("Captured image file not found at: $imagePath");
      }

      final Uint8List originalBytes = await imageFile.readAsBytes();
      
      // Get original dimensions
      try {
        final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(originalBytes);
        final ui.ImageDescriptor descriptor = await ui.ImageDescriptor.encoded(buffer);
        descriptor.dispose();
      } catch (e) {
        // Error handling removed from debugPrint
      }

      // Perform Compression and Resizing
      img.Image? decodedImage = img.decodeImage(originalBytes);
      if (decodedImage == null) {
        throw Exception("Failed to decode captured image for compression.");
      }

      // Resize: max 1280px on longest side
      img.Image resizedImage = decodedImage;
      if (decodedImage.width > 1280 || decodedImage.height > 1280) {
        if (decodedImage.width > decodedImage.height) {
          resizedImage = img.copyResize(decodedImage, width: 1280, interpolation: img.Interpolation.linear);
        } else {
          resizedImage = img.copyResize(decodedImage, height: 1280, interpolation: img.Interpolation.linear);
        }
      }

      // Compress as JPEG with quality 75 and save to temp file
      final Uint8List compressedBytes = img.encodeJpg(resizedImage, quality: 75);
      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/selfie_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final compressedFile = File(targetPath);
      await compressedFile.writeAsBytes(compressedBytes);

      // 3. Log Metadata Safely
      // Removed debugPrint block

      // 4. Create Request with standardized data
      final now = DateTime.now().toUtc();
      // Ensure format: 2026-09-14T12:17:49.000Z
      final capturedAt = "${now.toIso8601String().split('.').first}.000Z";

      // Pre-validation check
      bool hasError = false;
      
      if (targetPath.isEmpty) {
        hasError = true;
      }
      if (position.latitude == 0.0) {
        hasError = true;
      }
      if (position.longitude == 0.0) {
        hasError = true;
      }
      if (position.accuracy == 0.0) {
        hasError = true;
      }
      if (capturedAt.isEmpty) {
        hasError = true;
      }

      if (hasError) {
        throw Exception("Required attendance parameters are missing. Check logs for details.");
      }

      final request = AttendanceRequest(
        selfie: targetPath,
        latitude: double.parse(position.latitude.toStringAsFixed(6)),
        longitude: double.parse(position.longitude.toStringAsFixed(6)),
        accuracyMeters: position.accuracy,
        capturedAt: capturedAt,
      );

      // 5. Call API
      if(isCheckIn) {
        final response = await _attendanceRepository.checkIn(request);
        if (response.success && response.data != null) {
          attendanceUuid.value = response.data!.attendanceUuid;
          attendanceStatus.value = response.data!.status;
          isDayStarted.value = true;
          presentStatus.value = 'Marked';
          Get.snackbar(
            'Success',
            'Check-In successful!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        final response = await _attendanceRepository.checkOut(request);
        if (response.success && response.data != null) {
          attendanceStatus.value = response.data!.status;
          Get.snackbar(
            'Success',
            'Check-Out successful!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isAttendanceLoading.value = false;
    }
  }

  void startDay(String proofPath) {
    // This method is now replaced by performAttendance
    performAttendance(proofPath, true);
  }

  Future<void> refreshHome() async {
    loadUserData();
    await fetchTodayAttendanceStatus();
    // In a real app, fetch updated SFA stats from API here
  }
}
