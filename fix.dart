import 'dart:io';

void main() {
  var d = Directory('lib');
  for (var f in d.listSync(recursive: true)) {
    if (f is File && f.path.endsWith('.dart')) {
      var c = f.readAsStringSync();
      var nc = c
          .replaceAll('splash_view', 'splashView')
          .replaceAll('login_view', 'loginView')
          .replaceAll('onboarding_view', 'onboardingView')
          .replaceAll('signup_view', 'signupView')
          .replaceAll('otp_view', 'otpView')
          .replaceAll('home_view', 'homeView')
          .replaceAll('dashboard_view', 'dashboardView')
          .replaceAll('forgot_password_view', 'forgotPasswordView')
          .replaceAll('reset_password_view', 'resetPasswordView')
          .replaceAll('team_view', 'teamView')
          .replaceAll('order_view', 'orderView')
          .replaceAll('create_plan_view', 'createPlanView')
          .replaceAll('customer_summary_view', 'customerSummaryView')
          .replaceAll('customer_profile_view', 'customerProfileView')
          .replaceAll('attendance_camera_view', 'attendanceCameraView')
          .replaceAll('attendance_list_view', 'attendanceListView')
          .replaceAll('leave_management_view', 'leaveManagementView')
          .replaceAll('daily_visit_plans_view', 'dailyVisitPlansView')
          .replaceAll('monthly_journey_plan_view', 'monthlyJourneyPlanView')
          .replaceAll('visit_history_view', 'visitHistoryView')
          .replaceAll('event_planner_view', 'eventPlannerView')
          .replaceAll('create_event_view', 'createEventView')
          .replaceAll('product_catalogue_view', 'productCatalogueView')
          .replaceAll('my_performance_view', 'myPerformanceView')
          .replaceAll('expense_claim_view', 'expenseClaimView')
          .replaceAll('help_support_view', 'helpSupportView')
          .replaceAll('profile_view', 'profileView');
      if (nc != c) {
        f.writeAsStringSync(nc);
        print('Updated ${f.path}');
      }
    }
  }
}