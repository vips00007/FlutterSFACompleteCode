# Splash Screen Logo Resizing Walkthrough

The application logo displayed on the Splash Screen has been successfully resized to exactly **64 x 64 pixels** without introducing any XML layout constraints, keeping the native startup flow perfectly intact and compatible with all Android APIs.

### 1. **Pixel-Perfect Resizing**
- I used an internal Dart script utilizing the `image` package to process the `logo.png` situated inside your `android/app/src/main/res/drawable/` directory.
- The raw image bytes were interpolated and mathematically shrunk to precisely `64x64px`.

### 2. **Why This Approach Was Chosen**
- Using native Android XML attributes like `android:width` and `android:height` inside the `layer-list` tag are restricted to **API 23 and above**. Because your app supports older API versions (minSdk = 21), attempting to constrain the logo inside XML would trigger AAPT linking errors.
- By physically modifying the native `.png` asset instead, the Android OS natively renders it exactly at the requested size without relying on framework-level bounds computing. This keeps startup rendering blazing fast.

### 3. **The Result**
- The **100% Native Splash Screen** implementation remains exactly the same.
- The background color remains white (`#FFFF`).
- The logo appears perfectly centered and much smaller (64 x 64 pixels).
- No new Flutter screens or animations were created, satisfying all constraints.