class LeaveBalance {
  final int totalAvailable;
  final int clAvailable;
  final int clTotal;
  final int slAvailable;
  final int slTotal;
  final int elAvailable;
  final int elTotal;

  LeaveBalance({
    required this.totalAvailable,
    required this.clAvailable,
    required this.clTotal,
    required this.slAvailable,
    required this.slTotal,
    required this.elAvailable,
    required this.elTotal,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      totalAvailable: json['totalAvailable'] ?? 0,
      clAvailable: json['clAvailable'] ?? 0,
      clTotal: json['clTotal'] ?? 0,
      slAvailable: json['slAvailable'] ?? 0,
      slTotal: json['slTotal'] ?? 0,
      elAvailable: json['elAvailable'] ?? 0,
      elTotal: json['elTotal'] ?? 0,
    );
  }
}

class LeaveHistoryItem {
  final String id;
  final String leaveType;
  final String dateRange;
  final String status;
  final String appliedOn;
  final String reason;
  final String reportingManager;
  final String duration;
  final String? submittedAt;
  final String? approvedAt;
  final String? cancelledAt;

  LeaveHistoryItem({
    required this.id,
    required this.leaveType,
    required this.dateRange,
    required this.status,
    required this.appliedOn,
    required this.reason,
    required this.reportingManager,
    required this.duration,
    this.submittedAt,
    this.approvedAt,
    this.cancelledAt,
  });
}

class LeaveRequestPayload {
  final String leaveType;
  final String fromDate;
  final String toDate;
  final String duration;
  final String reason;
  final String? attachmentPath;

  LeaveRequestPayload({
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.duration,
    required this.reason,
    this.attachmentPath,
  });
}
