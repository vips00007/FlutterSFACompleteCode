import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/shared_prefs_manager.dart';
import '../../domain/entities/onboarding_content.dart';
import '../../routes/route_names.dart';

class OnboardingViewModel extends GetxController {
  final pageController = PageController();
  final currentPageIndex = 0.obs;

  final List<OnboardingContent> onboardingPages = [OnboardingContent(
    title: 'Simplify Your Sales Journey',
    description:
    'Manage customer visits, track daily activities, and streamline your entire sales process with one smart application.',
    imageUrl: 'assets/images/sfa_illustration.png',
  ),
    OnboardingContent(
      title: 'Track Performance & Grow',
      description: 'Monitor sales performance, manage orders, track customer interactions, and achieve your business goals effortlessly.',
      imageUrl: 'assets/images/sfa_illustration_2.png',
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
