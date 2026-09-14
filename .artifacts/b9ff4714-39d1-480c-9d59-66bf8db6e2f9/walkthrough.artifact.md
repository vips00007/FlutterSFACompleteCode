# Walkthrough - Attendance API Error Resolution (Iterative Fix)

I have implemented additional robustness measures to the Attendance API request to resolve the persistent `500 INTERNAL_ERROR`.

## Changes Made

### 1. Data URI Format for Selfie
In [home_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/home_viewmodel.dart), I modified the selfie encoding to include the `data:image/jpeg;base64,` prefix.

```diff
- final String base64Image = base64Encode(imageBytes);
+ final String base64Image = "data:image/jpeg;base64,${base64Encode(imageBytes)}";
```

### 2. JSON Payload Field Aliasing
In [attendance_request.dart](file:///E:/FlutterPracticeSrLevel/lib/data/models/attendance_request.dart), I updated the `toJson()` method to provide alternative field names that are common in backend APIs.

```diff
     return {
       'selfie': selfie,
       'latitude': latitude,
       'longitude': longitude,
       'accuracyMeters': accuracyMeters,
+      'accuracy': accuracyMeters.round(),
       'capturedAt': capturedAt,
+      'locationCapturedAt': capturedAt,
     };
```

### 3. Simplified Timestamp
I simplified the `capturedAt` string in [home_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/home_viewmodel.dart) to exclude milliseconds, which can sometimes cause parsing issues on certain server configurations.

```diff
- final capturedAt = "${now.toIso8601String().split('.').first}.${now.millisecond.toString().padLeft(3, '0')}Z";
+ final capturedAt = "${now.toIso8601String().split('.').first}Z";
```

## Verification
- Please run the app and attempt Check-In.
- The logs will show the new "Selfie Base64 length" which will be slightly larger due to the prefix.
- The `capturedAt` and `locationCapturedAt` fields in the body should now look like: `2026-09-14T12:29:06Z`.

> [!TIP]
> If you still receive a 500 error, please check the console for the `Ref: <correlationId>` and the "Total Body Length". If the body length is very large, we may need to compress the image further.
