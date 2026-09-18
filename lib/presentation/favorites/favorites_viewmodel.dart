import 'package:get/get.dart';
import '../../core/utils/shared_prefs_manager.dart';

class FavoritesViewModel extends GetxController {
  final userName = 'User'.obs;
  final role = 'Field User'.obs;
  final phone = '8349254726'.obs;
  final email = 'N/A'.obs;
  final employeeId = 'EMP-0001'.obs;
  final region = '-'.obs;

  // Stats
  final visitsToday = '0'.obs;
  final ordersMTD = '₹14.7K'.obs;
  final achievement = '0%'.obs;
  final outlets = '1'.obs;

  final appVersion = '24(1.7.18)'.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final savedName = SharedPrefsManager.getName();
    if (savedName != null && savedName.isNotEmpty) {
      userName.value = savedName;
    }

    final savedRoles = SharedPrefsManager.getRoles();
    if (savedRoles.isNotEmpty) {
      role.value = savedRoles.join(', ');
    }

    final savedEmail = SharedPrefsManager.getEmail();
    if (savedEmail != null) {
      email.value = savedEmail;
    }
  }

  void logout() {
    SharedPrefsManager.clear();
    Get.offAllNamed('/login_view');
  }
}
