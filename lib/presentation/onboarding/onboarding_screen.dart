import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/colors/app_colors.dart';
import 'onboarding_viewmodel.dart';
import 'widgets/onboarding_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingViewModel viewModel = Get.put(OnboardingViewModel());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Skip Button
            Positioned(
              top: 10,
              right: 20,
              child: TextButton(
                onPressed: viewModel.skip,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // PageView
            PageView.builder(
              controller: viewModel.pageController,
              itemCount: viewModel.onboardingPages.length,
              onPageChanged: viewModel.onPageChanged,
              itemBuilder: (context, index) {
                return OnboardingPage(
                  content: viewModel.onboardingPages[index],
                );
              },
            ),

            // Bottom UI
            Positioned(
              bottom: 40,
              left: 30,
              right: 30,
              child: Column(
                children: [
                  // Indicator
                  SmoothPageIndicator(
                    controller: viewModel.pageController,
                    count: viewModel.onboardingPages.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: viewModel.nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sfaBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          viewModel.isLastPage ? 'Get Started' : 'Next',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
