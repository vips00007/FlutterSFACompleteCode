import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HelpSupportViewModel extends GetxController {
  final supportPhone = '+918069105250';
  final supportEmail = 'support.danaanand@imastdesk.com';
  final supportWebsite = 'www.anandgroupindia.com';

  void callSupport() {
    // Implement call logic (e.g., url_launcher)
    debugPrint("Calling support: $supportPhone");
  }

  void emailSupport() {
    // Implement email logic
    debugPrint("Emailing support: $supportEmail");
  }

  void visitWebsite() {
    // Implement website logic
    debugPrint("Visiting website: $supportWebsite");
  }
}
