# Implement SHOP_IMAGE Upload API in Add Outlet

This plan outlines the integration of the `SHOP_IMAGE` upload functionality in the Add Outlet screen.

## Proposed Changes

### Data Layer (`lib/data/datasource/remote/customer_api_service.dart`)
- Add a new method `uploadFile(String filePath, String kind)` using `http.MultipartRequest` targeting the `POST {{baseUrl}}/api/v1/sfa/customers/files?kind=$kind` endpoint.
- It will parse the JSON response and return the `data.fileRef`.

### Data Models (`lib/data/models/customer_create_request.dart`)
- Create a `CustomerFile` class (or similar map representation) to pass the `fileRef` and `kind`.
- Add a `List<CustomerFile>? files` field to `CustomerCreateRequest` so the `fileRef` can be included when creating the customer.

### Presentation Layer (`lib/presentation/explore/add_outlet_viewmodel.dart`)
- Add reactive state variables for the image upload: `final shopImageFileRef = RxnString();` and `final isUploadingImage = false.obs;`.
- Update the `pickFile` method or add a new wrapper method `pickShopImage` specifically for the shop image.
- When an image is picked, automatically trigger `_apiService.uploadFile(path, 'SHOP_IMAGE')`.
- Handle loading state, success, and error scenarios.
- Include the uploaded `shopImageFileRef` in the `CustomerCreateRequest` object during the `submitForm()` method.

### UI Layer (`lib/presentation/explore/explore_screen.dart`)
- Update `_buildAvatar` widget to display a loading indicator (`CircularProgressIndicator`) over the avatar when `viewModel.isUploadingImage.value` is true.
- Disable tap on the image while uploading.
- Ensure the UI remains responsive and follows existing styling.

## Open Questions

> [!IMPORTANT]
> How should the `fileRef` be represented in the final `CustomerCreateRequest` JSON payload?
> Should it be a list like `"files": [{"fileRef": "...", "kind": "SHOP_IMAGE"}]` or a specific field like `"shopImageFileRef": "..."`? I have planned to add a `files` list containing objects with `fileRef` and `kind`.

## Verification Plan

### Manual Verification
- Launch the Add Outlet screen.
- Tap the header image, select an image from the gallery.
- Verify that the image uploads (loading spinner is visible).
- On success, check the logs that `fileRef` is obtained.
- Navigate through steps and submit the form, ensuring the `fileRef` is passed in the final payload.
