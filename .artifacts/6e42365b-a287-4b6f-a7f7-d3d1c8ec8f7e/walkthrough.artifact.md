# Replace Create Plan UI - Walkthrough

I have successfully replaced the `Create Travel Plan` screen with the exact replica of the HTML prototype provided.

## Completed Tasks
- **New ViewModel Logic (`CreatePlanViewModel`)**: Completely rewrote the ViewModel to support the four new flow steps: List, Select Retailers, Details, and Success Screen. Embedded mock data sets directly mirroring the HTML for `territory`, `city`, and `retailersList`.
- **Responsive Navigation Flow**: Built an integrated multi-screen setup directly within the `CreatePlanScreen` widget body based on the ViewModel's `currentScreen` state. It ensures that the app bar and content areas change dynamically like standard HTML page shifts without forcing multiple routes on the navigation stack.
- **Custom UI System Replicated**:
  - Implemented the custom deep green CSS scheme (mapped to `accColor: 0xFF0f6b4f`).
  - Added custom checkmarks, dropdowns, tab toggles, and buttons that correspond to `.opt`, `.f input`, `.card`, and `.pill` classes in the CSS.
  - Implemented a custom inline bottom sheet explicitly matching `.sheet` UI.
- **Validations & Functionality**: Input fields for `fromDate`, `toDate`, `place`, and `remark` track state actively. Submissions run custom error checks and push updates back into the reactive DOM flow. Mock submission pushes a temporary "PLN-####" into the top-level list.

## How to Test
1. Press **Create Plan** in the "Visits" tab.
2. The UI will render the "My plans" list displaying a mock ticket.
3. Click the "+ Create plan" button at the bottom.
4. Search or manually check checkboxes to pick specific retailers. Click "Add plan".
5. In the bottom sheet, select **Local** or **Upcountry** and tap **Continue**.
6. Set the dates (using the material date picker connected to our custom styled input fields).
7. Select the territory/city and input a remark via text field or shortcut chip.
8. Click **Submit for approval**.
9. See the success tick. Hit **Back to my plans** to see your newly generated plan on the first screen.