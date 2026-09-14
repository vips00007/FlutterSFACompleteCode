# Implementation Plan - Image Compression and Resizing for Attendance

The goal is to optimize the Attendance API payload by resizing and compressing the captured selfie before sending it to the server, reducing the risk of "INTERNAL_ERROR" due to large payloads.

## User Review Required

> [!IMPORTANT]
> I have added the `image` package to handle high-quality JPEG compression and resizing. This is a pure Dart package and does not require platform-specific changes.
>
> The image will be resized to a maximum of **1280px** on its longest side and compressed at **75% JPEG quality**.

## Proposed Changes

### [Component] Dependencies

#### [MODIFY] [pubspec.yaml](file:///E:/FlutterPracticeSrLevel/pubspec.yaml)
- Add `image: ^4.2.0` dependency.

### [Component] View Models

#### [MODIFY] [home_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/home_viewmodel.dart)
- Import `package:image/image.dart` as `img`.
- Update `performAttendance` to:
    - Decode the captured image.
    - Resize it if it exceeds 1280px.
    - Encode it as a JPEG with 75% quality.
    - Log both original and compressed dimensions and file sizes.

### [Component] API Services

#### [MODIFY] [attendance_api_service.dart](file:///E:/FlutterPracticeSrLevel/lib/data/datasource/remote/attendance_api_service.dart)
- The service remains unchanged as it already handles the optimized payload structure, but I will ensure the logs are clear.

## Verification Plan

### Automated Tests
- Code inspection to ensure the sequence: **Capture -> Decode -> Resize -> JPEG Encode -> Base64**.

### Manual Verification
- The user will capture a selfie.
- Check console logs for:
    - `Original image size` (e.g., 3.5 MB)
    - `Compressed image size` (e.g., 250 KB)
    - `Compressed image dimensions` (e.g., 1280x960)
    - `Base64 prefix` starting with `/9j/` (standard for JPEG).
- Verify if the API returns a success response.
