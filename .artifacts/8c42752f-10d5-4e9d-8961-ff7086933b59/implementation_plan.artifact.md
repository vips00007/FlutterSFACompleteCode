# Dynamic User Name Implementation

This plan outlines the steps to replace the hardcoded "Test User" with a dynamic user name retrieved from the Login API (mocked) and correctly displayed on the Dashboard.

## Proposed Changes

### Data Layer

#### [MODIFY] [auth_repository_impl.dart](file:///E:/FlutterPracticeSrLevel/lib/data/repositories/auth_repository_impl.dart)
- Update the mocked `verifyLoginOtp` response to return a realistic name (e.g., "Sagar") instead of "Test User".
- Ensure the `login` method (if used) also returns a consistent name.

### Presentation Layer

#### [MODIFY] [home_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/home_screen.dart)
- Update the header to display "Welcome, [Name]" instead of just the name.
- Ensure the name is retrieved from `HomeViewModel.userName`.

#### [MODIFY] [home_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/home_viewmodel.dart)
- Ensure the initial value of `userName` is "User" (fallback).
- Verify that `loadUserData` correctly reads from `SharedPrefsManager`.

### Storage

#### [MODIFY] [shared_prefs_manager.dart](file:///E:/FlutterPracticeSrLevel/lib/core/utils/shared_prefs_manager.dart)
- (Optional) Verify keys and methods are consistent.

## Verification Plan

### Manual Verification
1. Log in with any username/password.
2. Enter the OTP "12345".
3. Verify that the Dashboard header displays "Welcome, Sagar" (or the updated mocked name).
4. Go to the Profile screen and verify the name is consistent there.
5. Log out and log back in, verify the name updates if changed in the mock.
6. Test with a missing name in SharedPreferences (by clearing data) and verify it falls back to "Welcome, User" or just "User".
