class UnplannedCustomersResponse {
  final bool success;
  final String code;
  final String message;
  final UnplannedCustomersData? data;

  UnplannedCustomersResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory UnplannedCustomersResponse.fromJson(Map<String, dynamic> json) {
    return UnplannedCustomersResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? UnplannedCustomersData.fromJson(json['data']) : null,
    );
  }
}

class UnplannedCustomersData {
  final List<UnplannedCustomer> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  UnplannedCustomersData({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory UnplannedCustomersData.fromJson(Map<String, dynamic> json) {
    return UnplannedCustomersData(
      content: (json['content'] as List?)
              ?.map((e) => UnplannedCustomer.fromJson(e))
              .toList() ??
          [],
      page: json['page'] ?? 0,
      size: json['size'] ?? 20,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

class UnplannedCustomer {
  final String uuid;
  final String? customerCode;
  final String? shopName;
  final double? latitude;
  final double? longitude;

  UnplannedCustomer({
    required this.uuid,
    this.customerCode,
    this.shopName,
    this.latitude,
    this.longitude,
  });

  factory UnplannedCustomer.fromJson(Map<String, dynamic> json) {
    return UnplannedCustomer(
      uuid: json['uuid'] ?? '',
      customerCode: json['customerCode'],
      shopName: json['shopName'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}
