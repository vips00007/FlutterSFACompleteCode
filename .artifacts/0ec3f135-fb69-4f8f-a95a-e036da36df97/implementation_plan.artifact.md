# Debugging Plan - Attendance Server Error

Investigate and fix the "Unexpected Server Error" (500) occurring during Check-In/Check-Out.

## User Review Required

> [!IMPORTANT]
> - I will add **detailed logging** to `AttendanceApiService` to inspect the full request/response cycle.
> - I will revert the `selfie` encoding to **raw Base64** (removing the `data:image/jpeg;base64,` prefix) to test if the backend expects a clean string.
> - I will use the standard `DateTime.now().toUtc().toIso8601String()` for the `capturedAt` field.

## Proposed Changes

### Data Layer
#### [MODIFY] [attendance_api_service.dart](file:///E:/FlutterPracticeSrLevel/lib/data/datasource/remote/attendance_api_service.dart)
- Add logging for:
    - URL
    - Masked Authorization header
    - Request Body (length and sample)
    - Response Status Code
    - Response Body
- Improve error parsing to ensure the server's `message` or `code` is preserved in the thrown `Exception`.

### Presentation Layer
#### [MODIFY] [home_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/home_viewmodel.dart)
- Revert `selfie` to plain Base64 string.
- Simplify `capturedAt` generation to `DateTime.now().toUtc().toIso8601String()`.
- Ensure `latitude`, `longitude`, and `accuracyMeters` are correctly formatted.

## Verification Plan

### Manual Verification
1. **Log Analysis**: Inspect console logs during attendance marking to identify the specific field or format causing the server error.
2. **Success Case**: Verify that the changes resolve the 500 error and attendance is marked successfully.
3. **Error Handling**: Verify that if an error occurs, the snackbar shows the specific message returned by the backend instead of a generic "Unexpected Server Error".
