import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import '../../data/datasource/remote/geocoding_service.dart';
import '../../data/models/attendance_response.dart';
import '../../domain/repositories/attendance_repository.dart';

class AttendanceRecord {
  final String date;
  final String checkInTime;
  final String checkOutTime;
  final String duration;
  final String status;
  final bool isPresent;
  final String? photoUrl;

  // Locations are observable to update asynchronously
  final RxString checkInLocation;
  final RxString checkOutLocation;

  AttendanceRecord({
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required String checkInLocation,
    required String checkOutLocation,
    required this.duration,
    required this.status,
    this.isPresent = true,
    this.photoUrl,
  }) : checkInLocation = checkInLocation.obs,
       checkOutLocation = checkOutLocation.obs;
}

class AttendanceViewModel extends GetxController {
  final AttendanceRepository _repository;
  final GeocodingService _geocodingService = GeocodingService();

  AttendanceViewModel(this._repository);

  final attendanceRecords = <AttendanceRecord>[].obs;

  final isLoading = false.obs;
  final isPaginating = false.obs;
  final errorMessage = ''.obs;

  int _currentPage = 0;
  final int _pageSize = 20;

  final totalElements = 0.obs;
  int _totalPages = 1;

  bool get hasMoreData => _currentPage < _totalPages;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 0;
      errorMessage.value = '';
    } else {
      if (!hasMoreData || isLoading.value || isPaginating.value) return;
    }

    try {
      if (_currentPage == 0) {
        isLoading.value = true;
      } else {
        isPaginating.value = true;
      }

      final response = await _repository.getHistory(_currentPage, _pageSize);

      if (response.data != null) {
        final data = response.data!;
        totalElements.value = data.totalElements;
        _totalPages = data.totalPages;

        final List<AttendanceRecord> newRecords = data.content.map((item) {
          return _mapToRecord(item);
        }).toList();

        if (_currentPage == 0) {
          attendanceRecords.assignAll(newRecords);
        } else {
          attendanceRecords.addAll(newRecords);
        }

        _currentPage++;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error fetching attendance history: $e");
      }
      if (_currentPage == 0) {
        errorMessage.value = e.toString().replaceAll('Exception: ', '');
      }
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }

  bool _isCoordinateString(String input) {
    final trimmed = input.trim().toLowerCase();
    if (trimmed.contains('lat') || trimmed.contains('lng') || trimmed.contains('gps')) {
      return true;
    }
    final coordRegex = RegExp(r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$');
    return coordRegex.hasMatch(input.trim());
  }

  AttendanceRecord _mapToRecord(AttendanceData data) {
    // 1. Format dates (API returns UTC: 2026-09-14T15:20:08.898226Z)
    String displayDate = '';
    String checkInStr = '';
    String checkOutStr = 'Not Checked Out';

    if (data.checkInAt != null) {
      try {
        DateTime checkInUtc = DateTime.parse(data.checkInAt!).toUtc();
        DateTime checkInLocal = checkInUtc.toLocal();

        displayDate = DateFormat('dd MMM yyyy').format(checkInLocal);
        checkInStr = DateFormat('hh:mm a').format(checkInLocal);

        if (data.checkOutAt != null) {
          DateTime checkOutUtc = DateTime.parse(data.checkOutAt!).toUtc();
          DateTime checkOutLocal = checkOutUtc.toLocal();
          checkOutStr = DateFormat('hh:mm a').format(checkOutLocal);
        }
      } catch (e) {
        checkInStr = 'Invalid Date';
      }
    } else {
      try {
        DateTime bDate = DateTime.parse(data.businessDate);
        displayDate = DateFormat('dd MMM yyyy').format(bDate);
      } catch (_) {
        displayDate = data.businessDate;
      }
    }

    // 2. Resolve Check-In & Check-Out location addresses independently
    final bool hasCheckInAddress = data.checkInAddress != null &&
        data.checkInAddress!.trim().isNotEmpty &&
        !_isCoordinateString(data.checkInAddress!);

    String initialCheckInLoc;
    if (hasCheckInAddress) {
      initialCheckInLoc = data.checkInAddress!.trim();
    } else {
      initialCheckInLoc = "Location not available";
    }

    final bool hasCheckedOut = data.checkOutAt != null ||
        data.status == 'CHECKED_OUT' ||
        data.checkOutLatitude != null;

    final bool hasCheckOutAddress = data.checkOutAddress != null &&
        data.checkOutAddress!.trim().isNotEmpty &&
        !_isCoordinateString(data.checkOutAddress!);

    String initialCheckOutLoc;
    if (!hasCheckedOut && data.status != 'CHECKED_OUT') {
      initialCheckOutLoc = "Not Checked Out";
    } else if (hasCheckOutAddress) {
      initialCheckOutLoc = data.checkOutAddress!.trim();
    } else {
      initialCheckOutLoc = "Location not available";
    }

    // 3. Status mapping
    bool isPresent = data.status == 'CHECKED_IN' || data.status == 'CHECKED_OUT';
    String displayStatus = isPresent
        ? 'Present'
        : (data.status.isNotEmpty ? data.status : 'Absent');

    final record = AttendanceRecord(
      date: displayDate,
      checkInTime: checkInStr,
      checkOutTime: checkOutStr,
      checkInLocation: initialCheckInLoc,
      checkOutLocation: initialCheckOutLoc,
      duration: '',
      status: displayStatus,
      isPresent: isPresent,
      photoUrl: null,
    );

    // Reverse geocode if readable address string is missing but coordinates are available
    if (!hasCheckInAddress &&
        data.checkInLatitude != null &&
        data.checkInLongitude != null &&
        (data.checkInLatitude != 0 || data.checkInLongitude != 0)) {
      _geocodingService
          .getAddressFromCoordinates(
            data.checkInLatitude!,
            data.checkInLongitude!,
          )
          .then((address) {
            if (address.isNotEmpty && !_isCoordinateString(address)) {
              record.checkInLocation.value = address;
            }
          });
    }

    if (hasCheckedOut &&
        !hasCheckOutAddress &&
        data.checkOutLatitude != null &&
        data.checkOutLongitude != null &&
        (data.checkOutLatitude != 0 || data.checkOutLongitude != 0)) {
      _geocodingService
          .getAddressFromCoordinates(
            data.checkOutLatitude!,
            data.checkOutLongitude!,
          )
          .then((address) {
            if (address.isNotEmpty && !_isCoordinateString(address)) {
              record.checkOutLocation.value = address;
            }
          });
    }

    return record;
  }
}
