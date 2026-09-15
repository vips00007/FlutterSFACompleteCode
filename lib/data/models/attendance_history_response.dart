import 'attendance_response.dart';

class AttendanceHistoryResponse {
  final bool success;
  final String code;
  final String message;
  final String? correlationId;
  final AttendanceHistoryData? data;
  final String timestamp;
  final List<dynamic> errors;

  AttendanceHistoryResponse({
    required this.success,
    required this.code,
    required this.message,
    this.correlationId,
    this.data,
    required this.timestamp,
    this.errors = const [],
  });

  factory AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      correlationId: json['correlationId'],
      data: json['data'] != null ? AttendanceHistoryData.fromJson(json['data']) : null,
      timestamp: json['timestamp'] ?? '',
      errors: json['errors'] ?? [],
    );
  }
}

class AttendanceHistoryData {
  final List<AttendanceData> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  AttendanceHistoryData({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory AttendanceHistoryData.fromJson(Map<String, dynamic> json) {
    var list = json['content'] as List? ?? [];
    List<AttendanceData> contentList = list.map((i) => AttendanceData.fromJson(i)).toList();

    return AttendanceHistoryData(
      content: contentList,
      page: json['page'] ?? 0,
      size: json['size'] ?? 20,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
