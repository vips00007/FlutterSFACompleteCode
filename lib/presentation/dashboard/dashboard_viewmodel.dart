import 'package:get/get.dart';
import '../tickets/tickets_viewmodel.dart';

class DashboardViewModel extends GetxController {
  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;

  void changeTabIndex(int index) {
    _selectedIndex.value = index;
    if (index == 2) {
      // Lazy load tickets when Visits tab is selected
      if (Get.isRegistered<TicketsViewModel>()) {
        Get.find<TicketsViewModel>().fetchTicketsIfNotFetched();
      }
    }
  }
}
