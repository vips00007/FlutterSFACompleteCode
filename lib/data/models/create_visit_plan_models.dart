class SubmitPlanResponse {
  final bool success;
  final String code;
  final String message;
  final SubmitPlanData? data;

  SubmitPlanResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory SubmitPlanResponse.fromJson(Map<String, dynamic> json) {
    return SubmitPlanResponse(
      success: json['success'] ?? false,
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? SubmitPlanData.fromJson(json['data']) : null,
    );
  }
}

class SubmitPlanData {
  final String uuid;
  final String status;
  final String planType;
  final int customerCount;
  final List<dynamic>? customers;
  final String? fromDate;
  final String? toDate;
  final String? destinationGeographyUuid;
  final List<dynamic>? days;

  SubmitPlanData({
    required this.uuid,
    required this.status,
    required this.planType,
    required this.customerCount,
    this.customers,
    this.fromDate,
    this.toDate,
    this.destinationGeographyUuid,
    this.days,
  });

  factory SubmitPlanData.fromJson(Map<String, dynamic> json) {
    return SubmitPlanData(
      uuid: (json['uuid'] ?? json['id'] ?? '').toString(),
      status: (json['status'] ?? 'PENDING_APPROVAL').toString(),
      planType: (json['planType'] ?? 'LOCAL').toString(),
      customerCount: json['customerCount'] is int
          ? json['customerCount'] as int
          : (json['customerCount'] as num?)?.toInt() ?? 0,
      customers: json['customers'] is List ? json['customers'] as List : null,
      fromDate: json['fromDate']?.toString(),
      toDate: json['toDate']?.toString(),
      destinationGeographyUuid: json['destinationGeographyUuid']?.toString(),
      days: json['days'] is List ? json['days'] as List : null,
    );
  }
}
