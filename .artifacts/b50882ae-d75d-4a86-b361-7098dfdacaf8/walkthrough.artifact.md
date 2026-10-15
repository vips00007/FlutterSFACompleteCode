# Dynamic Tabs & Add Order Screen Integration

The UI integration for the Visit Details dynamic tabs and Add Order screen has been completed successfully.

## Changes Made

### 1. Dynamic Tabs in `visit_details_screen.dart`
- **State Management**: Refactored `VisitDetailsScreen` from a `StatelessWidget` to a `StatefulWidget` to maintain the selected tab index and invoice selection state internally.
- **Tab Layout**:
  - `Summary Tab`: Retained existing functionality and layout.
  - `Orders Tab`: Implemented a summary banner showing total order value, filter chips (All, Awaiting, In transit, Delivered), and a responsive list of previously placed orders (ORD-2241, etc.).
  - `Invoices Tab`: Implemented summary blocks for Outstanding/Paid invoices and a selectable list of invoices displaying correct visual statuses (Overdue, Due, Paid).
  - `Focus Tab`: Implemented a circular progress indicator matching the 74% target and a 2x2 grid representing target progress for individual products (Engine oil, Brake pad set, etc.).
- **Dynamic AppBar & Bottom Actions**:
  - The `AppBar` subtitle intelligently updates based on the active tab (e.g., "Select invoices and record receipt").
  - The sticky bottom bar updates from 5 Quick Actions (on Summary) to specific contextual actions ("Add Order" on Orders, "Record receipt" on Invoices, and hidden on Focus).

### 2. Add Order Interface in `order_screen.dart`
- **UI Rewrite**: Completely replaced the "Placeholder" text with a functional screen.
- **Stateful Quantities**: Implemented local state tracking `OrderItem` models with quantities.
- **Quantity Controls**: Created functional `-` and `+` buttons bounding values to zero minimum.
- **Dynamic Bottom Bar**: The sticky bottom action bar calculates and live-updates the `products selected` count and the `total cases` based on the user's input, enabling the "Place Order" button only when a quantity is > 0.

## Validation Results
- Code formatting and UI components strictly follow the provided screenshots and color palettes.
- Routing via `Get.toNamed(RoutesName.order_view)` continues to work robustly without duplicating API requests.
- No existing functionality within the Summary tab was altered or lost.

You can view these changes live by running the app, tapping "Check-In" on a ticket, and navigating the new tabs.