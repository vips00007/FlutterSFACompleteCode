class RegularizationStatusResponse {
  final bool success;
  final String message;
  final RegularizationStatusData? data;

  RegularizationStatusResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RegularizationStatusResponse.fromJson(Map<String, dynamic> json) {
    return RegularizationStatusResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? RegularizationStatusData.fromJson(json['data'])
          : null,
    );
  }
}

class RegularizationStatusData {
  final String requestId;
  final String attendanceDate;
  final String correctedTime;
  final String reason;
  final String approverName;
  final String status;

  RegularizationStatusData({
    required this.requestId,
    required this.attendanceDate,
    required this.correctedTime,
    required this.reason,
    required this.approverName,
    required this.status,
  });

  factory RegularizationStatusData.fromJson(Map<String, dynamic> json) {
    return RegularizationStatusData(
      requestId: json['requestId'] ?? '',
      attendanceDate: json['attendanceDate'] ?? '',
      correctedTime: json['correctedTime'] ?? '',
      reason: json['reason'] ?? '',
      approverName: json['approverName'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }
}
