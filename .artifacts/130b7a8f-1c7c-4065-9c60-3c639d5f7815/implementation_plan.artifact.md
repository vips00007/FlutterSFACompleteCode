# Implementation Plan - Create Tour Plan Bottom Sheet

Implement a responsive modal bottom sheet for creating a tour plan, featuring "Local" and "Outstation" tabs, date range selection, and travel purpose input, matching the provided design.

## User Review Required

> [!IMPORTANT]
> The bottom sheet will use `Get.put(CreateTourPlanViewModel())` when opened to manage its internal state independently of the main screen.

- **Tabs**: "Local" and "Outstation" will be fully functional, switching the visible fields (e.g., "Places to Visit" for Outstation).
- **Date Picking**: Tapping the "Start date" or "End date" fields will open the standard Flutter date picker.
- **Styling**: Corner radius, colors, and typography will match `AppColors` and the reference image.

## Proposed Changes

### presentation/tickets

#### [NEW] [create_tour_plan_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/tickets/create_tour_plan_viewmodel.dart)
- Create a `GetxController` to manage:
  - `selectedTabIndex` (Local vs. Outstation).
  - `startDate` and `endDate` Observables.
  - `travelPurpose` text.
  - `selectedCities` for the Outstation tab.

#### [NEW] [create_tour_plan_bottom_sheet.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/tickets/create_tour_plan_bottom_sheet.dart)
- Implement the UI for the bottom sheet:
  - Handle bar at the top.
  - Title "Create Tour Plan".
  - Custom tab switcher.
  - Date range input row.
  - Travel purpose text area.
  - "Places to Visit" dropdown (conditional).
  - "Create Plan" action button.

#### [MODIFY] [monthly_journey_plan_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/tickets/monthly_journey_plan_screen.dart)
- Update the "Create Plan" button's `onPressed` to call `Get.bottomSheet` with the new `CreateTourPlanBottomSheet`.

## Verification Plan

### Automated Tests
- I will verify the code structure and basic syntax. (Flutter build/test commands are not directly available here, but I will ensure clean code).

### Manual Verification
- Open the "Monthly Journey Plan" screen.
- Click "Create Plan".
- Verify the bottom sheet opens smoothly.
- Switch between "Local" and "Outstation" tabs and check content updates.
- Verify date selection opens a picker.
- Check responsive layout on different screen sizes (simulated by code analysis).
