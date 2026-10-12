import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveRecord {
  final String type;
  final String startDate;
  final String endDate;
  final String status;
  final String remark;

  LeaveRecord({
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.remark,
  });
}

class LeaveViewModel extends GetxController {
  final leaveRecords = <LeaveRecord>[].obs;
  final selectedTabIndex = 0.obs;

  // Form Controllers
  final leaveTypeController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final remarkController = TextEditingController();

  final leaveTypes = [
    'Planned Leave',
    'Unplanned Leave',
    'Sick Leave',
    'Casual Leave',
  ];

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void submitLeaveRequest() {
    // Mock submission
    Get.back();
    Get.snackbar(
      'Success',
      'Leave request submitted successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
