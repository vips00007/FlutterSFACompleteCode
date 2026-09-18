# Implementation Plan - Startup Performance Optimization

Optimize the app's cold-start performance by implementing a native splash screen and restructuring the initialization flow to prevent UI blocking.

## Proposed Changes

### Dependencies
#### [MODIFY] [pubspec.yaml](file:///E:/FlutterPracticeSrLevel/pubspec.yaml)
- Add `flutter_native_splash: ^2.4.0` to `dependencies`.
- Configure `flutter_native_splash` with the app logo (`assets/images/logo.png`) and branding colors.

### App Entry Point
#### [MODIFY] [main.dart](file:///E:/FlutterPracticeSrLevel/lib/main.dart)
- Call `runApp(const MyApp())` immediately after `WidgetsFlutterBinding.ensureInitialized()`.
- Remove `SharedPrefsManager.init()` from `main()`.

### Presentation Layer
#### [NEW] [splash_loader_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/splash/splash_loader_screen.dart)
- Create a lightweight `SplashLoaderScreen` that:
    - Matches the native splash screen UI (logo and background).
    - Initializes `SharedPrefsManager` in `initState()`.
    - Removes the native splash screen using `FlutterNativeSplash.remove()` after the first frame.
    - Handles navigation logic (checking onboarding/token) after initialization.

#### [MODIFY] [route_names.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/route_names.dart)
- Update/Add route name for the new loader if necessary (or repurpose existing splash route).

#### [MODIFY] [routes.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/routes.dart)
- Point the initial route to `SplashLoaderScreen`.

## Verification Plan

### Automated Tests
- Build release APK: `flutter build apk --release`
- Measure startup time using `adb logcat`:
  `adb logcat | grep "ActivityTaskManager: Displayed"`

### Manual Verification
- Observe the transition from the app icon tap to the native splash, then to the Dart loader, and finally to the home/login screen.
- Verify there is no blank/white screen flash during the transition.
