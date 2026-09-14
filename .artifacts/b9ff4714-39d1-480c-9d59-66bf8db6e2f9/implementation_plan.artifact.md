# Implementation Plan - Resolve Persistent 500 INTERNAL_ERROR

The goal is to resolve the `500 INTERNAL_ERROR` by making the `AttendanceRequest` payload more robust and compliant with common backend expectations for image-based APIs.

## User Review Required

> [!IMPORTANT]
> - I will add the **Data URI prefix** (`data:image/jpeg;base64,`) to the selfie string.
> - I will add **field aliases** in the JSON payload (`accuracy` and `locationCapturedAt`) to ensure compatibility with potential backend naming variations.
> - I will **simplify the timestamp format** to exclude milliseconds, as some backends are sensitive to precision.

## Proposed Changes

### [Component] Data Models

#### [MODIFY] [attendance_request.dart](file:///E:/FlutterPracticeSrLevel/lib/data/models/attendance_request.dart)
- Update `toJson` to include both original and alias field names:
    - `accuracy` (aliasing `accuracyMeters`)
    - `locationCapturedAt` (aliasing `capturedAt`)
- This "double-naming" approach helps if the backend expects one over the other without causing a breaking change for the current model.

### [Component] Business Logic (ViewModel)

#### [MODIFY] [home_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/home_viewmodel.dart)
- Prepend `data:image/jpeg;base64,` to the Base64 encoded selfie.
- Simplify `capturedAt` to a standard ISO-8601 UTC string without milliseconds (e.g., `2026-09-14T12:29:06Z`).
- Round `accuracyMeters` to the nearest integer, as some backends expect `int` for accuracy despite response types.

## Verification Plan

### Manual Verification
- Run the app and attempt Check-In.
- Inspect the logs for the new payload structure:
    ```json
    {
      "selfie": "data:image/jpeg;base64,/9j/...",
      "latitude": 22.759...,
      "longitude": 75.904...,
      "accuracy": 15,
      "accuracyMeters": 15,
      "capturedAt": "2026-09-14T12:29:06Z",
      "locationCapturedAt": "2026-09-14T12:29:06Z"
    }
    ```
- Confirm if the status code changes to `200 OK`.
- If it still fails with `500`, I will check if the `correlationId` is now provided.
