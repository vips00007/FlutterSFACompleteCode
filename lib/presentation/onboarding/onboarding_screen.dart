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
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                          shadowColor: AppColors.primary.withValues(alpha: 0.3),
                        ),
                        child: Text(
                          viewModel.isLastPage ? 'Get Started' : 'Next',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Skip Button
            Positioned(
              top: 10,
              right: 20,
              child: TextButton(
                onPressed: viewModel.skip,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Color(0xFF311B92),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
