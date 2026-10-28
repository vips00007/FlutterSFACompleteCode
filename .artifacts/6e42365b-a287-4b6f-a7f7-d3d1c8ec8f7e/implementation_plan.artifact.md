# Replace Create Plan UI

This plan details the replacement of the existing "Create Travel Plan" UI with a new flow based on the provided HTML prototype.

## User Review Required

- The current AI-driven Create Plan UI and `CreatePlanViewModel` will be completely replaced by the new flow.
- The new flow consists of:
  - **My Plans List:** Shows previous plans (mocked).
  - **Select Retailers:** Search and select multiple retailers.
  - **Plan Type Bottom Sheet:** Local vs Upcountry.
  - **Plan Details:** Dates, geography, remarks.
  - **Success Screen:** Confirmation.

## Proposed Changes

### [MODIFY] lib/presentation/tickets/create_plan_viewmodel.dart
- Remove existing AI-related data structures (`AiGoal`, `aiGoals`, etc.).
- Add state variables for the new flow:
  - `currentScreen` ('list', 'retailers', 'details', 'done')
  - Mock lists for retailers, territories, cities, and remarks based on the HTML.
  - Selected retailers set, search query.
  - Plan type ('Local', 'Upcountry'), `fromDate`, `toDate`, `planBy` ('Territory', 'City'), `selectedPlace`, `remark`.
  - Validation errors map.
  - List of created plans.
- Add methods for navigation (`go(screen)`), validation, and form submission.

### [MODIFY] lib/presentation/tickets/create_plan_screen.dart
- Completely rewrite the UI to implement the new HTML design.
- Define a custom color palette mirroring the HTML (e.g., green accents: `#0f6b4f`).
- Implement the 4 distinct views (`_buildListScreen`, `_buildRetailersScreen`, `_buildDetailsScreen`, `_buildDoneScreen`) controlled by an `Obx` that observes `viewModel.currentScreen`.
- Implement `_showTypeBottomSheet` to replicate the HTML's "Choose plan type" sheet.
- Ensure the layout is responsive, using standard Flutter components (like `ListView`, `TextField`, `DropdownButton`) styled to match the HTML design.

## Verification Plan

### Manual Verification
- Click "Create Plan" on the Visits screen.
- Verify it opens the "My plans" screen with a green app theme.
- Click "+ Create plan" and verify navigation to the "Select retailers" screen.
- Test the search bar and "Select all" checkbox.
- Select a few retailers and click "Add plan". Verify the bottom sheet appears.
- Select a type (e.g., "Local") and click "Continue".
- Verify navigation to the "Details" screen.
- Leave fields empty and click "Submit for approval". Verify validation errors appear.
- Fill out the form and submit. Verify the "Sent for approval" success screen appears.
- Click "Back to my plans" and verify the new plan is in the list.