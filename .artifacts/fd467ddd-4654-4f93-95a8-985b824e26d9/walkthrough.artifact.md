# Walkthrough - New Forgot Password Flow

I have completely replaced the existing Forgot Password screen with a modern, 4-step flow as per the reference image. The implementation follows the project's Clean Architecture and uses the existing theme colors.

## Changes Made

### 1. Multi-Step UI Flow
Implemented a reactive 4-step flow within `ForgotPasswordScreen`:
- **Step 1: Forgot Password**: Phone number input with country code selector.
- **Step 2: Code Verification**: 6-digit OTP input with automatic focus management.
- **Step 3: New Credentials**: Password reset fields with visibility toggles and matching validation.
- **Step 4: Password Updated**: Success screen with a shortcut back to Login.

### 2. Clean Architecture Enhancements
- **Domain Layer**: Added `verifyOtp` and `updatePassword` methods to `AuthRepository`. Created `VerifyOtpUseCase` and `UpdatePasswordUseCase`.
- **Data Layer**: Implemented the new methods in `AuthRepositoryImpl` with mocked behavior (using `123456` as the test OTP).
- **Presentation Layer**:
    - Updated `ForgotPasswordViewModel` to manage the flow state, inputs, and validation.
    - Updated `AppRoutes` to handle the new dependency injections.

### 3. Theme & Design
- **Color Palette**: Strictly used `AppColors.sfaBlue` for primary actions instead of the yellow in the reference image.
- **Icons**: Used Material icons that closely match the reference illustration styles.
- **Responsiveness**: Used `SingleChildScrollView` and flexible layouts to ensure compatibility across device sizes.

## Verification Results

### Manual Test Flow
1. **Navigate**: Clicked "Forgot Password?" on the Login screen.
2. **Step 1**: Entered a phone number. Clicked "NEXT".
3. **Step 2**: Entered OTP `123456`. Clicked "VERIFY CODE".
4. **Step 3**: Entered and confirmed a new password. Clicked "UPDATE".
5. **Step 4**: Success screen displayed. Clicked "LOGIN" to return to the login screen.

> [!TIP]
> For testing purposes, the OTP is hardcoded to `123456` in the `AuthRepositoryImpl` mock.

> [!IMPORTANT]
> The back button correctly handles step-by-step navigation, except on the final success screen where it is disabled to prevent re-submitting the update.
