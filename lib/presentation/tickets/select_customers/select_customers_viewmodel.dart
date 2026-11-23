import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/datasource/remote/visit_plans_api_service.dart';
import '../../../domain/entities/outlet.dart';
import '../../../routes/route_names.dart';

class SelectCustomersViewModel extends GetxController {
  final VisitPlansApiService _apiService = Get.isRegistered<VisitPlansApiService>()
      ? Get.find<VisitPlansApiService>()
      : VisitPlansApiService();

  final customers = <Outlet>[].obs;
  final selectedCustomers = <Outlet>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    isLoading.value = true;
    errorMessage.value = '';
    customers.clear();

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final res = await _apiService.getVisitPlanCustomers(
        planType: 'LOCAL',
        type: 'ALL',
        date: dateStr,
        page: 0,
        size: 100,
      );

      final list = res.data?.content ?? [];
      final outlets = list.map((c) {
        final name = c.shopName?.isNotEmpty == true ? c.shopName! : 'Not Available';
        return Outlet(
          id: c.uuid,
          customerType: c.customerType ?? 'Retailer',
          firstName: name,
          lastName: '',
          firmName: name,
          mobileNumber: c.customerCode ?? 'Not Available',
          email: '',
          address: '',
          state: '',
          district: '',
          city: c.city ?? 'Not Available',
          pinCode: '',
          photos: [],
          area: c.area,
        );
      }).toList();

      customers.assignAll(outlets);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      if (kDebugMode) {
        print("API fetchCustomers error in SelectCustomersViewModel: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSelection(Outlet outlet) {
    if (selectedCustomers.contains(outlet)) {
      selectedCustomers.remove(outlet);
    } else {
      selectedCustomers.add(outlet);
    }
  }

  bool isSelected(Outlet outlet) {
    return selectedCustomers.contains(outlet);
  }

  void proceedToReview() {
    if (selectedCustomers.isNotEmpty) {
      Get.toNamed(RoutesName.review_plan_view, arguments: selectedCustomers.toList());
    } else {
      Get.snackbar('Selection required', 'Please add at least one customer to proceed.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
