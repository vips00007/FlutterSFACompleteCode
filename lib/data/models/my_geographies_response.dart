class MyGeographiesResponse {
  final bool success;
  final String code;
  final String message;
  final List<GeographyItem> data;

  MyGeographiesResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory MyGeographiesResponse.fromJson(Map<String, dynamic> json) {
    List<GeographyItem> items = [];
    if (json['data'] != null) {
      if (json['data'] is List) {
        items = (json['data'] as List)
            .map((e) => GeographyItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (json['data'] is Map<String, dynamic>) {
        final dataMap = json['data'] as Map<String, dynamic>;
        final list = dataMap['content'] ?? dataMap['items'] ?? dataMap['geographies'] ?? dataMap['contentList'];
        if (list is List) {
          items = list.map((e) => GeographyItem.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
    }
    return MyGeographiesResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: items,
    );
  }
}

class GeographyItem {
  final String uuid;
  final String name;
  final String? code;
  final String? type;
  final bool? isPrimary;
  final Map<String, dynamic> rawJson;

  GeographyItem({
    required this.uuid,
    required this.name,
    this.code,
    this.type,
    this.isPrimary,
    required this.rawJson,
  });

  factory GeographyItem.fromJson(Map<String, dynamic> json) {
    bool? primary;
    if (json['isPrimary'] != null) {
      primary = json['isPrimary'] is bool
          ? json['isPrimary'] as bool
          : json['isPrimary'].toString().toLowerCase() == 'true';
    } else if (json['primary'] != null) {
      primary = json['primary'] is bool
          ? json['primary'] as bool
          : json['primary'].toString().toLowerCase() == 'true';
    }

    final String parsedUuid = (json['uuid'] ??
            json['destinationGeoGraphyUuid'] ??
            json['destinationGeographyUuid'] ??
            json['geographyUuid'] ??
            json['geoGraphyUuid'] ??
            json['geographyId'] ??
            json['geoGraphyId'] ??
            json['id'] ??
            '').toString();

    final String parsedName = (json['name'] ??
            json['geographyName'] ??
            json['geoGraphyName'] ??
            json['destinationGeoGraphyName'] ??
            json['destinationGeographyName'] ??
            json['title'] ??
            'Unknown Geography').toString();

    return GeographyItem(
      uuid: parsedUuid,
      name: parsedName,
      code: json['code']?.toString(),
      type: json['type']?.toString(),
      isPrimary: primary,
      rawJson: json,
    );
  }

  /// Fallback getter to ensure a valid UUID is returned even if the API JSON key varies
  String get effectiveUuid {
    if (uuid.trim().isNotEmpty) return uuid.trim();
    for (final entry in rawJson.entries) {
      final key = entry.key.toLowerCase();
      if ((key.contains('uuid') || key.contains('id')) && entry.value != null) {
        final val = entry.value.toString().trim();
        if (val.isNotEmpty) return val;
      }
    }
    return '';
  }
}
