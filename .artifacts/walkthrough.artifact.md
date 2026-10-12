# Flutter SFA Dashboard UI Updates Walkthrough

## Summary of Changes
Implemented a cleaner and more compact Dashboard UI based on the requirements, completely removing the specified navigation tabs and resolving layout overflow errors that caused UI breakages on smaller screens. This was followed by a subsequent round of refinements for overflow errors and visual consistency across the dashboard. Most recently, the bottom navigation bar was optimized to accurately reflect functionality without a floating central plus button, ensuring clean navigation routing between screens.

### 1. Updated Bottom Navigation Structure
* **Removed the floating Plus (+) Action Button**: Deleted the standalone floating "Add" button from the `dashboard_screen.dart` bottom navigation container so the remaining core tabs can share the space evenly.
* **Renamed "Customers" to "Add Outlet"**: Updated the tab configuration block in `DashboardScreen`. Replaced the "Customers" string label with "Add Outlet" and replaced the underlying icon from the generic `Icons.people_outline` to `Icons.add_business_outlined` (and `Icons.add_business` for active state) to accurately reflect the destination form visually.
* **Corrected Screen/Tab Alignments**: Simplified the `_buildNavItem` logic, removing the intermediate mismatched routing hacks. The index mapping now directly binds:
  * `index: 1` -> **Add Outlet** (which correctly navigates to `AddOutletScreen()`).
  * `index: 2` -> **Visit** (which correctly navigates to `TicketsScreen()`, the designated Visit screen).

### 2. Unified Typography
* **Today's Target Header**: Modified the "Today's Target" title to use `FontWeight.w900`, directly matching the bold aesthetic of the "Today's Journey" title.
* Ensured the supporting labels in the Target section (like "ACHIEVED" and "TARGET") maintain a consistent layout strategy without overflow constraints, maintaining visual alignment and density with the Journey section metrics.

### 3. Restored Bottom Navigation Bar
* **DashboardScreen Restoration**: Fully restored the `bottomNavigationBar` UI component inside `DashboardScreen.dart` which had been stripped out in an earlier task.
* The custom curved bottom bar now re-integrates the `SafeArea` and the navigation tabs.
* Restored the `IndexedStack` body to appropriately switch between `HomeScreen`, `AddOutletScreen`, `TicketsScreen`, and `FavoritesScreen` based on the original tab indexes.

### 4. Expanded Today's Journey Map
* **IntrinsicHeight Implementation**: To guarantee the map fills the available vertical space defined by the left-side textual details, the internal `Row` in the Today's Journey card was wrapped inside an `IntrinsicHeight` widget.
* The row was given `crossAxisAlignment: CrossAxisAlignment.stretch`, which forces the map's `Expanded` container (which lost its arbitrary minimum-height constraints) to perfectly stretch from the top bounding box of the text section directly to the bottom bounding box without any weird margins or top/bottom padding gaps.

### Verification
* Ran `dart format lib` successfully, keeping all edited files within conventional styling.
* Code constraints structurally guarantee that the expanded map behaves responsively against its text neighbors.
* The original Bottom Navigation UI handles bottom device safe-areas organically via `SafeArea`, ensuring no overlap with Android OS navigation pills.