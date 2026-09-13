# Walkthrough - Forgot Password Flow Update

I have updated the Forgot Password flow in the Flutter application to match the new API specifications. The flow now supports dynamic OTP expiry/resend timers and secure internal handling of the `resetToken`.

## Changes

### Data Models
- **[forgot_password_request.dart](file:///E:/FlutterPracticeSrLevel/lib/data/models/forgot_password_request.dart)**:
    - Updated `ForgotPasswordRequest` to use `identifier`.
    - Added `VerifyOtpRequest` and `ResetPasswordRequest`.
- **[forgot_password_response.dart](file:///E:/FlutterPracticeSrLevel/lib/data/models/forgot_password_response.dart)**:
    - Updated `ForgotPasswordData` with `maskedIdentifier` and dynamic timer fields.
    - Added `VerifyOtpResponse` (containing `resetToken`) and `ResetPasswordResponse`.

### API & Repository
- **[auth_api_service.dart](file:///E:/FlutterPracticeSrLevel/lib/data/datasource/remote/auth_api_service.dart)**: Implemented `forgotPasswordSendOtp`, `verifyForgotPasswordOtp`, and `resetPassword` endpoints.
- **[auth_repository_impl.dart](file:///E:/FlutterPracticeSrLevel/lib/data/repositories/auth_repository_impl.dart)**: Connected the service methods to the repository, replacing mocks for the Forgot Password flow.

### Use Cases
- Updated `ForgotPasswordUseCase`, `VerifyOtpUseCase`, and `UpdatePasswordUseCase` to reflect the new API structure and data types.

### Presentation & UI
- **[forgot_password_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/forgot_password/forgot_password_viewmodel.dart)**:
    - Removed `tenantCode` logic.
    - Added internal `resetToken` storage.
    - Updated navigation to pass dynamic timer data to the OTP screen.
- **[forgot_password_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/forgot_password/forgot_password_screen.dart)**: Removed the Tenant Code text field from the UI.
- **[otp_verification_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/otp_verification/otp_verification_viewmodel.dart)**:
    - Implemented dynamic OTP expiry and resend countdowns based on API response.
    - Updated OTP verification to return the `resetToken` to the Forgot Password flow.
- **[otp_verification_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/otp_verification/otp_verification_screen.dart)**: Now displays the `maskedIdentifier` received from the API.

## Verification Results

### Flow Verification
1.  **Forgot Password**: User enters mobile number -> `send-otp` API is called with `identifier`.
2.  **OTP Verification**: Screen displays masked identifier and starts timers based on `otpExpiresInSeconds` and `resendAfterSeconds`.
3.  **Verify OTP**: User enters 5-digit OTP -> `verify-otp` API is called -> `resetToken` is received and stored internally.
4.  **Reset Password**: User sets new password -> `reset-password` API is called with `resetToken` and `newPassword`.
5.  **Success**: Success message is shown, and the user navigates back to Login.

### Security
- The `resetToken` is managed entirely within the ViewModels and is never displayed in the UI or printed to logs.
