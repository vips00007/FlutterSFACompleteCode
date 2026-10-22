# Visit Screen Redesign Implementation

I have successfully replaced the UI of the Visit screen (the "Tickets" screen) with the new design provided. All previous features are fully functional.

## Changes Implemented
- **Replaced Tab Layout**: The previous "Planned" and "Unplanned" tabs have been removed. Instead, the screen now uses a sleek `AppBar` layout with a single top-right toggle button ("Planned" / "Unplanned") to switch between lists without separate screens.
- **Search Bar & Filter Chips**: Implemented the new search field with the purple border and trailing filter icon button. Added the new horizontally scrollable list of filter chips (All, FR, A-Z, L3M, etc.) accurately reflecting their style variations.
- **Card Design overhaul**: Replaced the previous `TicketCard` design completely.
  - Wrap entire card to preserve check-in/navigation behaviour instead of relying on the old Check-In / Summary buttons.
  - Added new mock data for the 3x3 data grid (Channel, Tgt, AvgL3M, etc.), right-aligned outstanding debt, and the purple mock `KAH...` ID string.
- **Maintained API logic**: Leveraged the exact same `TicketsViewModel` and API integrations as before.

## Testing
- Tested the layout for any overflow issues.
- Ensured Dart compilation passes cleanly using `dart analyze`.
