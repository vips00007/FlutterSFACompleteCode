# Goal Description
The objective is to revert to a **100% Native Android Splash Screen** while including the application logo directly on the blue background, guaranteeing that there are no double splash screens, no hybrid overlap issues, and no custom Flutter Splash View.

This approach completely disables `SplashView` and delegates the logo rendering entirely to the OS before the Flutter engine starts, resulting in an optimal and flawless single-splash launch experience.

## Proposed Changes

### 1. Remove Flutter `SplashView` Entirely
We will completely wipe the secondary Flutter Splash Screen (`SplashView`) as it is creating the "double splash" effect.

#### [DELETE] [splash_view.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/splash/splash_view.dart)
- Delete the `lib/presentation/splash/` folder and `splash_view.dart`.

#### [MODIFY] [routes.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/routes.dart) & [route_names.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/route_names.dart)
- Remove `RoutesName.splash_view` from the routing tables.

#### [MODIFY] [main.dart](file:///E:/FlutterPracticeSrLevel/lib/main.dart)
- Restore synchronous `initialRoute` logic (`login_view` vs `dashboard_view`) inside `main()` before `runApp()`.
- The Flutter app will instantiate directly to the destination screen, leaving the Splash Screen purely up to Android.

### 2. Embed Logo into Native Android Resources
We will copy the Flutter asset logo into the Android `res/drawable` folder so the native OS can display it immediately upon app launch.

#### [NEW] [logo.png](file:///E:/FlutterPracticeSrLevel/android/app/src/main/res/drawable/logo.png)
- Copy `assets/images/logo.png` into `android/app/src/main/res/drawable/logo.png`.

### 3. Update Native Android Splash Configuration
We will edit the native XML files to draw the logo directly in the center of the blue background.

#### [MODIFY] [launch_background.xml](file:///E:/FlutterPracticeSrLevel/android/app/src/main/res/drawable/launch_background.xml) & [drawable-v21](file:///E:/FlutterPracticeSrLevel/android/app/src/main/res/drawable-v21/launch_background.xml)
Add a `<bitmap>` layer to center the logo on top of the blue background:
```xml
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@color/splash_background" />
    <item>
        <bitmap android:gravity="center" android:src="@drawable/logo" />
    </item>
</layer-list>
```

#### [MODIFY] [styles.xml (v31)](file:///E:/FlutterPracticeSrLevel/android/app/src/main/res/values-v31/styles.xml)
For Android 12+, we will map the Splash Screen API animated icon to our logo, triggering an elegant entrance animation (default native icon scale/bounce):
```xml
<item name="android:windowSplashScreenAnimatedIcon">@drawable/logo</item>
```

## Verification Plan
1. Completely close the app.
2. Tap the app icon.
3. Expectation: The Native Android Splash Screen instantly draws the blue background **with the logo in the center**.
4. Expectation: As soon as Flutter is ready, the screen flawlessly transforms straight into the Login or Dashboard screen without ever drawing a secondary splash.