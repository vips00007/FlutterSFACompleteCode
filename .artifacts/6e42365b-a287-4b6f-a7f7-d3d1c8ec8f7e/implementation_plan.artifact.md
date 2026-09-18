# Implementation Plan - Tickets Screen UI Optimization

Optimize the `TicketsScreen` and `TicketCard` layouts to be more compact, efficient, and visually similar to the professional high-density reference design.

## Proposed Changes

### [Component] Tickets Screen UI (`tickets_screen.dart`)
#### [MODIFY] [tickets_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/tickets/tickets_screen.dart)
- **AppBar**:
    - Reduce `horizontal` padding in the title `Row`.
    - Adjust `Create Plan` button height and padding.
- **Tabs Section**:
    - Reduce outer padding from `12.0` to `EdgeInsets.symmetric(horizontal: 16, vertical: 10)`.
    - Reduce internal tab vertical padding from `12` to `8`.
    - Reduce spacing between title and subtitle in `_buildTab`.
    - Use smaller font sizes: Title (`14-15`), Subtitle (`10`).
- **Search Bar**:
    - Reduce top padding from `20.0` (implied or existing) to `8.0`.
    - Keep height at `48-50`.
- **Status Text**:
    - Reduce top spacing from `16` to `10`.
- **Warning Banner**:
    - Reduce margins from `20` to `16`.
    - Compact internal padding and icon sizes.

---

### [Component] Ticket Card Widget (`ticket_card.dart`)
#### [MODIFY] [ticket_card.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/tickets/widgets/ticket_card.dart)
- **Margins & Padding**:
    - Reduce `margin` from `symmetric(horizontal: 16, vertical: 8)` to `EdgeInsets.symmetric(horizontal: 16, vertical: 6)`.
    - Reduce `padding` from `16` to `12`.
- **Internal Spacing**:
    - Reduce gaps between text rows from `8` to `4`.
    - Reduce spacing before the button row from `16` to `10`.
- **Typography & Icons**:
    - Slightly reduce font sizes for mobile density.
    - Match icon sizing to the compact look.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no linting errors or warnings.

### Manual Verification
- Verify that more ticket cards are visible on the screen without scrolling.
- Ensure all elements (Planned/Unplanned counts, search bar, buttons) are fully accessible.
- Confirm that back navigation and tab switching functionality remains 100% intact.
- Verify no RenderFlex overflow occurs on standard mobile screen sizes.
