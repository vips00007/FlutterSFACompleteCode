import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/repositories/leave_repository.dart';
import '../../data/models/leave_models.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class ApplyLeaveViewModel extends GetxController {
  final LeaveRepository _repository;

  ApplyLeaveViewModel(this._repository);

  final leaveType = 'Casual Leave'.obs;
  final leaveTypes = ['Casual Leave', 'Sick Leave', 'Earned Leave'];
  
  final fromDate = Rxn<DateTime>();
  final toDate = Rxn<DateTime>();
  
  final duration = 'First Half'.obs; // Full Day, First Half, Second Half
  
  final reason = ''.obs;
  final attachmentName = ''.obs;
  final attachmentPath = ''.obs;
  final attachmentSize = ''.obs;

  final isLoading = false.obs;

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      fromDate.value = picked;
      if (toDate.value == null || toDate.value!.isBefore(picked)) {
        toDate.value = picked;
      }
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate.value ?? fromDate.value ?? DateTime.now(),
      firstDate: fromDate.value ?? DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      toDate.value = picked;
    }
  }

  Future<void> pickAttachment() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (file != null && file.path != null) {
        final ioFile = File(file.path!);
        final sizeInBytes = ioFile.lengthSync();
        final sizeInMb = sizeInBytes / (1024 * 1024);
        
        if (sizeInMb > 5) {
          Get.rawSnackbar(
            title: 'Error',
            message: 'File size exceeds 5MB limit.',
            backgroundColor: Colors.red,
          );
          return;
        }

        attachmentPath.value = file.path!;
        attachmentName.value = file.name;
        attachmentSize.value = sizeInMb < 1 
            ? '${(sizeInBytes / 1024).toStringAsFixed(1)} KB'
            : '${sizeInMb.toStringAsFixed(1)} MB';
      }
    } catch (e) {
      Get.rawSnackbar(
        title: 'Error',
        message: 'Failed to pick file.',
        backgroundColor: Colors.red,
      );
    }
  }

  void removeAttachment() {
    attachmentName.value = '';
    attachmentPath.value = '';
  }

  int get calculatedDays {
    if (fromDate.value == null || toDate.value == null) return 0;
    final diff = toDate.value!.difference(fromDate.value!).inDays + 1;
    return diff;
  }

  String get requestedDurationString {
    if (fromDate.value == null || toDate.value == null) return '';
    final format = DateFormat('dd MMM');
    final String dates = fromDate.value!.isAtSameMomentAs(toDate.value!) 
        ? format.format(fromDate.value!)
        : '${DateFormat('dd').format(fromDate.value!)}–${format.format(toDate.value!)}';
    
    if (duration.value == 'Full Day') {
      return '$calculatedDays days · $dates';
    } else {
      return '$calculatedDays days · $dates';
    }
  }

  Future<void> submit() async {
    if (fromDate.value == null || toDate.value == null || reason.value.isEmpty) {
      Get.rawSnackbar(
        title: 'Error', 
        message: 'Please fill all required fields',
        backgroundColor: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    try {
      final payload = LeaveRequestPayload(
        leaveType: leaveType.value,
        fromDate: DateFormat('yyyy-MM-dd').format(fromDate.value!),
        toDate: DateFormat('yyyy-MM-dd').format(toDate.value!),
        duration: duration.value,
        reason: reason.value,
        attachmentPath: attachmentPath.value.isNotEmpty ? attachmentPath.value : null,
      );
      await _repository.submitLeaveRequest(payload);
      
      Get.back(result: true); // Return to dashboard
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.rawSnackbar(
          title: 'Success', 
          message: 'Leave request submitted successfully',
          backgroundColor: Colors.green,
        );
      });
    } catch (e) {
      Get.rawSnackbar(
        title: 'Error', 
        message: 'Failed to submit request',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
