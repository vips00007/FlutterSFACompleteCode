# Update SFA Login to use OTP APIs

This plan outlines the steps to migrate the existing login flow to a new OTP-based flow using the provided SFA Login OTP APIs.

## User Review Required

> [!IMPORTANT]
> The login flow will be changed to a two-step process:
> 1. Enter Identifier -> Send OTP
> 2. Enter OTP -> Verify OTP & Login
> The Password field will be removed from the Login Screen as it's no longer required by the new OTP APIs.

## Proposed Changes

### [Data Layer]

#### [NEW] [sfa_otp_models.dart](file:///E:/FlutterPracticeSrLevel/lib/data/models/sfa_otp_models.dart)
Define request and response models for Send OTP and Verify OTP APIs.
- `SendLoginOtpRequest`
- `SendLoginOtpResponse`
- `VerifyLoginOtpRequest` (will use `LoginResponse` for success case)

#### [MODIFY] [auth_api_service.dart](file:///E:/FlutterPracticeSrLevel/lib/data/datasource/remote/auth_api_service.dart)
Add methods for the new OTP endpoints:
- `sendLoginOtp(SendLoginOtpRequest request)`
- `verifyLoginOtp(VerifyLoginOtpRequest request)`

#### [MODIFY] [auth_repository_impl.dart](file:///E:/FlutterPracticeSrLevel/lib/data/repositories/auth_repository_impl.dart)
Update implementation to use the new API service methods. Remove mock logic.

---

### [Domain Layer]

#### [MODIFY] [auth_repository.dart](file:///E:/FlutterPracticeSrLevel/lib/domain/repositories/auth_repository.dart)
Update the interface:
- Add `Future<SendLoginOtpData> sendLoginOtp(String identifier)`
- Update `verifyLoginOtp` to `Future<User> verifyLoginOtp(String challengeId, String otp)`

#### [MODIFY] [login_usecase.dart](file:///E:/FlutterPracticeSrLevel/lib/domain/usecases/login_usecase.dart)
Rename/Update to `SendLoginOtpUseCase` (or update `execute` to handle OTP sending).

#### [MODIFY] [verify_login_otp_usecase.dart](file:///E:/FlutterPracticeSrLevel/lib/domain/usecases/verify_login_otp_usecase.dart)
Update parameters to match the new repository method.

---

### [Presentation Layer]

#### [MODIFY] [login_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/login/login_viewmodel.dart)
- Update `login` method to call `sendLoginOtp`.
- On success, navigate to `OtpVerificationScreen` passing `challengeId`, `identifier`, and timer values.

#### [MODIFY] [login_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/login/login_screen.dart)
- Remove Password field.
- Update "Login" button to "Generate OTP".

#### [MODIFY] [otp_verification_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/otp_verification/otp_verification_viewmodel.dart)
- Store `challengeId`.
- Update `verifyOtp` to use `challengeId`.
- Update `resendOtp` to call the new Send OTP API and update the stored `challengeId` and restart timers.
- After successful verification, save all authentication data (token, user info) using `SharedPrefsManager`.

#### [MODIFY] [home_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/home_viewmodel.dart)
- Ensure `loadUserData` correctly reflects the `displayName` from the new API.

---

### [Core Layer]

#### [MODIFY] [shared_prefs_manager.dart](file:///E:/FlutterPracticeSrLevel/lib/core/utils/shared_prefs_manager.dart)
Ensure `saveSessionData` covers all fields returned by the OTP Verification API.

## Verification Plan

### Automated Tests
- I will verify the logic in the ViewModels and Repositories by ensuring they correctly map the new API responses.

### Manual Verification
- Verify the Login screen only shows the Identifier field.
- Verify clicking "Generate OTP" calls the Send OTP API and navigates to the OTP screen.
- Verify entering OTP calls the Verify OTP API.
- Verify successful login saves the token and navigates to the Dashboard.
- Verify the Dashboard displays the correct user name.
- Verify Resend OTP updates the `challengeId` and restarts timers.
- Verify error messages from the backend are displayed on the OTP screen.
