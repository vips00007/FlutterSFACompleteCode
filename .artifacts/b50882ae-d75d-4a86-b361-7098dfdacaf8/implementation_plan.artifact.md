# Implementation Plan - Edit Profile Flow

This plan outlines the steps to create and integrate the two Edit Profile screens into the Visit Details flow, based on the provided design screenshots.

## Goal
Implement the "Edit Profile" flow, which allows users to request updates to a distributor's details. The changes are sent for approval, and a success confirmation screen is displayed.

## Proposed Changes

### 1. New Edit Profile Screens
#### [NEW] `lib/presentation/tickets/edit_profile/edit_profile_screen.dart`
Create the form screen:
- AppBar with title "Edit profile" and subtitle "Update distributor details".
- A "Done" button in the top right (which acts as the submit button).
- Header card showing distributor name, ID, location, and an "Active" badge.
- Information card: "Changes go to the company for approval".
- Text fields with leading icons:
  - Distributor name
  - Owner name
  - Mobile (+91 prefix)
  - Area / Beat
  - GST number (grayed out, marked as "Locked" with a message "GST number can't be edited here").

#### [NEW] `lib/presentation/tickets/edit_profile/edit_profile_success_screen.dart`
Create the success confirmation screen:
- AppBar with title "Edit profile" and subtitle "Update distributor details" (No back button or a back button that returns to profile).
- Large purple checkmark icon with "Sent for approval" text.
- Summary card showing "SUBMITTED CHANGES" (e.g., Mobile updated) with a "Pending approval" badge.
- Full-width "Back to profile" button at the bottom.

#### [NEW] `lib/presentation/tickets/edit_profile/edit_profile_viewmodel.dart`
Create a `GetxController` to handle:
- Form field controllers and local state.
- Submission logic (simulating an API call).
- Passing the submitted changes to the success screen.

### 2. Navigation Updates
#### [MODIFY] `lib/routes/route_names.dart`
Add route constants:
- `static const String edit_profile = '/edit_profile';`
- `static const String edit_profile_success = '/edit_profile_success';`

#### [MODIFY] `lib/routes/routes.dart`
Register the new routes using `GetPage`.

### 3. Integration with Visit Details
#### [MODIFY] `lib/presentation/tickets/visit_details_screen.dart`
Update the `_buildProfileCard` method:
- Attach an `onPressed` handler to the "Edit profile" `OutlinedButton`.
- Navigate to the `EditProfileScreen` passing the `Outlet` arguments.

## Verification Plan
1. Open the app and navigate to the `VisitDetailsScreen`.
2. Click the "Edit profile" button.
3. Verify that the `EditProfileScreen` opens and matches the design.
4. Modify a field (e.g., Mobile) and click "Done".
5. Verify that it navigates to the `EditProfileSuccessScreen` and displays the submitted changes correctly.
6. Click "Back to profile" and ensure it returns safely to the `VisitDetailsScreen`.