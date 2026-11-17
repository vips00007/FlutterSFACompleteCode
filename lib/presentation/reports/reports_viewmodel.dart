import 'package:get/get.dart';
import '../../data/models/reports_models.dart';
import '../../domain/repositories/reports_repository.dart';

class ReportsViewModel extends GetxController {
  final ReportsRepository _repository;

  ReportsViewModel(this._repository);

  final RxString selectedTimeRange = 'This Month'.obs;
  final RxInt selectedTabIndex = 0.obs; // 0: Sales, 1: Visits, 2: Collections
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<ReportsData> reportsData = Rxn<ReportsData>();

  @override
  void onInit() {
    super.onInit();
    fetchReportsData();
  }

  Future<void> fetchReportsData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await _repository.getReportsData(selectedTimeRange.value);
      reportsData.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void selectTimeRange(String range) {
    if (selectedTimeRange.value != range) {
      selectedTimeRange.value = range;
      fetchReportsData();
    }
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }
}
