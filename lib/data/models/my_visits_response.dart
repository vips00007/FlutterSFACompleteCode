import 'package:intl/intl.dart';

class MyVisitsResponse {
  final bool success;
  final String code;
  final String message;
  final MyVisitsData? data;

  MyVisitsResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory MyVisitsResponse.fromJson(Map<String, dynamic> json) {
    return MyVisitsResponse(
      success: json['success'] ?? false,
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? MyVisitsData.fromJson(json['data']) : null,
    );
  }
}

class MyVisitsData {
  final List<MyVisitItem> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  MyVisitsData({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory MyVisitsData.fromJson(Map<String, dynamic> json) {
    return MyVisitsData(
      content: (json['content'] as List?)
              ?.map((e) => MyVisitItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          (json['items'] as List?)
              ?.map((e) => MyVisitItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      page: json['page'] is int ? json['page'] : (json['page'] as num?)?.toInt() ?? 0,
      size: json['size'] is int ? json['size'] : (json['size'] as num?)?.toInt() ?? 20,
      totalElements: json['totalElements'] is int ? json['totalElements'] : (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: json['totalPages'] is int ? json['totalPages'] : (json['totalPages'] as num?)?.toInt() ?? 0,
    );
  }
}

class MyVisitItem {
  final String? uuid;
  final String? planUuid;
  final String? customerUuid;
  final String? customerName;
  final String? customerCode;
  final String? employeeUuid;
  final String? date;
  final String? status;
  final String? area;
  final String? city;
  final String? planType;
  final String? planFromDate;
  final String? planToDate;
  final String? startedAt;
  final String? completedAt;

  MyVisitItem({
    this.uuid,
    this.planUuid,
    this.customerUuid,
    this.customerName,
    this.customerCode,
    this.employeeUuid,
    this.date,
    this.status,
    this.area,
    this.city,
    this.planType,
    this.planFromDate,
    this.planToDate,
    this.startedAt,
    this.completedAt,
  });

  factory MyVisitItem.fromJson(Map<String, dynamic> json) {
    return MyVisitItem(
      uuid: json['uuid']?.toString(),
      planUuid: json['planUuid']?.toString() ?? json['planID']?.toString(),
      customerUuid: json['customerUuid']?.toString(),
      customerName: json['customerName']?.toString() ?? json['shopName']?.toString() ?? json['name']?.toString(),
      customerCode: json['customerCode']?.toString(),
      employeeUuid: json['employeeUuid']?.toString(),
      date: json['date']?.toString(),
      status: json['status']?.toString(),
      area: json['area']?.toString(),
      city: json['city']?.toString(),
      planType: json['planType']?.toString(),
      planFromDate: json['planFromDate']?.toString(),
      planToDate: json['planToDate']?.toString(),
      startedAt: json['startedAt']?.toString(),
      completedAt: json['completedAt']?.toString(),
    );
  }
}

/// Helper model for Grouping visits by `planUuid`
class GroupedPlan {
  final String planUuid;
  final String displayId;
  final String planType;
  final String status;
  final String? fromDate;
  final String? toDate;
  final String when;
  final List<MyVisitItem> customers;
  final int customerCount;
  final String? place;
  final String? remark;

  GroupedPlan({
    required this.planUuid,
    required this.displayId,
    required this.planType,
    required this.status,
    this.fromDate,
    this.toDate,
    required this.when,
    required this.customers,
    required this.customerCount,
    this.place,
    this.remark,
  });

  factory GroupedPlan.fromVisits(String planUuid, List<MyVisitItem> visits) {
    final first = visits.first;
    final rawType = (first.planType ?? 'LOCAL').toUpperCase();
    final isOutstation = rawType == 'OUTSTATION';

    String formattedWhen = '';
    if (isOutstation) {
      // OUTSTATION: display planFromDate to planToDate as a date range
      final from = first.planFromDate ?? first.date ?? '';
      final to = first.planToDate ?? first.date ?? '';
      if (from.isNotEmpty && to.isNotEmpty) {
        if (from == to) {
          formattedWhen = _formatDate(from);
        } else {
          formattedWhen = '${_formatDate(from)} – ${_formatDate(to)}';
        }
      } else if (from.isNotEmpty) {
        formattedWhen = _formatDate(from);
      } else {
        formattedWhen = 'Date N/A';
      }
    } else {
      // LOCAL: display ONLY the date field
      final localDate = first.date ?? first.planFromDate ?? '';
      formattedWhen = localDate.isNotEmpty ? _formatDate(localDate) : 'Date N/A';
    }

    final String displayId = planUuid.length > 8 ? "PLN-${planUuid.substring(0, 8)}" : "PLN-$planUuid";

    final areaSet = visits.map((v) => v.area).where((a) => a != null && a.trim().isNotEmpty).map((a) => a!.trim()).toSet();
    final citySet = visits.map((v) => v.city).where((c) => c != null && c.trim().isNotEmpty).map((c) => c!.trim()).toSet();

    final List<String> locParts = [];
    if (areaSet.isNotEmpty) locParts.add(areaSet.join(', '));
    if (citySet.isNotEmpty) locParts.add(citySet.join(', '));
    final String locationText = locParts.join(' · ');

    // Calculate overall status
    String overallStatus = first.status ?? 'PLANNED';
    if (visits.any((v) => (v.status ?? '').toUpperCase() == 'IN_PROGRESS')) {
      overallStatus = 'IN_PROGRESS';
    } else if (visits.every((v) => (v.status ?? '').toUpperCase() == 'COMPLETED')) {
      overallStatus = 'COMPLETED';
    } else if (visits.every((v) => (v.status ?? '').toUpperCase() == 'MISSED')) {
      overallStatus = 'MISSED';
    }

    return GroupedPlan(
      planUuid: planUuid,
      displayId: displayId,
      planType: isOutstation ? 'OUTSTATION' : 'LOCAL',
      status: overallStatus,
      fromDate: first.planFromDate ?? first.date,
      toDate: first.planToDate ?? first.date,
      when: formattedWhen,
      customers: visits,
      customerCount: visits.length,
      place: locationText,
    );
  }

  static String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return dateString;
    }
  }
}
