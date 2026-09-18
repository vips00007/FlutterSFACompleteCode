# Walkthrough - Phone Number Field Styling Update

I have updated the Phone Number input field on the Forgot Password screen to be visually identical to the Username field on the Login Screen.

## Changes Made

### UI Consistency
-   **Field Re-styling**: Replaced the previous `_buildTextField` implementation for the Phone Number field with a new `_buildLoginStyleTextField` method that replicates the Login screen's input style.
-   **Visual Attributes**:
    -   **Height**: Set to `50`.
    -   **Background**: Changed to solid `Colors.white`.
    -   **Shape**: Applied a `borderRadius` of `30` (pill-shaped).
    -   **Border**: Added a subtle `Colors.grey.shade200` border.
    -   **Shadow**: Added a soft `BoxShadow` to match the Login screen's elevation effect.
    -   **Typography**: Updated font size to `13` and hint text color to `Colors.grey.shade400`.
    -   **Icons**: Updated the prefix icon color to `Colors.grey.shade600` and size to `18`.

## Verification Results

### Manual Verification
-   **Visual Match**: Confirmed that the Phone Number field on the Forgot Password screen now looks exactly like the Username field on the Login screen.
-   **Isolation Check**: Verified that the Password fields in the "New Credentials" step and the OTP boxes remain unaffected, preserving their original design as requested.
