# Walkthrough - Customer Profile Screen

I have implemented the **Customer Profile** screen and integrated it into the application's navigation flow.

## Changes Made

### Navigation & Routing
- **[route_names.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/route_names.dart)**: Added `customer_profile_view` route constant.
- **[routes.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/routes.dart)**: Registered `CustomerProfileScreen` with the `GetPage` router.
- **[customer_summary_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/tickets/customer_summary_screen.dart)**: Updated the "View Profile" button to navigate to the new screen, passing the `outlet` object as an argument.

### UI Implementation
- **[customer_profile_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/tickets/customer_profile_screen.dart)**: Created a new responsive screen that matches the reference design.
    - **AppBar**: Styled with a blue accent line at the bottom.
    - **Header Card**: Features a large profile placeholder and a type badge (e.g., Retailer).
    - **Business Info**: Displays the customer category.
    - **Contact Info**: Lists the phone number and the primary contact person.
    - **Address Details**: Shows the full address, city, state, and pincode.
    - **Location**: Includes coordinates and geofence radius placeholders as per the requirement.

## Verification Results

### UI Consistency
- Used `AppColors.textPrimary` and `AppColors.sfaBlue` for consistency with the design system.
- Applied consistent card styling with rounded corners (16px) and subtle shadows.
- Used light blue icons and badges to match the reference image's color palette.

### Navigation Flow
- **Customer Summary** → **View Profile** → **Customer Profile**.
- Back button correctly returns to the Customer Summary screen.
- Data from the `Outlet` entity is correctly passed and displayed.

> [!NOTE]
> Coordinates and Geofence Radius currently use placeholder values (`10.104624, 76.483031` and `200 m`) as this data is not present in the current `Outlet` entity.
