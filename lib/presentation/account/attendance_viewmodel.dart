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
  
  // Locations can be observable to update asynchronously
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
  })  : checkInLocation = checkInLocation.obs,
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
        // Fallback to business date if checkInAt is null
        DateTime bDate = DateTime.parse(data.businessDate);
        displayDate = DateFormat('dd MMM yyyy').format(bDate);
      } catch (_) {
        displayDate = data.businessDate;
      }
    }

    // 2. Resolve locations
    String initialCheckInLoc = data.checkInLatitude != null && data.checkInLongitude != null
        ? "${data.checkInLatitude}, ${data.checkInLongitude}"
        : "Unknown Location";
        
    String initialCheckOutLoc = data.checkOutLatitude != null && data.checkOutLongitude != null
        ? "${data.checkOutLatitude}, ${data.checkOutLongitude}"
        : "Unknown Location";

    // 3. Status mapping
    bool isPresent = data.status == 'CHECKED_IN' || data.status == 'CHECKED_OUT';
    String displayStatus = isPresent ? 'Present' : (data.status.isNotEmpty ? data.status : 'Absent');

    final record = AttendanceRecord(
      date: displayDate,
      checkInTime: checkInStr,
      checkOutTime: checkOutStr,
      checkInLocation: initialCheckInLoc,
      checkOutLocation: initialCheckOutLoc,
      duration: '', // Or compute duration if needed
      status: displayStatus,
      isPresent: isPresent,
      photoUrl: null, // As per requirement, no image URL from API
    );

    // Asynchronously update locations using Reverse Geocoding
    if (data.checkInLatitude != null && data.checkInLongitude != null) {
      _geocodingService.getAddressFromCoordinates(data.checkInLatitude!, data.checkInLongitude!)
          .then((address) => record.checkInLocation.value = address);
    }
    
    if (data.checkOutLatitude != null && data.checkOutLongitude != null) {
      _geocodingService.getAddressFromCoordinates(data.checkOutLatitude!, data.checkOutLongitude!)
          .then((address) => record.checkOutLocation.value = address);
    }

    return record;
  }
}
