import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddOutletViewModel extends GetxController {
  // Classification
  final customerType = ''.obs;
  final customerTypes = ['Distributor', 'Retailer', 'Wholesaler'].obs;

  // Personal Details
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final firmNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final isSameAsName = false.obs;

  // Location
  final addressController = TextEditingController();
  final state = ''.obs;
  final district = ''.obs;
  final city = ''.obs;
  final pinCodeController = TextEditingController();

  final states = ['Madhya Pradesh', 'Maharashtra', 'Delhi', 'Gujarat'].obs;
  final districts = ['Indore', 'Bhopal', 'Mumbai', 'Pune'].obs;
  final cities = ['Indore', 'Rau', 'Bhopal City'].obs;

  // Attachments
  final photos = <String>[].obs;

  final isLoading = false.obs;

  void toggleSameAsName(bool? value) {
    isSameAsName.value = value ?? false;
    if (isSameAsName.value) {
      firmNameController.text =
          '${firstNameController.text} ${lastNameController.text}'.trim();
    }
  }

  Future<void> saveOutlet() async {
    // Validation logic
    if (customerType.value.isEmpty) {
      Get.snackbar('Error', 'Please select customer type');
      return;
    }

    isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar('Success', 'Outlet saved successfully');
      // Reset form or navigate back
    } catch (e) {
      Get.snackbar('Error', 'Failed to save outlet');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    firmNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    pinCodeController.dispose();
    super.onClose();
  }
}
