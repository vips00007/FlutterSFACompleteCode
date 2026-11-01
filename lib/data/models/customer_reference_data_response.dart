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
      status: json['status'] ?? '',
      message: json['message'] ?? '',
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
              ?.map((e) => CustomerTypeModel.fromJson(e))
              .toList() ??
          [],
      groups: json['groups'] ?? [],
      lookups: (json['lookups'] as List?)
              ?.map((e) => LookupItem.fromJson(e))
              .toList() ??
          [],
      beats: (json['beats'] as List?)
              ?.map((e) => BeatItem.fromJson(e))
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
      uuid: json['uuid'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
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
      uuid: json['uuid'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      lookupType: json['lookupType'] ?? '',
      status: json['status'],
      displayOrder: json['displayOrder'],
      parentUuid: json['parentUuid'],
      customerTypeUuid: json['customerTypeUuid'],
      subTypeUuid: json['subTypeUuid'],
      channelUuid: json['channelUuid'],
      segmentUuid: json['segmentUuid'],
      categoryUuid: json['categoryUuid'],
    );
  }

  bool get isActive => status == 'ACTIVE';
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
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      status: json['status'],
      territoryUuid: json['territoryUuid'],
    );
  }

  bool get isActive => status == 'ACTIVE';
}
