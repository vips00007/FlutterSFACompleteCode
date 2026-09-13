# Implementation Plan - Password Reset Flow

Implement the final stage of the forgot password flow by creating a dedicated **Reset Password** screen and updating the navigation from the OTP verification stage.

## User Review Required

> [!IMPORTANT]
> The current implementation of `ForgotPasswordScreen` already contains a "New Credentials" step. I will extract this into a dedicated `ResetPasswordScreen` as requested, which will provide a cleaner navigation flow and better separation of concerns.

## Proposed Changes

### Routes & Navigation

#### [MODIFY] [route_names.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/route_names.dart)
- Add `reset_password_view` constant.

#### [MODIFY] [routes.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/routes.dart)
- Register `ResetPasswordScreen` with its binding.
- Provide `UpdatePasswordUseCase` to `ResetPasswordViewModel`.

#### [MODIFY] [otp_verification_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/otp_verification/otp_verification_viewmodel.dart)
- Update `verifyOtp` success logic to navigate to `RoutesName.reset_password_view` instead of `RoutesName.forgot_password_view`.
- Pass `identifier` and `resetToken` in arguments.

### Presentation Layer

#### [NEW] [reset_password_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/reset_password/reset_password_screen.dart)
- Implement UI for entering New Password and Confirm Password.
- Match existing design (gradient background, icon header, rounded buttons, styled text fields).
- Show success state (success icon/message) before navigating to Login.

#### [NEW] [reset_password_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/reset_password/reset_password_viewmodel.dart)
- Handle password input, visibility toggling, and validation (matching passwords).
- Call `UpdatePasswordUseCase.execute(resetToken, newPassword)`.
- Manage loading and error states.
- Handle navigation to Login screen upon success.

### Cleanup

#### [MODIFY] [forgot_password_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/forgot_password/forgot_password_screen.dart)
- Remove `_buildNewCredentialsStep` and `_buildSuccessStep` as they are now moved to the new screen.
- Simplify `currentStep` logic.

#### [MODIFY] [forgot_password_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/forgot_password/forgot_password_viewmodel.dart)
- Remove `updatePassword` logic and redundant controllers/state.

## Verification Plan

### Manual Verification
1. Start Forgot Password flow.
2. Enter a phone number and tap NEXT.
3. Enter OTP in `OtpVerificationScreen`.
4. Verify navigation to the new **Reset Password** screen.
5. Test validation (empty fields, mismatched passwords).
6. Enter matching passwords and tap UPDATE.
7. Verify loading state.
8. Verify success message/view.
9. Verify navigation to **Login** screen.
10. Check if the app UI remains consistent with the rest of the app.
