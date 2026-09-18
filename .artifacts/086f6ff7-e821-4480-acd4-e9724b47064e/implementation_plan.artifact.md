# Implementation Plan - Remove Default/System Splash Screen

The objective is to remove the default Android system splash screen (which currently shows a logo) and ensure that only the custom Flutter splash screen (`SplashView.dart`) is visible during app startup.

## User Review Required

> [!IMPORTANT]
> To "remove" the system splash screen on Android 12+, we will set the system splash icon to be transparent and match its background color with the app's theme. This creates a seamless transition directly into your custom Flutter splash screen.

## Proposed Changes

### Android Configuration

#### [MODIFY] [styles.xml](file:///E:/FlutterPracticeSrLevel/android/app/src/main/res/values/styles.xml)
- Update `LaunchTheme` to match the background color of the custom splash screen.
- Add attributes to handle the Android 12+ Splash Screen API by making the icon transparent and setting the background.
- Update `NormalTheme` to ensure it doesn't show a logo background.

#### [MODIFY] [styles.xml (night)](file:///E:/FlutterPracticeSrLevel/android/app/src/main/res/values-night/styles.xml)
- Apply similar changes for dark mode to ensure consistency.

#### [NEW] [styles.xml (v31)](file:///E:/FlutterPracticeSrLevel/android/app/src/main/res/values-v31/styles.xml)
- Create a new styles file for API 31+ (Android 12) to explicitly override the new Splash Screen API behavior, setting the splash icon to transparent.

#### [MODIFY] [launch_background.xml](file:///E:/FlutterPracticeSrLevel/android/app/src/main/res/drawable/launch_background.xml)
- Ensure the background drawable is a solid color matching the custom splash screen, with no logo items.

## Verification Plan

### Manual Verification
- **Cold Start Test**: Launch the app from a killed state on an Android 12+ device/emulator. Verify that no system logo appears before the "SalesForce AI" splash screen.
- **Transition Test**: Ensure the transition from the launcher to the custom splash screen is smooth and free of "flashes" or blank screens.
- **Navigation Test**: Navigate between different screens (e.g., Dashboard, Login) to ensure the splash screen background does not reappear during transitions.
