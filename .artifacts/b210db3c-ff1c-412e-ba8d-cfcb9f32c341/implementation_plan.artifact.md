# Implementation Plan - Geography API Integration

Integrate the `/customers/geography` API to populate dynamic dropdowns for State, City, and Territory in the Add Outlet screen, complete with parent-child filtering logic.

## Proposed Changes

### Data Layer

#### [NEW] `geography_response.dart`(file:///E:/FlutterPracticeSrLevel/lib/data/models/geography_response.dart)
Create model classes to map the JSON response, capturing `uuid`, `type`, `code`, `name`, and `parentUuid`.

#### [MODIFY] `customer_api_service.dart`(file:///E:/FlutterPracticeSrLevel/lib/data/datasource/remote/customer_api_service.dart)
Add a `getGeographyData()` method to fetch data from `{{baseUrl}}/api/v1/sfa/customers/geography`.
- Uses `SharedPrefsManager` for the Bearer token.
- Uses the local `_generateUuidV4()` method for the `X-Correlation-ID` header.

### Presentation Layer

#### [MODIFY] `add_outlet_viewmodel.dart`(file:///E:/FlutterPracticeSrLevel/lib/presentation/explore/add_outlet_viewmodel.dart)
- Call `CustomerApiService.getGeographyData()` during `onInit()` alongside `fetchCustomerReferenceData()`.
- Add reactive state variables for Geography tracking:
  - `isLoadingGeography` (bool), `geographyError` (String), `allGeographies` (List).
  - Selected states: `selectedStateUuid`, `selectedCityUuid`, `selectedTerritoryUuid`.
- Add computed lists (`stateList`, `cityList`, `territoryList`) to filter `allGeographies` by `type` and their respective `parentUuid` hierarchies.
- Implement selection methods (`onStateSelected`, `onCitySelected`, `onTerritorySelected`) that reset downstream dropdowns appropriately when a parent's value changes.

#### [MODIFY] `explore_screen.dart`(file:///E:/FlutterPracticeSrLevel/lib/presentation/explore/explore_screen.dart)
- Overhaul `_buildAddressSection()` to remove the hardcoded pincode-based UI.
- Implement a custom `_buildGeographyDropdown` (or modify `_buildDropdown` to accept custom items like `<String, String>`) to allow using UUID as the internal value while displaying the localized name.
- Insert the State, City, and Territory dropdowns in the layout.
- Wrap the Geography section in an `Obx` that displays a `CircularProgressIndicator` while loading, or a friendly error state if it fails.
- Pass appropriate state properties to disable City if State is null, and Territory if City is null.

## Verification Plan

### Automated Tests
- Run `dart analyze` to ensure syntax is valid and all imports are correct.

### Manual Verification
- Launch the application and navigate to Add Outlet -> Create Customer.
- Confirm that the State dropdown displays data retrieved from the API (`type == "STATE"`).
- Select a State and verify that the City dropdown becomes enabled and populates with records mapping to that state's `uuid`.
- Select a City and verify that the Territory dropdown populates with records mapping to the city's `uuid`.
- Change the selected State and ensure City and Territory are reset and disabled accordingly.
- Test scenarios with slow or offline connections to observe loading and error UI states without screen disruption.
