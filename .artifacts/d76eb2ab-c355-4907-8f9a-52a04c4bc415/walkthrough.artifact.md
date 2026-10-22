# Add Outlet Classification Dropdowns Update

## Summary

The "Add Outlet" functionality has been successfully updated to display and correctly cascade reference data using the already existing `{{baseUrl}}/api/v1/sfa/customers/reference-data` API response.

Previously, dropdowns in the Classification step (Sub Type, Channel, Segment, Category, Class, Beat Area) were displaying static, hardcoded values. We updated the API data model to parse the `lookups` and `beats` arrays sent by the backend, mapped these lists into the state-management logic, and created dynamic cascading dropdowns on the UI that preserve the original visual styling.

As an extension to the first phase, `MONTHLY_POTENTIAL`, `SHOP_SIZE`, `BUSINESS_TYPE`, and `KYC_DOCUMENT_TYPE` lookups have also been added to the relevant sections following the exact same dynamic cascading pattern. We discovered that these properties do not always have a strict `customerTypeUuid` association sent by the backend, so their frontend filters have been relaxed to display strictly based on their `lookupType`.

## Changes Made

### 1. Extracted `lookups` and `beats` from API response
- **[MODIFY] [customer_reference_data_response.dart](file:///E:/FlutterPracticeSrLevel/lib/data/models/customer_reference_data_response.dart)**
  - Added `LookupItem` to parse classification attributes (`uuid`, `name`, `lookupType`, and relational UUIDs like `subTypeUuid`).
  - Added `BeatItem` to parse beat information (`uuid`, `name`).
  - Extended the existing `CustomerReferenceData` model to collect and hold `lookups` and `beats` sent by the API.

### 2. State Management for Cascading Dropdowns
- **[MODIFY] [add_outlet_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/explore/add_outlet_viewmodel.dart)**
  - Refactored dropdown variables to use nullable `RxnString()` properties (e.g., `selectedSubTypeUuid`, `selectedChannelUuid`).
  - Added specific state holders for `selectedShopSizeUuid`, `selectedMonthlyPotentialUuid`, `selectedBusinessTypeUuid`, and `selectedKycDocTypeUuid`.
  - Created getters (`subTypeList`, `channelList`, `shopSizeList`, `monthlyPotentialList`, `businessTypeList`, `kycDocTypeList` etc.) that dynamically filter the active lookups based on the selected parent's UUID and sort them using `displayOrder`.
  - Removed strict `customerTypeUuid` filtering on non-dependent lookups to ensure they populate even if the backend returns null for that relation.
  - Added cascading `null` assignment. For instance, when a Sub Type is selected or changed, `onSubTypeSelected` clears the selected `channelUuid`, which cascades down the hierarchy.
  - Added robust validation in `_validateCurrentStep()` using the newly selected `.value`.

### 3. Updated "Add Outlet" UI
- **[MODIFY] [explore_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/explore/explore_screen.dart)**
  - Swapped out hardcoded arrays (e.g. `['Premium', 'Standard', 'Economy']`, `['Small (<200 sq ft)', 'Medium', 'Large']`, `['Proprietorship', 'Partnership', 'Pvt. Ltd.']`, `['Aadhaar', 'Voter ID', 'Driving Licence']`) for API-driven logic.
  - Implemented `_buildLookupDropdown`, a reusable dynamic widget that maps backend objects, displays the string `name` to the user, and securely handles the `uuid` as the selected form value.
  - Replaced the hardcoded options for Shop Size, Monthly Potential, Business Type, and KYC Document Type with `_buildLookupDropdown` in the "Retailer Details", "Business Information", and "KYC/Tax" sections respectively.
  - Mapped dropdown "isEnabled" states explicitly. Dropdowns gracefully disable themselves if their respective parent selection hasn't been made yet.
  - Updated the "Review/Summary" pages correctly rendering the selected labels by resolving UUIDs back to their descriptive text.

## Verification
- Code successfully builds.
- Cascading lookup arrays react predictably when the parent hierarchy (Retailer vs. Mechanic vs. Business) is flipped in Step 1.
- General and Retailer specific dynamic arrays (`SHOP_SIZE`, `MONTHLY_POTENTIAL`, `BUSINESS_TYPE`, and `KYC_DOCUMENT_TYPE`) are properly fetched, sorted and displayed.
- Form continues to handle user selections with UUID references ensuring form submission will succeed with API requirements intact.