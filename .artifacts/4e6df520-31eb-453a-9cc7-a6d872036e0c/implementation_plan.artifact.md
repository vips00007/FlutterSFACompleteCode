# Implementation Plan - Remove Default Android/Flutter Launch Splash Screen

The goal is to eliminate the default blue/theme-colored splash screen that appears before the custom Flutter splash screen. This will be achieved by making the `LaunchTheme` transparent, which instructs the Android system not to display a preview window while the app process is starting.

## User Review Required

> [!IMPORTANT]
> Making the launch theme transparent will cause the app to show the previous screen (usually the home screen) for a brief moment while Flutter initializes, instead of showing the blue splash screen. This effectively "removes" the splash screen, but the user might perceive a slight delay before the app's custom splash screen appears.

## Proposed Changes

### Android Resource Styles

#### [MODIFY] [values/styles.xml](file:///E:/FlutterPracticeSrLevel/android/app/src/main/res/values/styles.xml)
- Update `LaunchTheme` to be transparent.
- Set `android:windowIsTranslucent` to `true`.
- Set `android:windowBackground` to `@android:color/transparent`.
- Set `android:windowDisablePreview` to `true` to further ensure no preview is shown.

#### [MODIFY] [values-night/styles.xml](file:///E:/FlutterPracticeSrLevel/android/app/src/main/res/values-night/styles.xml)
- Apply the same transparency changes as in `values/styles.xml`.

#### [MODIFY] [values-v31/styles.xml](file:///E:/FlutterPracticeSrLevel/android/app/src/main/res/values-v31/styles.xml)
- Update `LaunchTheme` for Android 12+ to suppress the splash screen.
- Set `android:windowIsTranslucent` to `true`.
- Set `android:windowSplashScreenBackground` to `@android:color/transparent` (as a fallback, though `windowIsTranslucent` should take precedence).
- Set `android:windowSplashScreenAnimatedIcon` to `@android:color/transparent`.

## Verification Plan

### Manual Verification
1.  Build the release APK: `flutter build apk --release`.
2.  Install the APK on an Android device (preferably Android 12+).
3.  Launch the app and verify that the blue splash screen is no longer visible.
4.  Verify that the transition from the home screen to the custom Flutter splash screen is smooth.
