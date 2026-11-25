import 'package:get/get.dart';
import '../../core/utils/shared_prefs_manager.dart';
import '../../routes/route_names.dart';

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
    final savedName = SharedPrefsManager.getName() ?? SharedPrefsManager.getSavedUsername();
    if (savedName != null && savedName.isNotEmpty) {
      userName.value = savedName;
    }

    final savedRoles = SharedPrefsManager.getRoles();
    if (savedRoles.isNotEmpty) {
      role.value = savedRoles.join(', ');
    }

    final savedMobile = SharedPrefsManager.getMobile() ?? SharedPrefsManager.getSavedUsername();
    if (savedMobile != null && savedMobile.isNotEmpty && !savedMobile.contains('@')) {
      phone.value = savedMobile;
    } else {
      phone.value = 'N/A';
    }

    final savedEmail = SharedPrefsManager.getEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      email.value = savedEmail;
    } else {
      final savedUser = SharedPrefsManager.getSavedUsername();
      if (savedUser != null && savedUser.contains('@')) {
        email.value = savedUser;
      } else {
        email.value = 'N/A';
      }
    }

    final savedUuid = SharedPrefsManager.getUserUuid();
    if (savedUuid != null && savedUuid.isNotEmpty) {
      employeeId.value = savedUuid.length > 8 ? savedUuid.substring(0, 8).toUpperCase() : savedUuid;
    }
  }

  Future<void> logout() async {
    final bool wasOnboardingComplete = SharedPrefsManager.isOnboardingComplete();
    await SharedPrefsManager.clear();
    if (wasOnboardingComplete) {
      await SharedPrefsManager.setOnboardingComplete(true);
    }
    Get.offAllNamed(RoutesName.login_view);
  }
}
