import 'package:intl/intl.dart';

class VisitPlanResponseModel {
  final bool success;
  final String code;
  final String message;
  final List<VisitPlanModel> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  VisitPlanResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory VisitPlanResponseModel.fromJson(Map<String, dynamic> json) {
    List<VisitPlanModel> list = [];

    final rawData = json['data'];
    if (rawData is Map<String, dynamic>) {
      final rawContent = rawData['content'] ?? rawData['items'] ?? rawData['data'];
      if (rawContent is List) {
        list = rawContent
            .whereType<Map<String, dynamic>>()
            .map((e) => VisitPlanModel.fromJson(e))
            .toList();
      }
    } else if (rawData is List) {
      list = rawData
          .whereType<Map<String, dynamic>>()
          .map((e) => VisitPlanModel.fromJson(e))
          .toList();
    } else if (json['content'] is List) {
      list = (json['content'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => VisitPlanModel.fromJson(e))
          .toList();
    }

    final pageObj = rawData is Map<String, dynamic> ? rawData : json;

    return VisitPlanResponseModel(
      success: json['success'] ?? true,
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      content: list,
      page: pageObj['page'] is int ? pageObj['page'] : (pageObj['page'] as num?)?.toInt() ?? 0,
      size: pageObj['size'] is int ? pageObj['size'] : (pageObj['size'] as num?)?.toInt() ?? 20,
      totalElements: pageObj['totalElements'] is int
          ? pageObj['totalElements']
          : (pageObj['totalElements'] as num?)?.toInt() ?? list.length,
      totalPages: pageObj['totalPages'] is int
          ? pageObj['totalPages']
          : (pageObj['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}

class VisitPlanModel {
  final String uuid;
  final String? planType;
  final String? status;
  final String? fromDate;
  final String? toDate;
  final String? remark;
  final int? customerCountTotal;
  final int? customerCount;
  final List<VisitPlanCustomerModel> customers;
  final List<VisitPlanDayModel> days;
  final String? destinationGeographyUuid;
  final String? destinationGeographyName;

  VisitPlanModel({
    required this.uuid,
    this.planType,
    this.status,
    this.fromDate,
    this.toDate,
    this.remark,
    this.customerCountTotal,
    this.customerCount,
    required this.customers,
    required this.days,
    this.destinationGeographyUuid,
    this.destinationGeographyName,
  });

  factory VisitPlanModel.fromJson(Map<String, dynamic> json) {
    List<VisitPlanCustomerModel> custList = [];
    if (json['customers'] is List) {
      custList = (json['customers'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => VisitPlanCustomerModel.fromJson(e))
          .toList();
    }

    List<VisitPlanDayModel> dayList = [];
    if (json['days'] is List) {
      dayList = (json['days'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => VisitPlanDayModel.fromJson(e))
          .toList();
    }

    return VisitPlanModel(
      uuid: (json['uuid'] ?? json['id'] ?? '').toString(),
      planType: json['planType']?.toString(),
      status: json['status']?.toString(),
      fromDate: json['fromDate']?.toString() ?? json['date']?.toString(),
      toDate: json['toDate']?.toString() ?? json['date']?.toString(),
      remark: json['remark']?.toString() ?? json['rejectionRemark']?.toString() ?? json['note']?.toString(),
      customerCountTotal: json['customerCountTotal'] is int
          ? json['customerCountTotal'] as int
          : (json['customerCountTotal'] as num?)?.toInt(),
      customerCount: json['customerCount'] is int
          ? json['customerCount'] as int
          : (json['customerCount'] as num?)?.toInt(),
      customers: custList,
      days: dayList,
      destinationGeographyUuid: json['destinationGeographyUuid']?.toString() ?? json['destinationGeoGraphyUuid']?.toString(),
      destinationGeographyName: json['destinationGeographyName']?.toString() ?? json['destinationName']?.toString(),
    );
  }

  /// Dynamic ID generation requirement:
  /// Prefix `PLN-` followed by the first 4 characters of the plan's `uuid` in uppercase.
  /// Example: If UUID is `c0064785-45f7-4e52-b463-388c60e84700`, display `PLN-C006`.
  String get displayId {
    if (uuid.trim().isEmpty) return 'PLN-N/A';
    final cleanUuid = uuid.replaceAll('-', '').trim();
    if (cleanUuid.isEmpty) return 'PLN-N/A';
    final prefixChars = cleanUuid.length >= 4 ? cleanUuid.substring(0, 4) : cleanUuid;
    return 'PLN-${prefixChars.toUpperCase()}';
  }

  /// Status Display Requirement:
  /// For API status `PENDING_APPROVAL`, display only **Pending** in UI.
  String get displayStatus {
    final raw = (status ?? '').trim().toUpperCase();
    if (raw == 'PENDING_APPROVAL' || raw == 'PENDING' || raw.startsWith('PENDING')) {
      return 'Pending';
    } else if (raw == 'APPROVED' || raw == 'COMPLETED') {
      return 'Approved';
    } else if (raw == 'REJECTED' || raw == 'CANCELLED') {
      return 'Rejected';
    } else if (raw.isNotEmpty) {
      // Title case fallback
      return raw[0] + raw.substring(1).toLowerCase().replaceAll('_', ' ');
    }
    return 'Pending';
  }

  /// Display Plan Type (Local / Upcountry / Outstation)
  String get displayPlanType {
    final raw = (planType ?? '').trim().toUpperCase();
    if (raw == 'LOCAL') return 'Local';
    if (raw == 'OUTSTATION' || raw == 'UPCOUNTRY') return 'Upcountry';
    if (raw.isNotEmpty) return raw[0] + raw.substring(1).toLowerCase();
    return 'Not Available';
  }

  int get totalCustomerCount {
    if (customerCountTotal != null && customerCountTotal! > 0) return customerCountTotal!;
    if (customerCount != null && customerCount! > 0) return customerCount!;
    if (customers.isNotEmpty) return customers.length;
    int sum = 0;
    for (var d in days) {
      sum += d.customers.length;
    }
    return sum;
  }

  String get displayFromDate {
    if (fromDate == null || fromDate!.trim().isEmpty) return 'Not Available';
    return _formatDate(fromDate!);
  }

  String get displayToDate {
    if (toDate == null || toDate!.trim().isEmpty) return 'Not Available';
    return _formatDate(toDate!);
  }

  String get displayDateRange {
    final f = displayFromDate;
    final t = displayToDate;

    if (f == 'Not Available' && t == 'Not Available') return 'Not Available';
    if (f == 'Not Available') return t;
    if (t == 'Not Available' || f == t) return f;
    return '$f → $t';
  }

  String get displayRemark {
    if (remark == null || remark!.trim().isEmpty) return 'Not Available';
    return remark!.trim();
  }

  static String _formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(d);
    } catch (_) {
      return dateStr;
    }
  }
}

class VisitPlanCustomerModel {
  final String? uuid;
  final String? shopName;
  final String? customerCode;
  final String? area;
  final String? city;
  final String? ownerName;
  final String? phone;
  final String? customerType;
  final bool removedByApprover;
  final String? removedNote;

  VisitPlanCustomerModel({
    this.uuid,
    this.shopName,
    this.customerCode,
    this.area,
    this.city,
    this.ownerName,
    this.phone,
    this.customerType,
    this.removedByApprover = false,
    this.removedNote,
  });

  factory VisitPlanCustomerModel.fromJson(Map<String, dynamic> json) {
    return VisitPlanCustomerModel(
      uuid: json['uuid']?.toString() ?? json['id']?.toString() ?? json['customerUuid']?.toString(),
      shopName: json['shopName']?.toString() ?? json['customerName']?.toString() ?? json['name']?.toString(),
      customerCode: json['customerCode']?.toString() ?? json['code']?.toString(),
      area: json['area']?.toString() ?? json['locality']?.toString(),
      city: json['city']?.toString() ?? json['district']?.toString(),
      ownerName: json['ownerName']?.toString() ?? json['owner']?.toString() ?? json['contactPerson']?.toString(),
      phone: json['phone']?.toString() ?? json['mobileNumber']?.toString() ?? json['contactNumber']?.toString(),
      customerType: json['customerType']?.toString() ?? json['type']?.toString(),
      removedByApprover: json['removedByApprover'] == true || json['isRemoved'] == true,
      removedNote: json['removedNote']?.toString() ?? json['removalReason']?.toString() ?? json['removedReason']?.toString(),
    );
  }

  String get displayShopName {
    if (shopName != null && shopName!.trim().isNotEmpty) return shopName!.trim();
    return 'Not Available';
  }

  String get displayCustomerCode {
    if (customerCode != null && customerCode!.trim().isNotEmpty) return customerCode!.trim();
    return 'Not Available';
  }

  String get displayArea {
    if (area != null && area!.trim().isNotEmpty) return area!.trim();
    return 'Not Available';
  }

  String get displayCity {
    if (city != null && city!.trim().isNotEmpty) return city!.trim();
    return 'Not Available';
  }

  String get displayOwnerName {
    if (ownerName != null && ownerName!.trim().isNotEmpty) return ownerName!.trim();
    return 'Not Available';
  }

  String get displayPhone {
    if (phone != null && phone!.trim().isNotEmpty) return phone!.trim();
    return 'Not Available';
  }

  String get displayLocation {
    final a = area?.trim() ?? '';
    final c = city?.trim() ?? '';
    if (a.isNotEmpty && c.isNotEmpty) return '$a, $c';
    if (a.isNotEmpty) return a;
    if (c.isNotEmpty) return c;
    return 'Not Available';
  }
}

class VisitPlanDayModel {
  final String? date;
  final List<VisitPlanCustomerModel> customers;
  final bool removedByApprover;
  final String? removedNote;

  VisitPlanDayModel({
    this.date,
    required this.customers,
    this.removedByApprover = false,
    this.removedNote,
  });

  factory VisitPlanDayModel.fromJson(Map<String, dynamic> json) {
    List<VisitPlanCustomerModel> custList = [];
    if (json['customers'] is List) {
      custList = (json['customers'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => VisitPlanCustomerModel.fromJson(e))
          .toList();
    }

    return VisitPlanDayModel(
      date: json['date']?.toString(),
      customers: custList,
      removedByApprover: json['removedByApprover'] == true || json['isRemoved'] == true,
      removedNote: json['removedNote']?.toString() ?? json['removalReason']?.toString(),
    );
  }

  String get displayDate {
    if (date == null || date!.trim().isEmpty) return 'Not Available';
    try {
      final d = DateTime.parse(date!.trim());
      return DateFormat('dd MMM yyyy').format(d);
    } catch (_) {
      return date!.trim();
    }
  }
}
