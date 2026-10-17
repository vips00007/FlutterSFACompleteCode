# Implement Remaining More Options Screens in Visit Details

This plan outlines the implementation of the remaining screens for the "More options" menu in the Visit Details screen, ensuring all options are fully functional and correspond to the provided reference images (and app theme).

## Proposed Changes

### Routes and Navigation
- Update `lib/routes/route_names.dart` to include 6 new routes:
  - `scheme_claims_view`
  - `display_photos_view`
  - `visit_note_view`
  - `target_view`
  - `next_beat_view`
  - `sync_queue_view`
- Update `lib/routes/routes.dart` to map these routes to the new screens.
- Update `lib/presentation/tickets/actions/visit_more_menu_screen.dart` to trigger `Get.toNamed()` for the remaining items.

### UI Screens
---
#### [NEW] `lib/presentation/tickets/actions/scheme_claims_screen.dart`
- Create a list of recent claims (e.g., "Q4 volume scheme", "Display support") with statuses like "Awaiting approval" and "Approved".
- Add a form section with a dropdown for Scheme selection, text field for Claim amount (₹), and a photo upload placeholder using the existing `DashedRectPainter`.
- Include a sticky bottom button for submitting the claim.

#### [NEW] `lib/presentation/tickets/actions/display_photos_screen.dart`
- Create a screen for capturing branding and stock display proof.
- Implement a selectable row of chips for "Photo type" (e.g., Branding, Stock display, Godown).
- Add a large dashed-border container for camera upload.
- Include a sticky bottom button for saving the photo.

#### [NEW] `lib/presentation/tickets/actions/visit_note_screen.dart`
- Since no explicit image was provided for "Visit note", design a simple, theme-consistent screen.
- Include a large multiline text field for writing notes and a sticky bottom button for saving the note.

#### [NEW] `lib/presentation/tickets/actions/target_screen.dart`
- Create a prominent purple top card with a circular progress indicator (86%), showing target vs achieved limits.
- Add summary cards for "Gap to close" and "Needed per day".
- Add a "By category" list showing progress bars for different product categories (Engine oil, Brake & friction, etc.) with specific colors.
- Include a "Focus to catch up" section with warning icons and action items.

#### [NEW] `lib/presentation/tickets/actions/next_beat_screen.dart`
- Create a scrollable list of remaining visits.
- Each visit item will display the distributor's name, address, an ID badge, time, distance, and an outlined "Navigate" button.
- Include a bottom warning container: "Finish this visit first, then check in at the next distributor."

#### [NEW] `lib/presentation/tickets/actions/sync_queue_screen.dart`
- Create a top card indicating network status (Online/Offline) with a toggle switch, and a count of items waiting to sync.
- Create a "QUEUE" section showing recent sync items with timestamps and "Synced" badges.

## Verification Plan
### Manual Verification
- Open the Visit Details screen and tap "More".
- Tap on "Scheme claims", "Display photo", "Visit note", "Target", "Next beat", and "Sync queue" sequentially.
- Verify that they open the correct screens without crashing.
- Verify that the layout on each new screen matches the provided reference images exactly.
- Check all interactive elements (chips, toggles, text fields) for correct functionality.