# Walkthrough - Attendance Check-In and Check-Out Implementation

I have successfully implemented the Attendance Check-In and Check-Out functionality in the SFA application.

## Changes Made

### 1. Dependencies and Permissions
- Added `geolocator: ^13.0.1` to [pubspec.yaml](file:///E:/FlutterPracticeSrLevel/pubspec.yaml).
- Added location permissions to [AndroidManifest.xml](file:///E:/FlutterPracticeSrLevel/android/app/src/main/AndroidManifest.xml) (Android) and [Info.plist](file:///E:/FlutterPracticeSrLevel/ios/Runner/Info.plist) (iOS).

### 2. Data Models
- Created [attendance_request.dart](file:///E:/FlutterPracticeSrLevel/lib/data/models/attendance_request.dart) for API requests.
- Created [attendance_response.dart](file:///E:/FlutterPracticeSrLevel/lib/data/models/attendance_response.dart) to parse API responses.

### 3. API and Repository
- Implemented [attendance_api_service.dart](file:///E:/FlutterPracticeSrLevel/lib/data/datasource/remote/attendance_api_service.dart) for `check-in` and `check-out` endpoints.
- Implemented [attendance_repository_impl.dart](file:///E:/FlutterPracticeSrLevel/lib/data/repositories/attendance_repository_impl.dart).

### 4. Logic Integration
- Updated [HomeViewModel](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/home_viewmodel.dart) to:
    - Capture GPS location using `geolocator`.
    - Convert captured selfie to Base64 string.
    - Handle API calls for both Check-In and Check-Out.
    - Manage attendance states (`CHECKED_IN`, `CHECKED_OUT`).
- Updated [AttendanceCameraScreen](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/widgets/attendance_camera_screen.dart) to pass the `isCheckIn` flag.

### 5. UI Updates
- Enhanced `_buildStartDayCard` in [HomeTabContent](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/tabs/home_tab_content.dart):
    - **Initial state**: Shows "Start Day" button.
    - **After Check-In**: Shows "Checked In" status and "CHECK OUT" button.
    - **After Check-Out**: Shows "Attendance Completed" status.

## Verification

### Manual Verification Steps
1. **Check-In**: Tap "Start Day" -> Capture Selfie -> Confirm. UI updates to "Checked In".
2. **Check-Out**: Tap "CHECK OUT" -> Capture NEW Selfie -> Confirm. UI updates to "Attendance Completed".
3. **Permissions**: The app requests Location and Camera permissions as needed.
4. **Error Handling**: API errors and permission denials are handled with user-friendly snackbars.

> [!TIP]
> Make sure to enable location services on your test device for the attendance feature to work correctly.
