import 'dart:convert';
import 'package:dio/dio.dart';
import '../../models/leave_models.dart';

class LeaveApiService {
  final String baseUrl = "https://api-staging.rahulpatel.online";
  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {"Accept": "application/json"},
      validateStatus: (status) => status != null,
    ),
  );

  // Mocking all endpoints to allow the UI to flow without crashing
  Future<LeaveBalance> getLeaveBalance() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return LeaveBalance(
      totalAvailable: 18,
      clAvailable: 5,
      clTotal: 8,
      slAvailable: 4,
      slTotal: 6,
      elAvailable: 9,
      elTotal: 12,
    );
  }

  Future<List<LeaveHistoryItem>> getLeaveHistory() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      LeaveHistoryItem(
        id: 'LV-260928',
        leaveType: 'Casual Leave',
        dateRange: '28 – 29 Sep',
        status: 'Pending',
        appliedOn: '22 Sep 2026',
        reason: 'Personal work',
        reportingManager: 'Neha Sharma',
        duration: '2 days · First Half',
        submittedAt: '22 Sep · 11:32 AM',
      ),
      LeaveHistoryItem(
        id: 'LV-260912',
        leaveType: 'Sick Leave',
        dateRange: '12 Sep',
        status: 'Approved',
        appliedOn: '10 Sep 2026',
        reason: 'Fever',
        reportingManager: 'Neha Sharma',
        duration: '1 day · Full Day',
        submittedAt: '10 Sep · 09:00 AM',
        approvedAt: '11 Sep · 10:00 AM',
      ),
      LeaveHistoryItem(
        id: 'LV-260818',
        leaveType: 'Earned Leave',
        dateRange: '18 Aug',
        status: 'Rejected',
        appliedOn: '15 Aug 2026',
        reason: 'Family trip',
        reportingManager: 'Neha Sharma',
        duration: '1 day · Full Day',
        submittedAt: '15 Aug · 08:30 AM',
      ),
    ];
  }

  Future<LeaveHistoryItem> submitLeaveRequest(LeaveRequestPayload request) async {
    await Future.delayed(const Duration(seconds: 1));
    return LeaveHistoryItem(
      id: 'LV-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      leaveType: request.leaveType,
      dateRange: '${request.fromDate} - ${request.toDate}',
      status: 'Pending',
      appliedOn: 'Today',
      reason: request.reason,
      reportingManager: 'Neha Sharma',
      duration: request.duration,
      submittedAt: 'Just now',
    );
  }

  Future<void> cancelLeaveRequest(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulated success
  }
}
