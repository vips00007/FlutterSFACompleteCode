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
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      correlationId: json['correlationId'],
      data: json['data'] != null ? AttendanceData.fromJson(json['data']) : null,
      timestamp: json['timestamp'] ?? '',
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
  final double? checkOutLatitude;
  final double? checkOutLongitude;
  final double? checkOutAccuracyMeters;
  final String? checkOutLocationCapturedAt;
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
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.checkOutAccuracyMeters,
    this.checkOutLocationCapturedAt,
    required this.carriedFromPreviousBusinessDate,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      attendanceUuid: json['attendanceUuid'] ?? '',
      status: json['status'] ?? '',
      businessDate: json['businessDate'] ?? '',
      checkInAt: json['checkInAt'],
      checkOutAt: json['checkOutAt'],
      checkInLatitude: (json['checkInLatitude'] as num?)?.toDouble(),
      checkInLongitude: (json['checkInLongitude'] as num?)?.toDouble(),
      checkInAccuracyMeters: (json['checkInAccuracyMeters'] as num?)
          ?.toDouble(),
      checkInLocationCapturedAt: json['checkInLocationCapturedAt'],
      checkOutLatitude: (json['checkOutLatitude'] as num?)?.toDouble(),
      checkOutLongitude: (json['checkOutLongitude'] as num?)?.toDouble(),
      checkOutAccuracyMeters: (json['checkOutAccuracyMeters'] as num?)
          ?.toDouble(),
      checkOutLocationCapturedAt: json['checkOutLocationCapturedAt'],
      carriedFromPreviousBusinessDate:
          json['carriedFromPreviousBusinessDate'] ?? false,
    );
  }
}
