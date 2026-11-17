import '../../domain/repositories/leave_repository.dart';
import '../datasource/remote/leave_api_service.dart';
import '../models/leave_models.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveApiService _apiService;

  LeaveRepositoryImpl(this._apiService);

  @override
  Future<LeaveBalance> getLeaveBalance() {
    return _apiService.getLeaveBalance();
  }

  @override
  Future<List<LeaveHistoryItem>> getLeaveHistory() {
    return _apiService.getLeaveHistory();
  }

  @override
  Future<LeaveHistoryItem> submitLeaveRequest(LeaveRequestPayload request) {
    return _apiService.submitLeaveRequest(request);
  }

  @override
  Future<void> cancelLeaveRequest(String id) {
    return _apiService.cancelLeaveRequest(id);
  }
}
