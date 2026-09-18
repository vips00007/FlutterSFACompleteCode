# Walkthrough - Startup Performance Optimization

I have optimized the app's startup by implementing a native splash screen and a non-blocking initialization flow.

## Changes Made

### 1. Native Splash Screen Configuration
Modified [pubspec.yaml](file:///E:/FlutterPracticeSrLevel/pubspec.yaml) to include `flutter_native_splash`.
- **Background Color**: `#6366F1` (Dark Navy matching your brand)
- **Logo**: `assets/images/logo.png`
- **Android 12 Support**: Configured the new splash API requirements.

### 2. Lightweight `main()`
Restructured [main.dart](file:///E:/FlutterPracticeSrLevel/lib/main.dart):
- `runApp()` is now called immediately after binding initialization.
- Removed `await SharedPrefsManager.init()` to prevent blocking the first frame.
- Added `FlutterNativeSplash.preserve()` to keep the native splash visible until Dart is ready.

### 3. Lightweight Dart Loader
Created [SplashLoaderScreen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/splash/splash_loader_screen.dart):
- Acts as the first route (`/`).
- Matches the native splash UI to ensure a seamless transition.
- Handles `SharedPrefsManager.init()` and navigation logic in `initState`.
- Calls `FlutterNativeSplash.remove()` only after initialization is complete.

### 4. Route Updates
Updated [routes.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/routes.dart) to map the initial route to the new `SplashLoaderScreen`.

## Verification Instructions

> [!IMPORTANT]
> To apply the native splash screen changes, you **must** run the following command in your terminal:
> ```bash
> dart run flutter_native_splash:create
> ```

### Measuring the Improvement

1. **Build a Release APK**:
   Debug builds are slow and don't represent real performance.
   ```bash
   flutter build apk --release
   ```

2. **Measure Cold-Start Time**:
   Install the APK on a device, then run:
   ```bash
   adb logcat | grep "ActivityTaskManager: Displayed"
   ```
   Look for the `Displayed` time for `com.example.flutter_practice_sr_level`.

3. **Perceived Performance**:
   Tap the app icon. You should see the logo instantly (native splash), followed by a brief loading indicator (Dart side), and then the main app content without any white/blank screen flicker.

render_diffs(file:///E:/FlutterPracticeSrLevel/pubspec.yaml)
render_diffs(file:///E:/FlutterPracticeSrLevel/lib/main.dart)
render_diffs(file:///E:/FlutterPracticeSrLevel/lib/routes/routes.dart)
