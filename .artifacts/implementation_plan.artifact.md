# Redesign Favorites Screen with Purple Theme

This plan updates the `favorites_screen.dart` to match the Dashboard's purple theme, specifically aligning with the gradient and styling seen on the `HomeScreen`.

## Proposed Changes

### 1. `E:/FlutterPracticeSrLevel/lib/presentation/favorites/favorites_screen.dart`

- **Header Gradient**: Replace the solid `AppColors.sfaBlue` in `_buildHeader` with a linear gradient using `[Color(0xFF6D28D9), Color(0xFF8A2BE2), Color(0xFFB197FC)]` to match the `HomeScreen` header.
- **Navigation/Back Arrow**: Introduce a back arrow container in the top-left corner of the header. It will be styled with a translucent white background (`Colors.white.withOpacity(0.2)`) and rounded corners to look visually appealing and consistent with the gradient header.
- **Icon Backgrounds**: Update `_buildMenuItem` calls. Change `AppColors.sfaLightBlue` to a light purple (`Color(0xFFF3E8FF)`) and `AppColors.sfaBlue` to a deep purple (`Color(0xFF8A2BE2)`).
- **Stats Card**: Change `AppColors.sfaBlue` used in the "Orders MTD" stat to the new purple theme color.
- **Menu Section Titles**: Change the text color of section titles (e.g., 'ATTENDANCE & LEAVE') from `AppColors.sfaBlue` to `Color(0xFF6D28D9)`.
- **Logout Button**: Update the outline and text color of the logout button to use the new purple theme color instead of `AppColors.sfaBlue`.

## Verification Plan

### Automated Tests
- N/A (UI Changes only)

### Manual Verification
- Navigate to the Favorites screen.
- Verify the header features the new purple gradient.
- Ensure the newly added navigation arrow is styled correctly with a rounded background.
- Check that all list items (icons and section titles) have matching purple accents.
- Ensure text contrast is maintained and the UI remains responsive without overflow.