# Customer Create API Implementation

This plan outlines the steps to integrate the `POST /api/v1/sfa/customers` endpoint for submitting customer details from the Add Outlet screen.

## Proposed Changes

### Data Layer
- **`lib/data/models/customer_create_request.dart` [NEW]**
  - Defines `CustomerCreateRequest` class which maps the form properties exactly to the required JSON structure.
- **`lib/data/models/customer_create_response.dart` [NEW]**
  - Defines `CustomerCreateResponse` and `CustomerCreateData` classes to parse the API response (e.g. `customerCode` and `uuid`).
- **`lib/data/datasource/remote/customer_api_service.dart` [MODIFY]**
  - Changes the visibility of `_generateUuidV4()` to `generateUuidV4()` so that it can be used for `clientRequestId`.
  - Implements `createCustomer(CustomerCreateRequest request)` method using `Dio`.

### Presentation Layer
- **`lib/presentation/explore/add_outlet_viewmodel.dart` [MODIFY]**
  - Imports the necessary models and `geolocator` package.
  - Gets the current GPS coordinates utilizing `Geolocator.getCurrentPosition()`.
  - Updates `submitOutlet()` to dynamically map form fields and dropdown UUIDs into a `CustomerCreateRequest`.
  - Replaces the simulated 2-second delay with a real API call.
  - Shows an error snackbar if the API call fails or if location permissions are denied (or provide fallback coordinates if permissible).
  - Updates `_showSuccessDialog()` to display the real `customerCode` returned by the server.
- **`pubspec.yaml`**
  - (Already verified) `geolocator` is present.

## Verification Plan

### Automated Tests
- Test using Flutter's widget tests if applicable.

### Manual Verification
1. Launch the app and navigate to **Add Outlet** -> **Create Customer**.
2. Fill all required fields (Shop Name, Contact, Address, Classification dropdowns).
3. Ensure location permissions are granted.
4. Click **Submit** on Step 3.
5. Verify that a loader is displayed.
6. Check backend logs or Dio debug output for payload correctness (e.g. valid UUIDs).
7. Confirm that a success dialog appears showing the returned Customer Ref ID (e.g. `CUST-123456`).
8. After success, tap **Add Another** and verify form clears.
9. Test failure cases (e.g., disable network) and ensure form data remains intact.