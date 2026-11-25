class CustomerCreateResponse {
  final String status;
  final String message;
  final CustomerCreateData? data;

  CustomerCreateResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory CustomerCreateResponse.fromJson(Map<String, dynamic> json) {
    return CustomerCreateResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? CustomerCreateData.fromJson(json['data']) : null,
    );
  }
}

class CustomerCreateData {
  final String uuid;
  final String customerCode;
  final String? lifecycleStatus;
  final bool? mobileVerified;
  final String? mobileVerifiedAt;

  CustomerCreateData({
    required this.uuid,
    required this.customerCode,
    this.lifecycleStatus,
    this.mobileVerified,
    this.mobileVerifiedAt,
  });

  factory CustomerCreateData.fromJson(Map<String, dynamic> json) {
    return CustomerCreateData(
      uuid: json['uuid'] ?? '',
      customerCode: json['customerCode'] ?? '',
      lifecycleStatus: json['lifecycleStatus'],
      mobileVerified: json['mobileVerified'] is bool ? json['mobileVerified'] : null,
      mobileVerifiedAt: json['mobileVerifiedAt']?.toString(),
    );
  }
}
