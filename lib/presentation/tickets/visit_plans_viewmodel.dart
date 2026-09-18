import 'package:get/get.dart';

class VisitPlan {
  final String date;
  final String status;
  final List<CustomerInPlan> customers;

  VisitPlan({
    required this.date,
    required this.status,
    required this.customers,
  });
}

class CustomerInPlan {
  final String name;
  final String phone;
  final String role;

  CustomerInPlan({required this.name, required this.phone, required this.role});
}

class VisitPlansViewModel extends GetxController {
  final selectedView = 'Self'.obs; // Self or Team
  final selectedDateIndex = 0.obs;
  final visitPlans = <VisitPlan>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    visitPlans.assignAll([
      VisitPlan(
        date: '23 Aug 2026',
        status: 'Closed',
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
