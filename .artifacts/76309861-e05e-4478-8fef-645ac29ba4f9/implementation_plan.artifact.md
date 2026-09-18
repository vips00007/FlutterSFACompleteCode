# Implementation Plan - My Performance Screen

Create a new "My Performance" screen, register its route, and connect it to the side menu navigation.

## Proposed Changes

### Navigation & Routes

#### [MODIFY] [route_names.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/route_names.dart)
- Add `my_performance_view` constant.

#### [MODIFY] [routes.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/routes.dart)
- Register `MyPerformanceScreen` with `MyPerformanceViewModel` binding.

#### [MODIFY] [favorites_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/favorites/favorites_screen.dart)
- Add `onTap` to the "My Performance" menu item to navigate to the new screen.

### My Performance Feature

#### [NEW] [my_performance_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/my_performance/my_performance_screen.dart)
- Implement the UI matching the reference image.
- Use a `Scaffold` with an `AppBar` containing the title and back button.
- Build a list of performance cards using a reusable widget.
- Match colors, typography, and spacing from the image.

#### [NEW] [my_performance_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/my_performance/my_performance_viewmodel.dart)
- Create a `GetxController` to hold mock data for the performance metrics.

## UI Design Details
- **App Bar**: White background, back arrow, "My Performance" title.
- **Summary Header**: "Your performance summary" in grey.
- **Performance Card**:
    - Rounded corners (radius ~16).
    - Shadow/Border as per reference.
    - Icon container with specific background colors (light orange/yellow, light green).
    - Title and large value.
    - Trend indicator (red/green) with arrow and percentage.
    - Comparison subtext.

## Verification Plan

### Manual Verification
- Run the app and navigate to the Favorites tab (Side Menu).
- Tap on "My Performance".
- Verify that the screen opens directly without a splash screen.
- Verify that the UI matches the reference image.
- Verify that the back button returns to the Favorites screen.
- Test responsiveness on different screen sizes (or emulator configurations).
