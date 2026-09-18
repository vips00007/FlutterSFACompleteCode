# Implementation Plan - Dynamic ViewModels (User Data Integration)

This plan aims to make all ViewModels dynamic by fetching user-related information from the centralized session storage (`SharedPrefsManager`) instead of using hardcoded or demo values.

## User Review Required

> [!IMPORTANT]
> - Mobile number is not currently provided by the Login API. I will add a placeholder in `SharedPrefsManager` for future integration, but per instructions, I will not invent a fake one.
> - Roles will be handled as a `List<String>`. In UIs where a single role is expected, I will use the first role in the list or join them as a comma-separated string.
> - "Super Administrator" and other hardcoded names like "Ankush" will be replaced with dynamic values.

## Proposed Changes

### Core / Utils

#### [MODIFY] [shared_prefs_manager.dart](file:///E:/FlutterPracticeSrLevel/lib/core/utils/shared_prefs_manager.dart)
- Add keys and methods for:
    - `userUuid`
    - `username`
    - `companyUuid`
    - `companyCode`
    - `roles` (serialized as a JSON string)
    - `mustChangePassword`
    - `mobileNumber` (for future use)
- Update `saveSessionData` to include these new fields.

### Presentation Layer

#### [MODIFY] [login_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/login/login_viewmodel.dart)
- Update the `login` method to save all user details (roles, UUIDs, etc.) into `SharedPrefsManager` upon success.

#### [MODIFY] [home_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/home_viewmodel.dart)
- Update `loadUserData` to fetch `userName` and `role` dynamically.
- Handle multiple roles by joining them.

#### [MODIFY] [profile_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/profile/profile_viewmodel.dart)
- Update `loadUserData` to fetch all user fields.
- Replace hardcoded "Super Administrator", mobile number (if available), and email with dynamic values.

#### [MODIFY] [favorites_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/favorites/favorites_viewmodel.dart)
- Update to fetch `role` and `email` dynamically from session if possible.

#### [MODIFY] [attendance_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/account/attendance_viewmodel.dart) & Others
- Inspect and replace any other hardcoded user identity markers.

## Verification Plan

### Manual Verification
- **Login Verification**: Verify that after login, all user details are saved in `SharedPrefs`.
- **UI Verification**:
    - Dashboard/Home shows the correct `displayName` and `roles`.
    - Profile screen shows correct `username`, `displayName`, and `roles`.
    - Ensure no "Super Administrator" or "Ankush" strings remain in the ViewModels.
