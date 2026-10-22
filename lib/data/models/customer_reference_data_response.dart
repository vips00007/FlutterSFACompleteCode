class CustomerReferenceDataResponse {
  final bool success;
  final String code;
  final String message;
  final CustomerReferenceData data;

  CustomerReferenceDataResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CustomerReferenceDataResponse.fromJson(Map<String, dynamic> json) {
    return CustomerReferenceDataResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? CustomerReferenceData.fromJson(json['data'])
          : CustomerReferenceData(customerTypes: [], lookups: [], beats: []),
    );
  }
}

class CustomerReferenceData {
  final List<CustomerTypeModel> customerTypes;
  final List<LookupItem> lookups;
  final List<BeatItem> beats;

  CustomerReferenceData({
    required this.customerTypes,
    required this.lookups,
    required this.beats,
  });

  factory CustomerReferenceData.fromJson(Map<String, dynamic> json) {
    var typesList = json['customerTypes'] as List? ?? [];
    var lookupsList = json['lookups'] as List? ?? [];
    var beatsList = json['beats'] as List? ?? [];
    return CustomerReferenceData(
      customerTypes: typesList.map((e) => CustomerTypeModel.fromJson(e)).toList(),
      lookups: lookupsList.map((e) => LookupItem.fromJson(e)).toList(),
      beats: beatsList.map((e) => BeatItem.fromJson(e)).toList(),
    );
  }
}

class LookupItem {
  final String uuid;
  final String name;
  final String lookupType;
  final String? customerTypeUuid;
  final String? subTypeUuid;
  final String? channelUuid;
  final String? segmentUuid;
  final String? categoryUuid;
  final int? displayOrder;
  final bool isActive;

  LookupItem({
    required this.uuid,
    required this.name,
    required this.lookupType,
    this.customerTypeUuid,
    this.subTypeUuid,
    this.channelUuid,
    this.segmentUuid,
    this.categoryUuid,
    this.displayOrder,
    this.isActive = true,
  });

  factory LookupItem.fromJson(Map<String, dynamic> json) {
    return LookupItem(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      lookupType: json['lookupType'] ?? '',
      customerTypeUuid: json['customerTypeUuid'],
      subTypeUuid: json['subTypeUuid'],
      channelUuid: json['channelUuid'],
      segmentUuid: json['segmentUuid'],
      categoryUuid: json['categoryUuid'],
      displayOrder: json['displayOrder'],
      isActive: json['isActive'] ?? true,
    );
  }
}

class BeatItem {
  final String uuid;
  final String name;

  BeatItem({
    required this.uuid,
    required this.name,
  });

  factory BeatItem.fromJson(Map<String, dynamic> json) {
    return BeatItem(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
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
