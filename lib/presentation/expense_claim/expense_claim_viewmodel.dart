import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../tickets/create_tour_plan_bottom_sheet.dart';
import '../tickets/create_tour_plan_viewmodel.dart';

class ExpenseClaimViewModel extends GetxController {
  var selectedTab = 0.obs; // 0 for Local, 1 for Outstation

  var claims = <ClaimModel>[].obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void selectLocalTour() {
    Get.back();
    final createVm = Get.put(CreateTourPlanViewModel());
    createVm.reset();
    createVm.setTab(0);
    Get.bottomSheet(
      const CreateTourPlanBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void selectOutstationTour() {
    Get.back();
    final createVm = Get.put(CreateTourPlanViewModel());
    createVm.reset();
    createVm.setTab(1);
    Get.bottomSheet(
      const CreateTourPlanBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void cancelClaim(int index) {
    // Logic to cancel a claim
  }
}

class ClaimModel {
  final String dateRange;
  final String status;
  final String description;

  ClaimModel({
    required this.dateRange,
    required this.status,
    required this.description,
  });
}
