# Walkthrough - Dynamic ViewModels & Centralized Session Data

I have updated the application to ensure all user-related data is dynamic and fetched from the centralized session storage after a successful login. Hardcoded demo values like "Super Administrator", "Ankush", and "Sagar" have been replaced.

## Changes Made

### Centralized Session Management
- **[SharedPrefsManager](file:///E:/FlutterPracticeSrLevel/lib/core/utils/shared_prefs_manager.dart)**: Enhanced to store all fields from the Login API:
    - `userUuid`, `username`, `companyUuid`, `companyCode`
    - `roles` (serialized as JSON list)
    - `mustChangePassword`, `sessionMode`, `channel`
    - Added helper methods like `getRoles()`, `mustChangePassword()`, etc.

### Data Layer Updates
- **[User Entity](file:///E:/FlutterPracticeSrLevel/lib/domain/entities/user.dart)**: Added `sessionMode` and `channel` to complete the data mapping from the API.
- **[LoginResponse](file:///E:/FlutterPracticeSrLevel/lib/data/models/login_response.dart)**: Updated `toEntity()` to include the new fields.

### Dynamic ViewModels
- **[LoginViewModel](file:///E:/FlutterPracticeSrLevel/lib/presentation/login/login_viewmodel.dart)**: Now saves the full set of user identity and session parameters to `SharedPrefsManager` upon successful authentication.
- **[HomeViewModel](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/home_viewmodel.dart)**:
    - Replaced hardcoded "User" and "Super Administrator".
    - `loadUserData()` now dynamically fetches the `displayName` and joins multiple `roles` for display.
- **[ProfileViewModel](file:///E:/FlutterPracticeSrLevel/lib/presentation/profile/profile_viewmodel.dart)**:
    - Fully dynamic. Displays `displayName`, `roles`, `companyCode`, and `userUuid` from the session.
    - Replaced hardcoded name "Ankush" and mobile number.
- **[FavoritesViewModel](file:///E:/FlutterPracticeSrLevel/lib/presentation/favorites/favorites_viewmodel.dart)**:
    - Replaced hardcoded name "Sagar" and email.
    - Fetches user identity and roles from session.

## Verification

> [!NOTE]
> All ViewModels now rely on `SharedPrefsManager` as the single source of truth for logged-in user data. This ensures that changes in the Login API response automatically reflect across the entire application without further code changes.

### Dynamic Roles Handling
- The application now supports multiple roles (e.g., `["FIELD_USER", "MANAGER"]`) by joining them as a comma-separated string in the UI.

### Clean UI State
- Default values in ViewModels are now neutral (e.g., "User", "Field User", "N/A") and are instantly updated with real data once `loadUserData()` is called during `onInit`.

render_diffs(file:///E:/FlutterPracticeSrLevel/lib/core/utils/shared_prefs_manager.dart)
render_diffs(file:///E:/FlutterPracticeSrLevel/lib/presentation/login/login_viewmodel.dart)
render_diffs(file:///E:/FlutterPracticeSrLevel/lib/presentation/home/home_viewmodel.dart)
render_diffs(file:///E:/FlutterPracticeSrLevel/lib/presentation/profile/profile_viewmodel.dart)
render_diffs(file:///E:/FlutterPracticeSrLevel/lib/presentation/favorites/favorites_viewmodel.dart)
