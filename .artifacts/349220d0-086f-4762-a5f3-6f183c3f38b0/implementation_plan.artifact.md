# Implementation Plan - Create Travel Plan Styling Refinement

Update the "Create Travel Plan" screen to have a consistent blue background across the tab and content areas, with white text for better contrast and matching the reference design.

## User Review Required

> [!IMPORTANT]
> - The blue background will be applied to the entire interactive section (tabs + content).
> - Text colors will be updated to white for visibility.
> - Goal cards will remain white but their borders and shadows will be adjusted to pop against the blue background.

## Proposed Changes

### `lib/presentation/tickets/create_plan_screen.dart`

#### 1. Tab Toggle Styling
- Change the background of the toggle container from light grey (`0xFFF1F5F9`) to brand blue (`AppColors.sfaBlue`).
- Update `_buildToggleItem` to use white text and icons.
- Adjust the "Selected" state indicator (white box) to have a subtle shadow and keep the blue text inside for contrast.

#### 2. Content Area Styling
- Wrap the `Obx` content in a `Container` with `AppColors.sfaBlue` background.
- Ensure the background stretches to the full width and covers all gaps.
- Update headings ("Pick a goal", "How can AI help?", "Build your plan manually") to white.
- Update descriptive secondary text to a lighter white/grey (`Colors.white70`).

#### 3. Component Tweaks
- Ensure the "Smart Pick" card (which is already blue gradient) has a distinct border or shadow to separate it from the new blue background.
- Keep goal cards white but refine their `BoxShadow` and `BorderSide` for high-contrast on blue.

## Verification Plan

### Manual Verification
- [ ] Verify that the blue background covers the entire tab and content area.
- [ ] Verify that all text is clearly readable (white on blue).
- [ ] Verify that there are no white/grey gaps between sections.
- [ ] Check the Manual Select tab for consistent blue styling.
