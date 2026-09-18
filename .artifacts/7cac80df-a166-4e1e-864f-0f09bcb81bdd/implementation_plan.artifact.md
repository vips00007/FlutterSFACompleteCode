# Implementation Plan - Natural Selfie Framing

The goal is to adjust the `AttendanceCameraScreen` to provide a natural selfie view that shows the user's full face and shoulders without excessive zoom, while keeping the edge-to-edge full-screen layout.

## User Review Required

> [!IMPORTANT]
> To show more of the body without "zooming in," I will reduce the size of the face-positioning oval. This will guide the user to hold the phone at a more natural distance.

## Proposed Changes

### Camera Logic & Layout

#### [MODIFY] [attendance_camera_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/widgets/attendance_camera_screen.dart)
- **Resolution & Zoom**:
    - Switch to `ResolutionPreset.max` or `veryHigh` to try and obtain a 16:9 or wider aspect ratio from the sensor, which fits tall screens with minimal cropping.
    - Explicitly call `_controller!.setZoomLevel(1.0)` after initialization to ensure no digital zoom is applied.
- **Refined Scaling**:
    - Adjust the scaling calculation to ensure we are using the widest possible field of view provided by the camera sensor while still covering the screen.
- **Face Guide Adjustment**:
    - **Resize Oval**: Reduce the width and height of the face guide oval (e.g., from 75% width to ~60% width). This forces the user to move the camera further back to fit their face in the guide, naturally showing their shoulders and upper body.
    - **Positioning**: Keep the oval centered but slightly adjusted for a more natural head-room.

## Verification Plan

### Manual Verification
- **FOV Check**: Verify that more of the background and shoulders are visible compared to the previous version.
- **Zoom Level**: Confirm the camera doesn't look "close-up" when held at arm's length.
- **Full Screen**: Ensure no black/grey bars appear on the edges.
- **Face Fit**: Test if a user can easily fit their face into the new, smaller guide at a comfortable distance.
