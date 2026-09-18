# Implementation Plan - Meeting or Exhibition Module

Implement the "Event Planner" and "Create Event" screens for the "Meeting or Exhibition" module, ensuring direct navigation and UI fidelity to the provided reference images.

## User Review Required

> [!IMPORTANT]
> The navigation will be direct: **Side Menu -> Event Planner -> Create Event**.
> I will ensure no Splash Screen or intermediate redirects are triggered during this flow.

## Proposed Changes

### Routing

#### [MODIFY] [route_names.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/route_names.dart)
- Add `static const String event_planner_view = '/event_planner_view';`
- Add `static const String create_event_view = '/create_event_view';`

#### [MODIFY] [routes.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/routes.dart)
- Register `EventPlannerScreen` and `CreateEventScreen` with their respective ViewModels.

### Menu Integration

#### [MODIFY] [favorites_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/favorites/favorites_screen.dart)
- Link "Meeting or Exhibition" menu item to `RoutesName.event_planner_view`.

### Presentation Layer

#### [NEW] [event_planner_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/events/event_planner_viewmodel.dart)
- Manage tabs ("All", "Today", "Upcoming", "Approved").
- Handle event list state (initially empty).

#### [NEW] [event_planner_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/events/event_planner_screen.dart)
- Implement UI for Event Planner.
- App bar with "+ Create Event" button.
- Horizontal scrollable filter tabs.
- Empty state with "No events" message and calendar-X icon.

#### [NEW] [create_event_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/events/create_event_viewmodel.dart)
- Handle form state (date, type, partner, venue, remarks, invitees, budget, switch).
- Logic for date picker and form validation.

#### [NEW] [create_event_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/events/create_event_screen.dart)
- Implement UI for Create Event form.
- Input fields matching the reference image.
- Microphone icon for remarks.
- Switch for "Shared with partner".
- Photo picker placeholder.

## Verification Plan

### Automated Tests
- N/A (UI focus)

### Manual Verification
1. Open the app and go to the side menu (Favorites).
2. Click **Meeting or Exhibition**.
3. Verify it navigates directly to the **Event Planner** screen (no Splash Screen).
4. Verify the UI (tabs, "+ Create Event" button, empty state).
5. Click **+ Create Event**.
6. Verify it navigates to the **Create Event** screen.
7. Verify the form fields, icons, and styling match the image.
8. Test form interactions (date picker, switch).
9. Verify back navigation returns to the expected screen without reloading the Splash Screen.
