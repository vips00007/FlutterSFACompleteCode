import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HelpSupportViewModel extends GetxController {
  final supportPhone = '+918349254726';
  final supportEmail = 'support.demo@dhruve.com';
  final supportWebsite = 'www.dhruve.AI.com';

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
