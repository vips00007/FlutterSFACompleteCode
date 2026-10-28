# Image & Document Upload Implementations

Implemented the Image and Document Upload feature for the Create Customer workflow.

## Changes Made
- **API Client Update**: Added `uploadCustomerFile(String filePath, String kind)` method in `CustomerApiService`. This sends `multipart/form-data` with the file via the standard file upload endpoints and properly attaches the `kind` (`SHOP_IMAGE` or `DOCUMENT`) as a query parameter.
- **Payload Models**: Expanded `CustomerCreateRequest` to include `shopImageUuid` and `documentUuid` fields, allowing the backend to associate the created customer with these uploaded files.
- **View Model Modifications (`AddOutletViewModel`)**:
    - Replaced the simple `selectedFileName` tracking logic with distinct properties for the Shop Image (`shopImageUuid`, `shopImageFileName`, `shopImagePath`) and the Document (`documentUuid`, `selectedFileName`, `documentPath`).
    - Handled picking files (`FilePicker`), 5MB size validation, auto-uploading them via `uploadCustomerFile`, catching errors during upload, and resetting state when clearing the file.
- **UI & Layout Configuration (`ExploreScreen`)**:
    - Created an `_buildUploadsSection` inside the Details step that combines image uploads and document attachments.
    - Moved the "KYC Document" selector from the generic "KYC / Tax" block to the newly created Uploads section, rendering it as "Document Type" alongside the "Document File" picker.
    - Added an image preview widget inside `_buildFileUploadArea`. When a file is picked and successfully verified, its local path is passed to an `Image.file(...)` container for a visual preview.
