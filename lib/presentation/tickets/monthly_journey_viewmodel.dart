import 'package:get/get.dart';

class JourneyPlan {
  final String dateRange;
  final String type;
  final String status;
  final String remark;

  JourneyPlan({
    required this.dateRange,
    required this.type,
    required this.status,
    required this.remark,
  });
}

class MonthlyJourneyViewModel extends GetxController {
  final journeyPlans = <JourneyPlan>[].obs;
  final selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    journeyPlans.assignAll([
      JourneyPlan(
        dateRange: '04 Jun - 25 Jun 2026',
        type: 'Local',
        status: 'Pending',
        remark: 'test',
      ),
    ]);
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
