# Implementation Plan - New Forgot Password Flow

Replace the existing single-step Forgot Password screen with a new 4-step flow as per the reference image, using the application's existing theme and architecture.

## User Review Required

> [!IMPORTANT]
> The implementation will use mock API calls for OTP verification and password updates, as the corresponding backend endpoints are not yet defined in the existing `AuthApiService`. I will follow the existing pattern found in `AuthRepositoryImpl`.

> [!NOTE]
> The UI will be implemented as a multi-step flow within the existing `ForgotPasswordScreen` to keep the navigation simple and consistent with the request to "replace the existing Forgot Password screen".

## Proposed Changes

### Domain Layer

#### [MODIFY] [auth_repository.dart](file:///E:/FlutterPracticeSrLevel/lib/domain/repositories/auth_repository.dart)
- Add `verifyOtp(String phone, String otp)` method.
- Add `updatePassword(String phone, String password)` method.

#### [NEW] [verify_otp_usecase.dart](file:///E:/FlutterPracticeSrLevel/lib/domain/usecases/verify_otp_usecase.dart)
- Create a usecase to handle OTP verification.

#### [NEW] [update_password_usecase.dart](file:///E:/FlutterPracticeSrLevel/lib/domain/usecases/update_password_usecase.dart)
- Create a usecase to handle password updates.

### Data Layer

#### [MODIFY] [auth_repository_impl.dart](file:///E:/FlutterPracticeSrLevel/lib/data/repositories/auth_repository_impl.dart)
- Implement `verifyOtp` and `updatePassword` with mock logic (Future.delayed).

### Presentation Layer

#### [MODIFY] [routes.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/routes.dart)
- Update dependency injection to include `VerifyOtpUseCase` and `UpdatePasswordUseCase` for the `ForgotPasswordViewModel`.
- Add `currentStep` (RxInt) to track flow progress (0: Forgot Password, 1: Verification, 2: New Credentials, 3: Success).
- Add controllers for phone number, OTP, new password, and confirm password.
- Add validation logic for each step.
- Implement `nextStep()`, `verifyOtp()`, and `updatePassword()`.

#### [MODIFY] [forgot_password_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/forgot_password/forgot_password_screen.dart)
- Refactor to use a `Switch` or `if/else` based on `viewModel.currentStep`.
- Create 4 separate UI components/methods for each step:
    - **Step 1 (Forgot Password)**: Phone number input with country code.
    - **Step 2 (Code Verification)**: 6-digit OTP input boxes.
    - **Step 3 (New Credentials)**: New/Confirm password fields with visibility toggle.
    - **Step 4 (Password Updated)**: Success message and Login button.
- Ensure icons, typography, and spacing match the reference image while using `AppColors.sfaBlue` as the primary color.

## Verification Plan

### Automated Tests
- Since the project doesn't have a robust test suite for this flow, I will perform manual verification.

### Manual Verification
- Navigate to Forgot Password from Login screen.
- Verify Step 1: Input validation for phone number, click NEXT to go to Step 2.
- Verify Step 2: Enter OTP, click VERIFY CODE to go to Step 3.
- Verify Step 3: Enter matching passwords, click UPDATE to go to Step 4.
- Verify Step 4: Click LOGIN to return to the Login screen.
- Ensure back button navigation works correctly between steps.
- Verify that theme colors (Blue) are used instead of Yellow.
