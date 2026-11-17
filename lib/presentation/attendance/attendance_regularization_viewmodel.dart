import 'package:get/get.dart';

class AttendanceRegularizationViewModel extends GetxController {
  final date = '22 September 2026'.obs;
  final status = 'Present'.obs;
  final loginTime = '08:47 AM'.obs;
  final loginLocation = 'Andheri West'.obs;
  final logoutTime = '06:14 PM'.obs;
  final logoutLocation = 'Bandra West'.obs;
  final totalWorkHours = '9h 27m'.obs;
  
  void regularize() {
    Get.toNamed('/apply_regularization_view');
  }
}
