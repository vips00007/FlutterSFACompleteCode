# Implementation Plan - Customer Profile Screen

Implement a dedicated **Customer Profile** screen that displays comprehensive details about a customer (Outlet). This screen will be accessible from the "View Profile" button on the Customer Summary screen.

## User Review Required

> [!IMPORTANT]
> The "Location" information (Coordinates and Geofence Radius) is not currently present in the `Outlet` domain entity. I will use placeholder values as shown in the reference images (10.104624, 76.483031 and 200 m) unless provided otherwise.

## Proposed Changes

### Routes & Navigation

#### [MODIFY] [route_names.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/route_names.dart)
- Add `customer_profile_view` constant.

#### [MODIFY] [routes.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/routes.dart)
- Add `GetPage` entry for `customer_profile_view` mapping to `CustomerProfileScreen`.

#### [MODIFY] [customer_summary_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/tickets/customer_summary_screen.dart)
- Update `View Profile` button `onPressed` to navigate to `RoutesName.customer_profile_view` with the `outlet` argument.

### UI Components

#### [NEW] [customer_profile_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/tickets/customer_profile_screen.dart)
- Create the screen with the following sections based on the reference images:
    - **AppBar**: "Customer Profile" title, back arrow, and thin light-blue bottom border.
    - **Header Section**: A card containing a large circular "?" avatar and a "Retailer" status badge.
    - **Business Info Section**: A card with "Type" (Retailer).
    - **Contact Info Section**: A card with "Phone" and "Contact Person" (Combined first and last name).
    - **Address Section**: A card with "Address", "City", "State", and "Pincode".
    - **Location Section**: A card with "Coordinates" and "Geofence Radius".

## Verification Plan

### Manual Verification
- Navigate to the Customer Summary screen.
- Click on "View Profile".
- Verify that the Customer Profile screen opens correctly.
- Verify that the layout, icons, and colors match the provided images.
- Verify that the back button returns to the Customer Summary screen.
- Verify responsiveness on different screen sizes.
