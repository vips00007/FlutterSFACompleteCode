# Implementation Plan - Update Forgot Password Flow

Update the existing Forgot Password flow to include **Tenant Code** and integrate the `forgot-password/send-otp` API.

## User Review Required

> [!IMPORTANT]
> The "Forgot Password" flow is currently implemented as a multi-step single screen (`ForgotPasswordScreen`). The implementation will remain within this screen, updating the relevant steps.

## Proposed Changes

### Data Layer

#### [NEW] [forgot_password_request.dart](file:///E:/FlutterPracticeSrLevel/lib/data/models/forgot_password_request.dart)
- Create `ForgotPasswordRequest` model with `tenantCode` and `phone`.

#### [NEW] [forgot_password_response.dart](file:///E:/FlutterPracticeSrLevel/lib/data/models/forgot_password_response.dart)
- Create `ForgotPasswordResponse` and `ForgotPasswordData` models to match the API response.

#### [MODIFY] [auth_api_service.dart](file:///E:/FlutterPracticeSrLevel/lib/data/datasource/remote/auth_api_service.dart)
- Add `forgotPasswordSendOtp` method to call `POST /api/v1/auth/forgot-password/send-otp`.

### Domain Layer

#### [MODIFY] [auth_repository.dart](file:///E:/FlutterPracticeSrLevel/lib/domain/repositories/auth_repository.dart)
- Update `requestPasswordReset` signature to `Future<ForgotPasswordData> requestPasswordReset(String tenantCode, String phone)`.

#### [MODIFY] [auth_repository_impl.dart](file:///E:/FlutterPracticeSrLevel/lib/data/repositories/auth_repository_impl.dart)
- Implement `requestPasswordReset` to use `AuthApiService`.

#### [MODIFY] [forgot_password_usecase.dart](file:///E:/FlutterPracticeSrLevel/lib/domain/usecases/forgot_password_usecase.dart)
- Update `execute` signature to `Future<ForgotPasswordData> execute(String tenantCode, String phone)`.

### Presentation Layer

#### [MODIFY] [forgot_password_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/forgot_password/forgot_password_viewmodel.dart)
- Add `tenantCodeController`.
- Add observable variables for `maskedPhone`, `otpExpiresInSeconds`, and `resendAfterSeconds`.
- Update `sendOtp` method to:
    - Validate `tenantCode` and `phone`.
    - Call the updated use case.
    - Store the response data.
    - Navigate to the next step (OTP verification).

#### [MODIFY] [forgot_password_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/forgot_password/forgot_password_screen.dart)
- Add "Tenant Code" text field above the "Phone Number" field in `_buildForgetPasswordStep`.
- Update `_buildVerificationStep` to display the `maskedPhone` from the viewmodel.

## Verification Plan

### Automated Tests
- I will check the code for compilation errors.
- I will ensure the logic for validation and API calling is correct based on the prompt.

### Manual Verification
- The user should verify the UI changes on the "Forgot Password" screen.
- The user should verify the API integration by entering valid tenant code and phone number.
