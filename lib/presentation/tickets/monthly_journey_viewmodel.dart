import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../data/datasource/remote/visit_plans_api_service.dart';
import '../../data/models/visit_plan_models.dart';

class JourneyPlan {
  final String uuid;
  final String displayId;
  final String dateRange;
  final String type;
  final String status;
  final String remark;

  JourneyPlan({
    this.uuid = '',
    this.displayId = '',
    required this.dateRange,
    required this.type,
    required this.status,
    required this.remark,
  });
}

class MonthlyJourneyViewModel extends GetxController {
  final VisitPlansApiService _apiService = Get.isRegistered<VisitPlansApiService>()
      ? Get.find<VisitPlansApiService>()
      : VisitPlansApiService();

  final journeyPlans = <JourneyPlan>[].obs;
  final apiVisitPlans = <VisitPlanModel>[].obs;
  final selectedTabIndex = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
    fetchVisitPlans();
  }

  Future<void> fetchVisitPlans() async {
    isLoading.value = true;
    try {
      final res = await _apiService.getVisitPlans();
      if (res.content.isNotEmpty) {
        apiVisitPlans.assignAll(res.content);
        final loaded = res.content.map((model) {
          return JourneyPlan(
            uuid: model.uuid,
            displayId: model.displayId,
            dateRange: model.displayDateRange,
            type: model.displayPlanType,
            status: model.displayStatus,
            remark: model.displayRemark,
          );
        }).toList();

        journeyPlans.assignAll(loaded);
      }
    } catch (e) {
      if (kDebugMode) {
        print("API error in MonthlyJourneyViewModel: $e");
      }
    } finally {
      isLoading.value = false;
    }
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
