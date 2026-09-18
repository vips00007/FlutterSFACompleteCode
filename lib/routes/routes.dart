import 'package:get/get.dart';
import 'package:flutter_practice_sr_level/data/datasource/remote/attendance_api_service.dart';
import 'package:flutter_practice_sr_level/data/repositories/attendance_repository_impl.dart';
import 'package:flutter_practice_sr_level/domain/repositories/attendance_repository.dart';
import 'package:flutter_practice_sr_level/presentation/login/login_screen.dart';
import 'package:flutter_practice_sr_level/presentation/login/login_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/forgot_password/forgot_password_screen.dart';
import 'package:flutter_practice_sr_level/presentation/forgot_password/forgot_password_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/otp_verification/otp_verification_screen.dart';
import 'package:flutter_practice_sr_level/presentation/otp_verification/otp_verification_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/home/home_screen.dart';
import 'package:flutter_practice_sr_level/presentation/home/home_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/tickets/tickets_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/tickets/create_plan_screen.dart';
import 'package:flutter_practice_sr_level/presentation/tickets/create_plan_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/tickets/customer_summary_screen.dart';
import 'package:flutter_practice_sr_level/presentation/tickets/customer_profile_screen.dart';
import 'package:flutter_practice_sr_level/presentation/team/team_screen.dart';
import 'package:flutter_practice_sr_level/presentation/order/order_screen.dart';
import 'package:flutter_practice_sr_level/presentation/dashboard/dashboard_screen.dart';
import 'package:flutter_practice_sr_level/presentation/dashboard/dashboard_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/explore/add_outlet_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/favorites/favorites_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/onboarding/onboarding_screen.dart';
import 'package:flutter_practice_sr_level/presentation/onboarding/onboarding_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/home/widgets/attendance_camera_screen.dart';
import 'package:flutter_practice_sr_level/presentation/account/attendance_list_screen.dart';
import 'package:flutter_practice_sr_level/presentation/account/attendance_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/account/leave_management_screen.dart';
import 'package:flutter_practice_sr_level/presentation/account/leave_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/tickets/daily_visit_plans_screen.dart';
import 'package:flutter_practice_sr_level/presentation/tickets/visit_plans_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/tickets/monthly_journey_plan_screen.dart';
import 'package:flutter_practice_sr_level/presentation/tickets/monthly_journey_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/tickets/visit_history_screen.dart';
import 'package:flutter_practice_sr_level/presentation/tickets/visit_history_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/events/event_planner_screen.dart';
import 'package:flutter_practice_sr_level/presentation/events/event_planner_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/events/create_event_screen.dart';
import 'package:flutter_practice_sr_level/presentation/events/create_event_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/product_catalogue/product_catalogue_screen.dart';
import 'package:flutter_practice_sr_level/presentation/product_catalogue/product_catalogue_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/my_performance/my_performance_screen.dart';
import 'package:flutter_practice_sr_level/presentation/my_performance/my_performance_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/expense_claim/expense_claim_screen.dart';
import 'package:flutter_practice_sr_level/presentation/expense_claim/expense_claim_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/help_support/help_support_screen.dart';
import 'package:flutter_practice_sr_level/presentation/help_support/help_support_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/profile/profile_screen.dart';
import 'package:flutter_practice_sr_level/presentation/profile/profile_viewmodel.dart';
import 'package:flutter_practice_sr_level/presentation/reset_password/reset_password_screen.dart';
import 'package:flutter_practice_sr_level/presentation/reset_password/reset_password_viewmodel.dart';
import 'package:flutter_practice_sr_level/domain/usecases/login_usecase.dart';
import 'package:flutter_practice_sr_level/domain/usecases/forgot_password_usecase.dart';
import 'package:flutter_practice_sr_level/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_practice_sr_level/domain/usecases/verify_login_otp_usecase.dart';
import 'package:flutter_practice_sr_level/domain/usecases/update_password_usecase.dart';
import 'package:flutter_practice_sr_level/domain/usecases/get_tickets_usecase.dart';
import 'package:flutter_practice_sr_level/domain/usecases/get_events_usecase.dart';
import 'package:flutter_practice_sr_level/data/repositories/auth_repository_impl.dart';
import 'package:flutter_practice_sr_level/data/repositories/event_repository_impl.dart';
import 'package:flutter_practice_sr_level/data/repositories/ticket_repository_impl.dart';
import 'package:flutter_practice_sr_level/data/datasource/remote/auth_api_service.dart';
import 'package:flutter_practice_sr_level/routes/route_names.dart';

