# Walkthrough: Add SHOP_IMAGE Upload to Add Outlet

## What was changed

1. **`CustomerApiService` (`lib/data/datasource/remote/customer_api_service.dart`)**
   - Added a new `uploadFile` method to handle `multipart/form-data` uploads.
   - It targets the `/api/v1/sfa/customers/files?kind=$kind` endpoint and extracts the `fileRef` from the JSON response on a successful upload.

2. **`CustomerCreateRequest` (`lib/data/models/customer_create_request.dart`)**
   - Created a new model class `CustomerFile` with `fileRef` and `documentType`.
   - Added a `List<CustomerFile>? files` field to the `CustomerCreateRequest` so that uploaded file references can be sent along with the customer creation payload.

3. **`AddOutletViewModel` (`lib/presentation/explore/add_outlet_viewmodel.dart`)**
   - Added `shopImageFileRef` and `isUploadingImage` reactive state variables.
   - Updated the `pickFile` method to accept an optional `kind` parameter. If provided, it triggers the upload automatically right after the file is picked.
   - Handled successful and failed upload scenarios (setting errors or showing success snackbars).
   - In `submitForm()`, it checks if `shopImageFileRef` is not null and populates the `files` array of `CustomerCreateRequest` with `documentType: 'SHOP_IMAGE'`.
   - Added a validation rule in `validateStep(0)` to prevent the user from continuing if the shop image is still uploading or has failed to upload (requiring a retry).

4. **`ExploreScreen` (`lib/presentation/explore/explore_screen.dart`)**
   - Updated `_buildAvatar` to display a `CircularProgressIndicator` while `isUploadingImage` is true.
   - Disabled the tap action on the avatar while an upload is currently in progress.

## Validation Results
- Tapping the avatar prompts the user to select an image.
- Selecting an image immediately displays a loading indicator over the avatar and uploads it.
- Once uploaded, `fileRef` is securely retained in the form state.
- Submitting the form uses the obtained `fileRef` inside the `files` array of the JSON payload.
