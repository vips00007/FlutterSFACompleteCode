class VisitPlanCustomersResponse {
  final bool success;
  final String code;
  final String message;
  final VisitPlanCustomersData? data;

  VisitPlanCustomersResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory VisitPlanCustomersResponse.fromJson(Map<String, dynamic> json) {
    return VisitPlanCustomersResponse(
      success: json['success'] ?? false,
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? VisitPlanCustomersData.fromJson(json['data']) : null,
    );
  }
}

class VisitPlanCustomersData {
  final List<VisitPlanCustomer> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  VisitPlanCustomersData({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory VisitPlanCustomersData.fromJson(Map<String, dynamic> json) {
    return VisitPlanCustomersData(
      content: (json['content'] as List?)
              ?.map((e) => VisitPlanCustomer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          (json['items'] as List?)
              ?.map((e) => VisitPlanCustomer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      page: json['page'] is int ? json['page'] : (json['page'] as num?)?.toInt() ?? 0,
      size: json['size'] is int ? json['size'] : (json['size'] as num?)?.toInt() ?? 20,
      totalElements: json['totalElements'] is int ? json['totalElements'] : (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: json['totalPages'] is int ? json['totalPages'] : (json['totalPages'] as num?)?.toInt() ?? 0,
    );
  }
}

class VisitPlanCustomer {
  final String uuid;
  final String? customerCode;
  final String? shopName;
  final String? area;
  final String? city;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;
  final double? outstandingAmount;
  final int? lastOrderDays;
  final Map<String, dynamic>? metrics;
  final bool? planned;
  final List<String>? plannedDates;
  final String? planUuid;
  final String? planStatus;

  VisitPlanCustomer({
    required this.uuid,
    this.customerCode,
    this.shopName,
    this.area,
    this.city,
    this.latitude,
    this.longitude,
    this.distanceKm,
    this.outstandingAmount,
    this.lastOrderDays,
    this.metrics,
    this.planned,
    this.plannedDates,
    this.planUuid,
    this.planStatus,
  });

  factory VisitPlanCustomer.fromJson(Map<String, dynamic> json) {
    return VisitPlanCustomer(
      uuid: (json['uuid'] ?? json['id'] ?? '').toString(),
      customerCode: json['customerCode']?.toString(),
      shopName: json['shopName']?.toString() ?? json['name']?.toString(),
      area: json['area']?.toString(),
      city: json['city']?.toString(),
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      distanceKm: json['distanceKm'] != null ? (json['distanceKm'] as num).toDouble() : null,
      outstandingAmount: json['outstandingAmount'] != null ? (json['outstandingAmount'] as num).toDouble() : null,
      lastOrderDays: json['lastOrderDays'] != null ? (json['lastOrderDays'] as num).toInt() : null,
      metrics: json['metrics'] is Map<String, dynamic> ? json['metrics'] as Map<String, dynamic> : null,
      planned: json['planned'] is bool ? json['planned'] as bool : null,
      plannedDates: (json['plannedDates'] as List?)?.map((e) => e.toString()).toList(),
      planUuid: json['planUuid']?.toString(),
      planStatus: json['planStatus']?.toString(),
    );
  }
}
