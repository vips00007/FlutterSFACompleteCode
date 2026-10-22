# Customer Create API Implementation Walkthrough

## Summary of Fixes for "Select classification is not allowed"

The backend error "Select classification is not allowed" usually means one of two things:

1. **Placeholder Selection:** Some backend reference data APIs return a dummy item (e.g., `name: "Select classification"`, `uuid: "0"`). If selected and sent, the backend rejects it because it's not a real classification ID.
2. **Invalid Customer Type Tree:** Attempting to submit classification fields (Sub Type, Channel, etc.) for a Customer Type (like "Mechanic") that doesn't allow or possess a classification tree.

### What Was Changed:
1. **Dropdown Placeholder Filtering:**
   Updated `_getSortedLookups` in `AddOutletViewModel` to proactively filter out any dummy items returned by the API. Any lookup item with an empty UUID, a UUID of `'0'`, or a name containing the word `'select'` is now removed from the dropdown list.
2. **Dynamic Validation for Classifications:**
   Updated `_validateCurrentStep()` so that classification dropdowns (Sub Type, Channel, Segment, Category, Class) are **only required if they actually contain options**. If a user selects a Customer Type that has no subtypes (meaning `subTypeList.isNotEmpty` is false), the frontend will no longer block them or force them to provide a dummy value.
3. **Empty Field Omission:**
   If the classification fields are not applicable and not selected, they are correctly bypassed and the `toJson()` builder strips them out entirely instead of sending empty strings to the backend.

### Next Steps:
If you try to submit again, the dropdowns will only show valid UUID items. If the backend still rejects the request, the enhanced error snackbar will display the exact raw response JSON so you can see if the backend is expecting the `customerType` to be a string code (e.g., `"RETAILER"`) instead of a UUID.