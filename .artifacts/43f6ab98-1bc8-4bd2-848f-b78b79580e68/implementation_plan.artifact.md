# Implementation Plan - Expense & Claim Enhancements

This plan outlines the enhancements to the Expense & Claim screen, including an empty state and a bottom sheet for creating claims.

## User Review Required

> [!IMPORTANT]
> The bottom sheet will be triggered by the "+ Create" button in the AppBar. It will provide options for "Local Tour" and "Outstation Tour".

## Proposed Changes

### Presentation

#### [MODIFY] [expense_claim_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/expense_claim/expense_claim_screen.dart)
- Update the body to display an empty state (icon and text) when the claims list is empty, matching the reference image.
- Implement the `_showCreateClaimBottomSheet` method to display a `Get.bottomSheet` with "Local Tour" and "Outstation Tour" options.
- Update the "+ Create" button's `onPressed` to call this new method.

#### [MODIFY] [expense_claim_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/expense_claim/expense_claim_viewmodel.dart)
- Add methods to handle "Local Tour" and "Outstation Tour" selection.
- Clear initial mock data to show the empty state for verification (or keep it and allow the user to see both states).

## Verification Plan

### Manual Verification
- Verify that the "No expense claims" empty state is displayed when the list is empty.
- Click the "+ Create" button and verify that the bottom sheet appears with the correct icons and labels.
- Verify that the bottom sheet styling (rounded corners, handle bar) matches the image.
- Verify that clicking an option in the bottom sheet triggers the corresponding logic in the ViewModel.
