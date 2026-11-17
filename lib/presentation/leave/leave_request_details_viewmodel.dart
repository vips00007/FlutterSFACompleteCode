import 'package:get/get.dart';
import '../../domain/repositories/leave_repository.dart';
import '../../data/models/leave_models.dart';

class LeaveRequestDetailsViewModel extends GetxController {
  final LeaveRepository _repository;

  LeaveRequestDetailsViewModel(this._repository);

  final leaveItem = Rxn<LeaveHistoryItem>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final item = Get.arguments as LeaveHistoryItem?;
    if (item != null) {
      leaveItem.value = item;
    }
  }

  Future<void> cancelLeave() async {
    if (leaveItem.value == null) return;
    
    isLoading.value = true;
    try {
      await _repository.cancelLeaveRequest(leaveItem.value!.id);
      
      // Update local state to reflect cancellation
      final current = leaveItem.value!;
      leaveItem.value = LeaveHistoryItem(
        id: current.id,
        leaveType: current.leaveType,
        dateRange: current.dateRange,
        status: 'Cancelled',
        appliedOn: current.appliedOn,
        reason: current.reason,
        reportingManager: current.reportingManager,
        duration: current.duration,
        submittedAt: current.submittedAt,
        approvedAt: current.approvedAt,
        cancelledAt: 'Cancelled by you',
      );
      
      Get.back(); // close bottom sheet
      Get.snackbar('Success', 'Leave request cancelled successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel request');
    } finally {
      isLoading.value = false;
    }
  }
}
