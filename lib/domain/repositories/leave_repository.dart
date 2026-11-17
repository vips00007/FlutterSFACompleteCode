import '../../data/models/leave_models.dart';

abstract class LeaveRepository {
  Future<LeaveBalance> getLeaveBalance();
  Future<List<LeaveHistoryItem>> getLeaveHistory();
  Future<LeaveHistoryItem> submitLeaveRequest(LeaveRequestPayload request);
  Future<void> cancelLeaveRequest(String id);
}
