import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiGoal {
  final String title;
  final String subtitle;
  final IconData icon;

  AiGoal({required this.title, required this.subtitle, required this.icon});
}

class CreatePlanViewModel extends GetxController {
  final selectedTabIndex = 0.obs; // 0 for AI Smart Plan, 1 for Manual Select

  final aiGoals = [
    AiGoal(
      title: 'Recent Buyers',
      subtitle: 'Follow up with recent buyers',
      icon: Icons.shopping_bag_outlined,
    ),
    AiGoal(
      title: 'Visit Due',
      subtitle: 'Customers waiting for a visit',
      icon: Icons.calendar_today_outlined,
    ),
    AiGoal(
      title: 'New Customers',
      subtitle: 'First visits for new customers',
      icon: Icons.person_add_outlined,
    ),
    AiGoal(
      title: 'Reconnect',
      subtitle: 'Win back customers',
      icon: Icons.history,
    ),
    AiGoal(
      title: 'VIP / Top Revenue',
      subtitle: 'Highest-value customers',
      icon: Icons.star_outline,
    ),
    AiGoal(
      title: 'First-Time Buyer',
      subtitle: 'Just placed their first order',
      icon: Icons.new_releases_outlined,
    ),
    AiGoal(
      title: 'Big Order Follow-up',
      subtitle: 'Customers with large orders',
      icon: Icons.local_shipping_outlined,
    ),
    AiGoal(
      title: 'Frequent Buyer',
      subtitle: 'High-touch regular customers',
      icon: Icons.sync_alt,
    ),
    AiGoal(
      title: 'Hot Leads',
      subtitle: 'Active leads requiring action',
      icon: Icons.whatshot_outlined,
    ),
    AiGoal(
      title: 'Quota Catch-Up',
      subtitle: 'Help meet your targets',
      icon: Icons.outlined_flag,
    ),
    AiGoal(
      title: 'By Area / City',
      subtitle: 'Pick a city, AI plans route',
      icon: Icons.map_outlined,
    ),
    AiGoal(
      title: 'By Customer Type',
      subtitle: 'Pick a type, AI plans route',
      icon: Icons.label_important_outline,
    ),
    AiGoal(
      title: 'Plan Around a Customer',
      subtitle: 'Pick a customer as anchor',
      icon: Icons.gps_fixed,
    ),
    AiGoal(
      title: 'Pending Payment',
      subtitle: 'Customers with dues',
      icon: Icons.payments_outlined,
    ),
    AiGoal(
      title: 'Birthday / Anniversary',
      subtitle: 'Upcoming birthdays',
      icon: Icons.cake_outlined,
    ),
  ];

  final selectedGoalIndex = (-1).obs; // -1 for none or Smart Pick
  final isSmartPickSelected = true.obs;

  final visitObjective = ''.obs;
  final selectedDate = DateTime.now().obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void selectGoal(int index) {
    selectedGoalIndex.value = index;
    isSmartPickSelected.value = false;
  }

  void toggleSmartPick() {
    isSmartPickSelected.value = true;
    selectedGoalIndex.value = -1;
  }

  void createPlan() {
    Get.back();
    Get.snackbar(
      'Success',
      'Travel plan created successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade900,
    );
  }
}
