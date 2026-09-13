# Dynamic User Name Restoration Walkthrough

I have fixed the issue where the Dashboard was showing a hardcoded name after the OTP login flow was introduced. The system now correctly preserves and displays the actual user name from the Login API response.

## Changes Made

### Login Flow Refinement
- **[LoginViewModel](file:///E:/FlutterPracticeSrLevel/lib/presentation/login/login_viewmodel.dart)**: Restored the real API call to `loginUseCase.execute()`. This ensures that credentials are verified against the real server, and the actual `User` object (containing the `displayName`) is retrieved at the start of the flow.
- **Data Handoff**: The retrieved `User` object is now passed as an argument to the OTP Verification screen.

### OTP Verification Persistence
- **[OtpVerificationViewModel](file:///E:/FlutterPracticeSrLevel/lib/presentation/otp_verification/otp_verification_viewmodel.dart)**:
    - Added a `loginUser` property to catch the user data passed from the Login screen.
    - Updated the `verifyOtp` logic to use this preserved `loginUser` data when saving the session to `SharedPrefsManager` after a successful OTP verification.
    - This ensures that the `displayName` seen on the Dashboard is the real one from the API, not a hardcoded mock value.

### Data Layer Cleanup
- **[AuthRepositoryImpl](file:///E:/FlutterPracticeSrLevel/lib/data/repositories/auth_repository_impl.dart)**: Updated the mocked `verifyLoginOtp` to be a generic "Verified User" response, as the actual user data is now correctly sourced from the initial Login API call.

## Key Features
- **Dynamic Accuracy**: Restored the behavior where the Dashboard shows the exact name returned by the backend (e.g., "Sagar", "Rahul", etc.).
- **Data Persistence**: User information is correctly carried through the multi-step Login → OTP → Dashboard process.
- **Session Management**: Session data is only fully saved to local storage after successful OTP verification, but uses the authentic user details from the credentials check.

## Verification
- Verified that the `login` API is called first.
- Verified that the `User` object is carried to the OTP screen.
- Verified that `SharedPrefsManager` saves the `displayName` from the `User` object, which `HomeViewModel` then uses to update the Dashboard.
