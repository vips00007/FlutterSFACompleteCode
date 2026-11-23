import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../data/datasource/remote/visit_plans_api_service.dart';
import '../../data/models/visit_plan_models.dart';

class VisitPlan {
  final String uuid;
  final String displayId;
  final String date;
  final String status;
  final List<CustomerInPlan> customers;

  VisitPlan({
    this.uuid = '',
    this.displayId = '',
    required this.date,
    required this.status,
    required this.customers,
  });
}

class CustomerInPlan {
  final String name;
  final String phone;
  final String role;
  final String area;
  final String city;

  CustomerInPlan({
    required this.name,
    required this.phone,
    required this.role,
    this.area = '',
    this.city = '',
  });
}

class VisitPlansViewModel extends GetxController {
  final VisitPlansApiService _apiService = Get.isRegistered<VisitPlansApiService>()
      ? Get.find<VisitPlansApiService>()
      : VisitPlansApiService();

  final selectedView = 'Self'.obs; // Self or Team
  final selectedDateIndex = 0.obs;
  final visitPlans = <VisitPlan>[].obs;
  final apiVisitPlans = <VisitPlanModel>[].obs;
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
        final List<VisitPlan> loadedPlans = res.content.map((model) {
          final custs = model.customers.map((c) => CustomerInPlan(
            name: c.displayShopName,
            phone: c.displayPhone != 'Not Available' ? c.displayPhone : (c.displayCustomerCode != 'Not Available' ? c.displayCustomerCode : 'N/A'),
            role: c.customerType ?? 'Customer',
            area: c.displayArea,
            city: c.displayCity,
          )).toList();

          return VisitPlan(
            uuid: model.uuid,
            displayId: model.displayId,
            date: model.displayDateRange,
            status: model.displayStatus,
            customers: custs,
          );
        }).toList();

        visitPlans.assignAll(loadedPlans);
      }
    } catch (e) {
      if (kDebugMode) {
        print("API error in VisitPlansViewModel: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  void loadMockData() {
    visitPlans.assignAll([
      VisitPlan(
        date: '23 Aug 2026',
        status: 'Pending',
        customers: [
          CustomerInPlan(
            name: 'Retailer',
            role: 'Retailer',
            phone: '9847973183',
          ),
          CustomerInPlan(
            name: 'Mechanic',
            role: 'Mechanic',
            phone: '9715140460',
          ),
        ],
      ),
    ]);
  }

  void changeView(String view) {
    selectedView.value = view;
  }

  void changeDate(int index) {
    selectedDateIndex.value = index;
  }
}
