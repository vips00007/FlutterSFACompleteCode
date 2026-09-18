import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/routes.dart';
import 'routes/route_names.dart';
import 'core/colors/app_colors.dart';
import 'core/utils/shared_prefs_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };

  // Essential Initialization Only
  String initialRoute = RoutesName.login_view;
  try {
    await SharedPrefsManager.init();

    if (!SharedPrefsManager.isOnboardingComplete()) {
      initialRoute = RoutesName.onboarding_view;
    } else {
      final token = SharedPrefsManager.getToken();
      if (token != null && token.isNotEmpty) {
        initialRoute = RoutesName.dashboard_view;
      } else {
        initialRoute = RoutesName.login_view;
      }
    }
  } catch (e) {
    debugPrint("Initialization ERROR: $e");
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dhruva.Ai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: AppColors.background,
        ),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      getPages: AppRoutes.appRoutes(),
    );
  }
}
