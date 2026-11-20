class AttendanceResponse {
  final bool success;
  final String code;
  final String message;
  final String? correlationId;
  final AttendanceData? data;
  final String timestamp;
  final List<dynamic> errors;

  AttendanceResponse({
    required this.success,
    required this.code,
    required this.message,
    this.correlationId,
    this.data,
    required this.timestamp,
    this.errors = const [],
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      success: json['success'] ?? false,
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      correlationId: json['correlationId']?.toString(),
      data: json['data'] != null ? AttendanceData.fromJson(json['data']) : null,
      timestamp: json['timestamp']?.toString() ?? '',
      errors: json['errors'] ?? [],
    );
  }
}

class AttendanceData {
  final String attendanceUuid;
  final String status;
  final String businessDate;
  final String? checkInAt;
  final String? checkOutAt;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final double? checkInAccuracyMeters;
  final String? checkInLocationCapturedAt;
  final String? checkInAddress;
  final double? checkOutLatitude;
  final double? checkOutLongitude;
  final double? checkOutAccuracyMeters;
  final String? checkOutLocationCapturedAt;
  final String? checkOutAddress;
  final bool carriedFromPreviousBusinessDate;

  AttendanceData({
    required this.attendanceUuid,
    required this.status,
    required this.businessDate,
    this.checkInAt,
    this.checkOutAt,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkInAccuracyMeters,
    this.checkInLocationCapturedAt,
    this.checkInAddress,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.checkOutAccuracyMeters,
    this.checkOutLocationCapturedAt,
    this.checkOutAddress,
    required this.carriedFromPreviousBusinessDate,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      attendanceUuid: (json['attendanceUuid'] ?? json['uuid'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      businessDate: (json['businessDate'] ?? '').toString(),
      checkInAt: json['checkInAt']?.toString(),
      checkOutAt: json['checkOutAt']?.toString(),
      checkInLatitude: (json['checkInLatitude'] as num?)?.toDouble(),
      checkInLongitude: (json['checkInLongitude'] as num?)?.toDouble(),
      checkInAccuracyMeters: (json['checkInAccuracyMeters'] as num?)?.toDouble(),
      checkInLocationCapturedAt: json['checkInLocationCapturedAt']?.toString(),
      checkInAddress: (json['checkInAddress'] ?? json['checkInLocation'] ?? json['checkInAddressLine'] ?? json['checkInPlace'] ?? json['checkInLocationName'])?.toString(),
      checkOutLatitude: (json['checkOutLatitude'] as num?)?.toDouble(),
      checkOutLongitude: (json['checkOutLongitude'] as num?)?.toDouble(),
      checkOutAccuracyMeters: (json['checkOutAccuracyMeters'] as num?)?.toDouble(),
      checkOutLocationCapturedAt: json['checkOutLocationCapturedAt']?.toString(),
      checkOutAddress: (json['checkOutAddress'] ?? json['checkOutLocation'] ?? json['checkOutAddressLine'] ?? json['checkOutPlace'] ?? json['checkOutLocationName'])?.toString(),
      carriedFromPreviousBusinessDate: json['carriedFromPreviousBusinessDate'] ?? false,
    );
  }
}
