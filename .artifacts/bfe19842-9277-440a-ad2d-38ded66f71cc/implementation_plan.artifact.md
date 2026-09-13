# Implementation Plan - Fix "TextEditingController used after being disposed"

Resolve the crash on the Login screen where input fields throw errors due to disposed controllers. This happens because the `LoginViewModel` disposes the controllers in `onClose`, but the `LoginScreen` widget might still be active in the tree during route transitions.

## User Review Required

> [!IMPORTANT]
> I will move the `TextEditingController` management from the `LoginViewModel` to the `LoginScreen` by converting it to a `StatefulWidget`. This ensures the controllers follow the Widget's lifecycle, which is the recommended practice in Flutter to avoid disposal conflicts.

## Proposed Changes

### Login Feature

#### [MODIFY] [login_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/login/login_viewmodel.dart)
- Remove `usernameController` and `passwordController`.
- Update `login()` method to accept `username` and `password` as arguments.
- Update `_loadSavedCredentials()` to return values or set them in the screen's controllers via a callback or initial state.
- Remove `onClose()` disposal logic for these controllers.

#### [MODIFY] [login_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/login/login_screen.dart)
- Convert `LoginScreen` from `StatelessWidget` to `StatefulWidget`.
- Initialize `usernameController` and `passwordController` in `initState()`.
- Dispose them in `dispose()`.
- Pass these controllers to the `_buildInputField` widgets.
- Update the "Generate OTP" button to call `viewModel.login(usernameController.text, passwordController.text)`.

## Verification Plan

### Manual Verification
- **Login Flow**:
  1. Open Login screen.
  2. Enter credentials and click "Generate OTP".
  3. Verify navigation to OTP screen without crash.
  4. Complete OTP verification and verify navigation to Dashboard without crash.
  5. Try navigating BACK from OTP to Login and ensure fields are still usable.
- **Credential Loading**:
  1. Ensure "Remember Me" credentials still load correctly on app start.
