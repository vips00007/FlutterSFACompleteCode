class CustomerCreateResponse {
  final bool success;
  final String code;
  final String message;
  final CustomerCreateData? data;

  CustomerCreateResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory CustomerCreateResponse.fromJson(Map<String, dynamic> json) {
    return CustomerCreateResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? CustomerCreateData.fromJson(json['data']) : null,
    );
  }
}

class CustomerCreateData {
  final String? uuid;
  final String? customerCode;
  final String? shopName;
  final String? lifecycleStatus;
  final int? version;

  CustomerCreateData({
    this.uuid,
    this.customerCode,
    this.shopName,
    this.lifecycleStatus,
    this.version,
  });

  factory CustomerCreateData.fromJson(Map<String, dynamic> json) {
    return CustomerCreateData(
      uuid: json['uuid'],
      customerCode: json['customerCode'],
      shopName: json['shopName'],
      lifecycleStatus: json['lifecycleStatus'],
      version: json['version'],
    );
  }
}