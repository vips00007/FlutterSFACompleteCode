import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../data/models/regularization_request.dart';
import '../../routes/route_names.dart';

class ApplyRegularizationViewModel extends GetxController {
  final AttendanceRepository _repository;

  ApplyRegularizationViewModel(this._repository);

  final date = '22 Sep 2026'.obs;
  
  final reason = 'Missed checkout'.obs;
  final reasonsList = ['Missed checkout', 'Missed check-in', 'System error', 'Other'];
  
  final correctLogin = ''.obs;
  final correctLogout = ''.obs;
  final note = ''.obs;

  final isLoading = false.obs;

  Future<void> selectLoginTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      correctLogin.value = picked.format(context);
    }
  }

  Future<void> selectLogoutTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      correctLogout.value = picked.format(context);
    }
  }

  Future<void> submitRequest() async {
    if (correctLogin.value.isEmpty || correctLogout.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select correct login and logout times', 
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final request = RegularizationRequest(
        date: date.value,
        reason: reason.value,
        correctLogin: correctLogin.value,
        correctLogout: correctLogout.value,
        note: note.value.isNotEmpty ? note.value : null,
      );

      final response = await _repository.applyRegularization(request);
      
      if (response.success && response.data != null) {
        Get.offNamed(RoutesName.regularization_request_status_view, arguments: response.data!.requestId);
      } else {
        Get.snackbar('Error', response.message, 
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), 
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
