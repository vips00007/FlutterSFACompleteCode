class CustomerReferenceDataResponse {
  final String status;
  final String message;
  final ReferenceData data;

  CustomerReferenceDataResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CustomerReferenceDataResponse.fromJson(Map<String, dynamic> json) {
    return CustomerReferenceDataResponse(
      status: json['status']?.toString() ?? json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: ReferenceData.fromJson(json['data'] ?? {}),
    );
  }
}

class ReferenceData {
  final List<CustomerTypeModel> customerTypes;
  final List<dynamic> groups;
  final List<LookupItem> lookups;
  final List<BeatItem> beats;

  ReferenceData({
    required this.customerTypes,
    required this.groups,
    required this.lookups,
    required this.beats,
  });

  factory ReferenceData.fromJson(Map<String, dynamic> json) {
    return ReferenceData(
      customerTypes: (json['customerTypes'] as List?)
              ?.map((e) => CustomerTypeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      groups: json['groups'] ?? [],
      lookups: (json['lookups'] as List?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      beats: (json['beats'] as List?)
              ?.map((e) => BeatItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CustomerTypeModel {
  final String uuid;
  final String code;
  final String name;

  CustomerTypeModel({
    required this.uuid,
    required this.code,
    required this.name,
  });

  factory CustomerTypeModel.fromJson(Map<String, dynamic> json) {
    return CustomerTypeModel(
      uuid: (json['uuid'] ?? json['id'] ?? '').toString(),
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class LookupItem {
  final String uuid;
  final String code;
  final String name;
  final String lookupType;
  final String? status;
  final int? displayOrder;
  final String? parentUuid;
  final String? customerTypeUuid;
  final String? subTypeUuid;
  final String? channelUuid;
  final String? segmentUuid;
  final String? categoryUuid;

  LookupItem({
    required this.uuid,
    required this.code,
    required this.name,
    required this.lookupType,
    this.status,
    this.displayOrder,
    this.parentUuid,
    this.customerTypeUuid,
    this.subTypeUuid,
    this.channelUuid,
    this.segmentUuid,
    this.categoryUuid,
  });

  factory LookupItem.fromJson(Map<String, dynamic> json) {
    return LookupItem(
      uuid: (json['uuid'] ?? json['id'] ?? '').toString(),
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      lookupType: (json['lookupType'] ?? json['type'] ?? '').toString(),
      status: json['status']?.toString(),
      displayOrder: json['displayOrder'] is int ? json['displayOrder'] as int : (json['displayOrder'] as num?)?.toInt(),
      parentUuid: json['parentUuid']?.toString() ?? json['parentId']?.toString(),
      customerTypeUuid: json['customerTypeUuid']?.toString() ?? json['customerTypeId']?.toString(),
      subTypeUuid: json['subTypeUuid']?.toString() ?? json['subTypeId']?.toString(),
      channelUuid: json['channelUuid']?.toString() ?? json['channelId']?.toString(),
      segmentUuid: json['segmentUuid']?.toString() ?? json['segmentId']?.toString(),
      categoryUuid: json['categoryUuid']?.toString() ?? json['categoryId']?.toString(),
    );
  }

  bool get isActive => status == null || status?.toUpperCase() == 'ACTIVE' || status?.isEmpty == true;
}

class BeatItem {
  final String uuid;
  final String name;
  final String? status;
  final String? territoryUuid;

  BeatItem({
    required this.uuid,
    required this.name,
    this.status,
    this.territoryUuid,
  });

  factory BeatItem.fromJson(Map<String, dynamic> json) {
    return BeatItem(
      uuid: (json['uuid'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Unknown Beat').toString(),
      status: json['status']?.toString(),
      territoryUuid: json['territoryUuid']?.toString() ?? json['territoryId']?.toString(),
    );
  }

  bool get isActive => status == null || status?.toUpperCase() == 'ACTIVE' || status?.isEmpty == true;
}
