# Implementation Plan - Update Forgot Password Flow

Update the existing Forgot Password flow to match the new API specifications, including Send OTP, Verify OTP, and Reset Password steps.

## User Review Required

> [!IMPORTANT]
> The `tenantCode` field will be removed from the Forgot Password screen UI as it is no longer required by the API.
> The `resetToken` will be handled internally and will not be exposed to the user.
> The OTP validation is already set to 5 digits, but I will ensure it matches the new requirement.

## Proposed Changes

### Data Layer

#### [MODIFY] [forgot_password_request.dart](file:///E:/FlutterPracticeSrLevel/lib/data/models/forgot_password_request.dart)
- Update `ForgotPasswordRequest` to contain only `identifier`.
- Add `VerifyOtpRequest` model: `{"identifier": "...", "otp": "..."}`.
- Add `ResetPasswordRequest` model: `{"resetToken": "...", "newPassword": "..."}`.

#### [MODIFY] [forgot_password_response.dart](file:///E:/FlutterPracticeSrLevel/lib/data/models/forgot_password_response.dart)
- Update `ForgotPasswordData` to include `maskedIdentifier`, `otpExpiresInSeconds`, and `resendAfterSeconds`.
- Add `VerifyOtpResponse` and `VerifyOtpData` models (containing `resetToken`).
- Add `ResetPasswordResponse` model.

#### [MODIFY] [auth_api_service.dart](file:///E:/FlutterPracticeSrLevel/lib/data/datasource/remote/auth_api_service.dart)
- Update `forgotPasswordSendOtp` to use new request/response models.
- Implement `verifyForgotPasswordOtp` API call.
- Implement `resetPassword` API call.

#### [MODIFY] [auth_repository.dart](file:///E:/FlutterPracticeSrLevel/lib/domain/repositories/auth_repository.dart) & [auth_repository_impl.dart](file:///E:/FlutterPracticeSrLevel/lib/data/repositories/auth_repository_impl.dart)
- Update method signatures to match the new flow:
    - `requestPasswordReset(String identifier)`
    - `verifyOtp(String identifier, String otp)` -> returns `VerifyOtpData`.
    - `updatePassword(String resetToken, String newPassword)`.

### Domain Layer

#### [MODIFY] [forgot_password_usecase.dart](file:///E:/FlutterPracticeSrLevel/lib/domain/usecases/forgot_password_usecase.dart)
- Update `execute` to take only `identifier`.

#### [MODIFY] [verify_otp_usecase.dart](file:///E:/FlutterPracticeSrLevel/lib/domain/usecases/verify_otp_usecase.dart)
- Update `execute` to return `VerifyOtpData`.

#### [MODIFY] [update_password_usecase.dart](file:///E:/FlutterPracticeSrLevel/lib/domain/usecases/update_password_usecase.dart)
- Update `execute` to take `resetToken` and `newPassword`.

### Presentation Layer

#### [MODIFY] [forgot_password_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/forgot_password/forgot_password_viewmodel.dart)
- Remove `tenantCodeController` and related validation.
- Add `resetToken` observable.
- Update `sendOtp` to pass only `identifier`.
- Update `updatePassword` to use `resetToken`.
- Handle new response data for timers and masked identifier.

#### [MODIFY] [forgot_password_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/forgot_password/forgot_password_screen.dart)
- Remove the Tenant Code text field and its error message.
- Keep other design elements intact.

#### [MODIFY] [otp_verification_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/otp_verification/otp_verification_viewmodel.dart)
- Update `onInit` to receive `maskedIdentifier`, `otpExpiresInSeconds`, and `resendAfterSeconds`.
- Update `_startTimer` to use dynamic values.
- Update `verifyOtp` to handle the `VerifyOtpData` response and pass `resetToken` back to `ForgotPasswordViewModel`.
- Update `resendOtp` to use the new `forgotPasswordUseCase` signature.

#### [MODIFY] [otp_verification_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/otp_verification/otp_verification_screen.dart)
- Display `maskedIdentifier` instead of the raw phone number if available.

## Verification Plan

### Automated Tests
- I will verify the logic in the ViewModels and UseCases.
- Ensure the API calls are correctly formatted by inspecting the models.

### Manual Verification
- Verify the flow from Forgot Password -> Send OTP -> OTP Screen -> Verify OTP -> Reset Password -> Success.
- Check that the timers (Expiry and Resend) are working based on API response.
- Confirm that the `resetToken` is not visible in the UI.
- Verify that navigation works as expected.
