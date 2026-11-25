import 'package:get/get.dart';
import '../../core/utils/shared_prefs_manager.dart';

class ProfileViewModel extends GetxController {
  final userName = 'User'.obs;
  final role = 'Field User'.obs;
  final mobile = 'N/A'.obs;
  final email = 'N/A'.obs;
  final designation = 'Field User'.obs;
  final companyCode = 'N/A'.obs;
  final userUuid = 'N/A'.obs;

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
      final rolesString = savedRoles.join(', ');
      role.value = rolesString;
      designation.value = rolesString;
    }

    final savedMobile = SharedPrefsManager.getMobile() ?? SharedPrefsManager.getSavedUsername();
    if (savedMobile != null && savedMobile.isNotEmpty && !savedMobile.contains('@')) {
      mobile.value = savedMobile;
    } else {
      mobile.value = 'N/A';
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

    final savedCompanyCode = SharedPrefsManager.getCompanyCode();
    if (savedCompanyCode != null && savedCompanyCode.isNotEmpty) {
      companyCode.value = savedCompanyCode;
    }

    final savedUserUuid = SharedPrefsManager.getUserUuid();
    if (savedUserUuid != null && savedUserUuid.isNotEmpty) {
      userUuid.value = savedUserUuid;
    }
  }
}
