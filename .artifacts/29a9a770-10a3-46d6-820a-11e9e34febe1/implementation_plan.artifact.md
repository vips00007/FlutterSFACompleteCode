# Implementation Plan - Match Phone Number Field to Login Username Field

This plan outlines the changes to make the Phone Number input field on the Forgot Password screen visually identical to the Username field on the Login Screen.

## User Review Required

> [!IMPORTANT]
> To ensure **only** the Phone Number field is updated, I will implement the new styling specifically for that field. The Password fields in the "New Credentials" step will remain unchanged, preserving their current design as per the "ONLY" constraint.

## Proposed Changes

### Forgot Password Component

#### [MODIFY] [forgot_password_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/forgot_password/forgot_password_screen.dart)

1.  **Add specialized styling for Phone Field**:
    *   Implement a new helper method `_buildLoginStyleTextField` (or update the phone field call) to include:
        *   `Container` wrapper with `height: 50`.
        *   `BoxDecoration` with `color: Colors.white`, `borderRadius: BorderRadius.circular(30)`, `border: Border.all(color: Colors.grey.shade200)`, and a soft `boxShadow`.
        *   `TextField` with `style: TextStyle(fontSize: 13)`.
        *   `InputDecoration` with `hintStyle: TextStyle(color: Colors.grey.shade400)`, `prefixIcon: Icon(..., color: Colors.grey.shade600, size: 18)`, `border: InputBorder.none`, and `contentPadding: EdgeInsets.symmetric(vertical: 13)`.
2.  **Apply to Phone Input**:
    *   Update the call in `_buildForgetPasswordStep` to use this new styling.

## Verification Plan

### Manual Verification
*   **Visual Check**: Compare the Phone Number field on the Forgot Password screen with the Username field on the Login screen. They should be identical in height, color, shadow, and text styling.
*   **Step Persistence**: Ensure the styling remains consistent if the user navigates back and forth.
*   **Isolation Check**: Navigate to the "New Credentials" step and verify that the Password fields **do not** have the new white/shadow styling, as they should remain in the original design.
