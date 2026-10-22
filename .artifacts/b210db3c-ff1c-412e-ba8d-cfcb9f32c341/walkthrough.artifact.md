# Walkthrough - Geography API Integration

I have successfully integrated the `/customers/geography` API and established the parent-child dependent UI dropdown logic for State, City, and Territory.

### Changes Made

1. **[NEW] `geography_response.dart`](file:///E:/FlutterPracticeSrLevel/lib/data/models/geography_response.dart):**
   - Created the core Geography models required for parsing `uuid`, `type`, `code`, `name`, and `parentUuid` from the endpoint response.

2. **[MODIFY] `customer_api_service.dart`](file:///E:/FlutterPracticeSrLevel/lib/data/datasource/remote/customer_api_service.dart):**
   - Added `getGeographyData()` endpoint call logic.
   - Cleanly shared `_generateUuidV4()` and Bearer tokens for standard consistency across network requests.

3. **[MODIFY] `add_outlet_viewmodel.dart`](file:///E:/FlutterPracticeSrLevel/lib/presentation/explore/add_outlet_viewmodel.dart):**
   - Stripped out the placeholder mapping logic running behind `_onPinCodeChanged()`.
   - Wired in `fetchGeographyData()` on init alongside existing API calls.
   - Designed computed getters (`stateList`, `cityList`, `territoryList`) to effortlessly evaluate and re-render only the lists relative to their selected parent components via internal filtering of `type` and `parentUuid`.
   - Setup `onStateSelected`, `onCitySelected`, and `onTerritorySelected` functions to enforce the resetting of downstream child components naturally when upstream changes occur.

4. **[MODIFY] `explore_screen.dart`](file:///E:/FlutterPracticeSrLevel/lib/presentation/explore/explore_screen.dart):**
   - Cleanly discarded the `_buildGeoValue` UI block.
   - Constructed a modern, specialized `_buildGeographyDropdown()` component to display properly styled dropdown buttons that internally track `uuid` while visually exposing standard geography `name` definitions.
   - Integrated logic to display "Select parent first" when `City` or `Territory` is logically blockaded by an unselected precursor.
   - Encircled the section in an `Obx` builder implementing localized Loading spinners and an Error fallback explicitly protecting the Address component from catastrophic failure in bad network environments.

### Validation Results
- Verified using `dart analyze` to ensure code is clean, models are wired correctly, and no missing variables are accessed.
- Verified filtering structure: `City` requires a `State`, `Territory` requires a `City`. Selecting new options propagates resets correctly down the tree.