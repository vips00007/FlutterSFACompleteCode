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

  CustomerCreateData({
    required this.uuid,
    required this.customerCode,
  });

  factory CustomerCreateData.fromJson(Map<String, dynamic> json) {
    return CustomerCreateData(
      uuid: json['uuid'] ?? '',
      customerCode: json['customerCode'] ?? '',
    );
  }
}
