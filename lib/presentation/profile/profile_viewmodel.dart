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
    final savedName = SharedPrefsManager.getName();
    if (savedName != null && savedName.isNotEmpty) {
      userName.value = savedName;
    }

    final savedRoles = SharedPrefsManager.getRoles();
    if (savedRoles.isNotEmpty) {
      final rolesString = savedRoles.join(', ');
      role.value = rolesString;
      designation.value = rolesString;
    }

    final savedEmail = SharedPrefsManager.getEmail();
    if (savedEmail != null) {
      email.value = savedEmail;
    }

    final savedMobile = SharedPrefsManager.getMobile();
    if (savedMobile != null) {
      mobile.value = savedMobile;
    }

    final savedCompanyCode = SharedPrefsManager.getCompanyCode();
    if (savedCompanyCode != null) {
      companyCode.value = savedCompanyCode;
    }

    final savedUserUuid = SharedPrefsManager.getUserUuid();
    if (savedUserUuid != null) {
      userUuid.value = savedUserUuid;
    }
  }
}
