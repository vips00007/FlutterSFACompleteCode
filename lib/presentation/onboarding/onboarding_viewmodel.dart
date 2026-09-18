import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/shared_prefs_manager.dart';
import '../../domain/entities/onboarding_content.dart';
import '../../routes/route_names.dart';

class OnboardingViewModel extends GetxController {
  final pageController = PageController();
  final currentPageIndex = 0.obs;

  final List<OnboardingContent> onboardingPages = [
    OnboardingContent(
      title: 'Discover Amazing Events',
      description:
          'Find concerts, sports, theatre and more events happening around you.',
      imageUrl: 'assets/images/automation.png',
    ),
    OnboardingContent(
      title: 'Manage Your Schedule',
      description:
          'Never miss an event with our smart calendar integration and reminders.',
      imageUrl: 'assets/images/authentication.png',
    ),
  ];

  bool get isLastPage => currentPageIndex.value == onboardingPages.length - 1;

  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  void nextPage() {
    if (isLastPage) {
      completeOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    completeOnboarding();
  }

  Future<void> completeOnboarding() async {
    await SharedPrefsManager.setOnboardingComplete(true);
    Get.offAllNamed(RoutesName.login_view);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
