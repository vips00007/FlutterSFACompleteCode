# Implementation Plan - Profile Screen and Navigation

This plan outlines the steps to create a new Profile screen and integrate navigation from the side menu (Favorites screen header) when clicking on the user's name or mobile number.

## User Review Required

> [!IMPORTANT]
> The Profile screen will be implemented as a new standalone screen using GetX for navigation and state management, following the existing project architecture.

## Proposed Changes

### Routes & Navigation

#### [MODIFY] [route_names.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/route_names.dart)
- Add `profile_view` constant to `RoutesName`.

#### [MODIFY] [routes.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/routes.dart)
- Register `ProfileScreen` in `appRoutes`.

### Profile Feature

#### [NEW] [profile_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/profile/profile_screen.dart)
- Create a responsive Profile screen matching the provided design.
- Include a blue header with user details.
- Add "CONTACT INFORMATION" and "WORK INFORMATION" sections using cards and list tiles.

#### [NEW] [profile_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/profile/profile_viewmodel.dart)
- Create a ViewModel for the Profile screen to handle user data.

### Integration

#### [MODIFY] [favorites_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/favorites/favorites_screen.dart)
- Update `_buildHeader` to wrap the Name and Mobile/Email section with a `GestureDetector` or `InkWell` to navigate to the Profile screen.

## Verification Plan

### Manual Verification
- Navigate to the "Menu" (Favorites) tab.
- Tap on the user's Name or Mobile number in the blue header.
- Verify that the Profile screen opens directly.
- Verify that the UI matches the reference image (colors, typography, icons).
- Verify that the back button returns to the Menu tab.
- Test on different screen sizes to ensure responsiveness.
