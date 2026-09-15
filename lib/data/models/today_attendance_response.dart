class TodayAttendanceResponse {
  final bool success;
  final String code;
  final String message;
  final String? correlationId;
  final TodayAttendanceData? data;
  final String timestamp;

  TodayAttendanceResponse({
    required this.success,
    required this.code,
    required this.message,
    this.correlationId,
    this.data,
    required this.timestamp,
  });

  factory TodayAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return TodayAttendanceResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      correlationId: json['correlationId'],
      data: json['data'] != null ? TodayAttendanceData.fromJson(json['data']) : null,
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class TodayAttendanceData {
  final String status;
  final dynamic attendance;

  TodayAttendanceData({
    required this.status,
    this.attendance,
  });

  factory TodayAttendanceData.fromJson(Map<String, dynamic> json) {
    return TodayAttendanceData(
      status: json['status'] ?? 'NOT_MARKED',
      attendance: json['attendance'],
    );
  }
}
