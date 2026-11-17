import 'package:get/get.dart';
import '../../domain/repositories/leave_repository.dart';
import '../../data/models/leave_models.dart';
import '../../routes/route_names.dart';

class LeaveDashboardViewModel extends GetxController {
  final LeaveRepository _repository;

  LeaveDashboardViewModel(this._repository);

  final isLoading = false.obs;
  final balance = Rxn<LeaveBalance>();
  final history = <LeaveHistoryItem>[].obs;
  final pendingApprovals = 2.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final bal = await _repository.getLeaveBalance();
      final hist = await _repository.getLeaveHistory();
      balance.value = bal;
      history.assignAll(hist);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch leave data');
    } finally {
      isLoading.value = false;
    }
  }

  void goToApplyLeave() {
    Get.toNamed(RoutesName.apply_leave_view)?.then((_) => fetchData());
  }

  void goToRequestDetails(LeaveHistoryItem item) {
    Get.toNamed(RoutesName.leave_request_details_view, arguments: item)?.then((_) => fetchData());
  }
}
