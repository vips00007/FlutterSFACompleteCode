class GeographyResponse {
  final bool success;
  final String code;
  final String message;
  final GeographyData data;

  GeographyResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory GeographyResponse.fromJson(Map<String, dynamic> json) {
    return GeographyResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? GeographyData.fromJson(json['data'])
          : GeographyData(items: []),
    );
  }
}

class GeographyData {
  final List<GeographyItem> items;

  GeographyData({required this.items});

  factory GeographyData.fromJson(List<dynamic> json) {
    return GeographyData(
      items: json.map((e) => GeographyItem.fromJson(e)).toList(),
    );
  }
}

class GeographyItem {
  final String uuid;
  final String type;
  final String code;
  final String name;
  final String? parentUuid;

  GeographyItem({
    required this.uuid,
    required this.type,
    required this.code,
    required this.name,
    this.parentUuid,
  });

  factory GeographyItem.fromJson(Map<String, dynamic> json) {
    return GeographyItem(
      uuid: json['uuid'] ?? '',
      type: json['type'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      parentUuid: json['parentUuid'],
    );
  }
}
