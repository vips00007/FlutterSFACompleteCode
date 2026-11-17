import 'package:get/get.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../data/models/regularization_status_response.dart';

class RegularizationRequestStatusViewModel extends GetxController {
  final AttendanceRepository _repository;

  RegularizationRequestStatusViewModel(this._repository);

  final isLoading = true.obs;
  final statusData = Rxn<RegularizationStatusData>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final String? requestId = Get.arguments as String?;
    if (requestId != null) {
      fetchStatus(requestId);
    } else {
      // Mocking fetch for testing flow
      fetchStatus('REG-240922');
    }
  }

  Future<void> fetchStatus(String requestId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _repository.getRegularizationStatus(requestId);
      if (response.success && response.data != null) {
        statusData.value = response.data;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void done() {
    // Navigate back to the calendar
    Get.until((route) => route.settings.name == '/attendance_calendar_view' || route.settings.name == '/dashboard_view');
  }
}
