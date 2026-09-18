import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTourPlanViewModel extends GetxController {
  final selectedTabIndex = 0.obs; // 0: Local, 1: Outstation

  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();

  final travelPurpose = ''.obs;
  final selectedCities = <String>[].obs;

  String get startDateText =>
      startDate.value != null ? _formatDate(startDate.value!) : 'Start date';

  String get endDateText =>
      endDate.value != null ? _formatDate(endDate.value!) : 'End date';

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}";
  }

  void setTab(int index) {
    selectedTabIndex.value = index;
  }

  void reset() {
    startDate.value = null;
    endDate.value = null;
    travelPurpose.value = '';
    selectedCities.clear();
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      startDate.value = picked;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      endDate.value = picked;
    }
  }

  void createPlan() {
    // Implement creation logic here
    Get.back();
    Get.snackbar(
      'Success',
      'Tour plan created successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade900,
    );
  }
}