class AppRoutes {
  static List<GetPage> appRoutes() => [
    GetPage(
      name: RoutesName.onboarding_view,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => OnboardingViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.visit_history_view,
      page: () => const VisitHistoryScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => VisitHistoryViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.login_view,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthApiService());
        Get.lazyPut(() => AuthRepositoryImpl(Get.find<AuthApiService>()));
        Get.lazyPut(() => LoginUseCase(Get.find<AuthRepositoryImpl>()));
        Get.lazyPut(() => LoginViewModel(Get.find<LoginUseCase>()));
      }),
    ),
    GetPage(
      name: RoutesName.otp_view,
      page: () => const OtpVerificationScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthApiService());
        Get.lazyPut(() => AuthRepositoryImpl(Get.find<AuthApiService>()));
        Get.lazyPut(() => VerifyOtpUseCase(Get.find<AuthRepositoryImpl>()));
        Get.lazyPut(() => VerifyLoginOtpUseCase(Get.find<AuthRepositoryImpl>()));
        Get.lazyPut(() => ForgotPasswordUseCase(Get.find<AuthRepositoryImpl>()));
        Get.lazyPut(() => LoginUseCase(Get.find<AuthRepositoryImpl>()));
        Get.lazyPut(() => OtpVerificationViewModel(
              verifyOtpUseCase: Get.find<VerifyOtpUseCase>(),
              verifyLoginOtpUseCase: Get.find<VerifyLoginOtpUseCase>(),
              forgotPasswordUseCase: Get.find<ForgotPasswordUseCase>(),
              loginUseCase: Get.find<LoginUseCase>(),
            ));
      }),
    ),
    GetPage(name: RoutesName.home_view, page: () => const HomeScreen()),
    GetPage(
      name: RoutesName.dashboard_view,
      page: () => const DashboardScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DashboardViewModel());

        // Home & Events Feature Dependencies
        Get.lazyPut(() => EventRepositoryImpl());
        Get.lazyPut(() => GetEventsUseCase(Get.find<EventRepositoryImpl>()));
        Get.lazyPut(() => AttendanceApiService());
        Get.lazyPut<AttendanceRepository>(
          () => AttendanceRepositoryImpl(Get.find<AttendanceApiService>()),
        );
        Get.lazyPut(
          () => HomeViewModel(Get.find<AttendanceRepository>()),
        );

        // Tickets (Visits) Dependencies
        Get.lazyPut(() => TicketRepositoryImpl());
        Get.lazyPut(() => GetTicketsUseCase(Get.find<TicketRepositoryImpl>()));
        Get.lazyPut(() => TicketsViewModel(Get.find<GetTicketsUseCase>()));

        // Add Outlet Dependencies
        Get.lazyPut(() => AddOutletViewModel());

        // Favorites (Menu) Dependencies
        Get.lazyPut(() => FavoritesViewModel());

        // Product Feature Dependencies (Existing)
      }),
    ),
    GetPage(
      name: RoutesName.forgot_password_view,
      page: () => const ForgotPasswordScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthApiService());
        Get.lazyPut(() => AuthRepositoryImpl(Get.find<AuthApiService>()));
        Get.lazyPut(
          () => ForgotPasswordUseCase(Get.find<AuthRepositoryImpl>()),
        );
        Get.lazyPut(() => VerifyOtpUseCase(Get.find<AuthRepositoryImpl>()));
        Get.lazyPut(
          () => UpdatePasswordUseCase(Get.find<AuthRepositoryImpl>()),
        );
        Get.lazyPut(
          () => ForgotPasswordViewModel(
            forgotPasswordUseCase: Get.find<ForgotPasswordUseCase>(),
            verifyOtpUseCase: Get.find<VerifyOtpUseCase>(),
            updatePasswordUseCase: Get.find<UpdatePasswordUseCase>(),
          ),
        );
      }),
    ),
    GetPage(name: RoutesName.team_view, page: () => const TeamScreen()),
    GetPage(name: RoutesName.order_view, page: () => const OrderScreen()),
    GetPage(
      name: RoutesName.create_plan_view,
      page: () => const CreatePlanScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CreatePlanViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.customer_summary_view,
      page: () => const CustomerSummaryScreen(),
    ),
    GetPage(
      name: RoutesName.customer_profile_view,
      page: () => const CustomerProfileScreen(),
    ),
    GetPage(
      name: RoutesName.attendance_camera_view,
      page: () => const AttendanceCameraScreen(),
    ),
    GetPage(
      name: RoutesName.attendance_list_view,
      page: () => const AttendanceListScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() {
          final apiService = AttendanceApiService();
          final repository = AttendanceRepositoryImpl(apiService);
          return AttendanceViewModel(repository);
        });
      }),
    ),
    GetPage(
      name: RoutesName.leave_management_view,
      page: () => const LeaveManagementScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LeaveViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.daily_visit_plans_view,
      page: () => const DailyVisitPlansScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => VisitPlansViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.monthly_journey_plan_view,
      page: () => const MonthlyJourneyPlanScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MonthlyJourneyViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.event_planner_view,
      page: () => const EventPlannerScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => EventPlannerViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.create_event_view,
      page: () => const CreateEventScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CreateEventViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.product_catalogue_view,
      page: () => const ProductCatalogueScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ProductCatalogueViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.my_performance_view,
      page: () => const MyPerformanceScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MyPerformanceViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.expense_claim_view,
      page: () => const ExpenseClaimScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ExpenseClaimViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.help_support_view,
      page: () => const HelpSupportScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HelpSupportViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.profile_view,
      page: () => const ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ProfileViewModel());
      }),
    ),
    GetPage(
      name: RoutesName.reset_password_view,
      page: () => const ResetPasswordScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthApiService());
        Get.lazyPut(() => AuthRepositoryImpl(Get.find<AuthApiService>()));
        Get.lazyPut(
          () => UpdatePasswordUseCase(Get.find<AuthRepositoryImpl>()),
        );
        Get.lazyPut(
          () => ResetPasswordViewModel(
            updatePasswordUseCase: Get.find<UpdatePasswordUseCase>(),
          ),
        );
      }),
    ),
  ];
}
