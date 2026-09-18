import 'package:get/get.dart';

class EventPlannerViewModel extends GetxController {
  final selectedTab = 'Upcoming'.obs;
  final tabs = ['All', 'Today', 'Upcoming', 'Approved'];

  final events = <dynamic>[].obs; // Empty for now to show empty state

  void changeTab(String tab) {
    selectedTab.value = tab;
  }
}
