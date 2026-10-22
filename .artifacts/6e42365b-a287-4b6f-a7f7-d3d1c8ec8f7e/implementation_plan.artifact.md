# Replace Visit Screen with New Design

This plan replaces the existing `TicketsScreen` (the Visit tab) and `TicketCard` components with the new design, replacing the Planned/Unplanned tabs while maintaining all business logic and navigation.

## Proposed Changes

### [MODIFY] TicketsScreen (lib/presentation/tickets/tickets_screen.dart)
- Replace the app bar with the new layout (`<` back button, bold "Visits" title, and a top-right "Planned" toggle button).
- Use the view model's `selectedTabIndex` state to toggle the top-right button text between "Planned" and "Unplanned", allowing users to switch lists without tabs.
- Add the new search text field with its trailing filter button.
- Add the horizontally scrollable filter chips (All, FR, A-Z, L3M, MTD, BL, UN, IN).
- Add the "Business Partner" and date list header.
- Keep the `ListView.builder` the same to preserve the click/bottom sheet logic.

### [MODIFY] TicketCard (lib/presentation/tickets/widgets/ticket_card.dart)
- Remove the old Check-In and View Summary bottom action row.
- Wrap the entire card in a `GestureDetector` that triggers `onCheckIn` or navigation.
- Update the card layout to match the provided image:
  - Top row: Purple building icon, name, location, purple mock ID.
  - Top right: Outstanding amount and "Last order 12d" text.
  - Middle: A 3x3 grid showing mock statistics (Channel, Tgt, AvgL3M, etc.).
  - Bottom: Three small icons (outline circle, green location pin, red circle).

## Verification Plan
- Launch the app and navigate to the Visit screen.
- Verify the new UI is rendered without overflows.
- Tap the "Planned" button in the app bar to verify it switches to "Unplanned" and updates the list.
- Tap on a card to ensure the existing Check-In/Bottom Sheet flow is preserved.
