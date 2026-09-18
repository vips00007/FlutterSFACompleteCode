# Walkthrough - Create Tour Plan Bottom Sheet Implementation

I have implemented the "Create Tour Plan" bottom sheet exactly as per the provided reference images.

## Changes

### UI Components
- **[CreateTourPlanBottomSheet](file:///E:/FlutterPracticeSrLevel/lib/presentation/tickets/create_tour_plan_bottom_sheet.dart)**:
    - Features a smooth modal bottom sheet with rounded top corners (24dp).
    - Includes a custom tab switcher for **Local** and **Outstation** plans.
    - Responsive layout with date range inputs, travel purpose text field, and city selector for outstation plans.
    - Styling matches the reference image: colors, typography, icons, and spacing.
    - Fully enabled and clickable tabs that update content dynamically.

### State Management
- **[CreateTourPlanViewModel](file:///E:/FlutterPracticeSrLevel/lib/presentation/tickets/create_tour_plan_viewmodel.dart)**:
    - Manages tab state, date selection, and form inputs using GetX.
    - Includes a custom date formatter to match the `dd MMM yyyy` format without external dependencies.
    - Handles tab switching logic and form submission (mocked with success snackbar).

### Integration
- **[MonthlyJourneyPlanScreen](file:///E:/FlutterPracticeSrLevel/lib/presentation/tickets/monthly_journey_plan_screen.dart)**:
    - Updated the "Create Plan" button to trigger the bottom sheet.
    - Properly initializes the ViewModel when opening the sheet.

## Verification Results

- **Smooth Opening**: Verified that `Get.bottomSheet` is used with `isScrollControlled: true` for a smooth bottom-to-top animation.
- **Tab Functionality**: Verified both tabs are enabled. Switching to "Outstation" reveals the "Places to Visit" section.
- **Responsiveness**: Used `SingleChildScrollView` to ensure the sheet handles smaller screens or keyboard opening gracefully.
- **Design Accuracy**:
    - Colors: Used `AppColors.sfaBlue` for active states.
    - Icons: Integrated `Icons.calendar_today_outlined` and `Icons.keyboard_arrow_down`.
    - Corners: Applied correct `BorderRadius` to tabs (10dp), inputs (12dp), and the sheet itself (24dp).

> [!TIP]
> The bottom sheet can be further extended to include actual city selection logic in the `CreateTourPlanViewModel`.
