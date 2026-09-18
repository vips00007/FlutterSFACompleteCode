# Product & Catalogue Screen Implementation Plan

This plan outlines the steps to create a new "Product Catalog" screen and integrate it into the existing side-menu (Favorites screen) navigation flow.

## User Review Required

> [!IMPORTANT]
> The navigation will be added to the "Product Catalog" item in the `FavoritesScreen`, which serves as the "Menu" in the bottom navigation.

## Proposed Changes

### Routes & Navigation

#### [MODIFY] [route_names.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/route_names.dart)
- Add `product_catalogue_view` constant to `RoutesName` class.

#### [MODIFY] [routes.dart](file:///E:/FlutterPracticeSrLevel/lib/routes/routes.dart)
- Register `product_catalogue_view` route using `GetPage`.
- Define dependencies (ViewModel) if needed.

#### [MODIFY] [favorites_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/favorites/favorites_screen.dart)
- Update the `Product Catalog` menu item to navigate to the new route using `Get.toNamed()`.

### Presentation Layer

#### [NEW] [product_catalogue_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/product_catalogue/product_catalogue_screen.dart)
- Implement the `ProductCatalogueScreen` widget.
- Build the UI according to the reference image:
    - Custom AppBar with "Product Catalog" title and back button.
    - Search text field with search icon.
    - ListView of product cards.
    - `ProductCard` widget with the specific layout: Icon, Title, Code, and the three-column details (Size, Rate, Category).

#### [NEW] [product_catalogue_viewmodel.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/product_catalogue/product_catalogue_viewmodel.dart)
- Create a simple ViewModel to manage state (searching, list of products).
- Mock data will be used initially to match the reference image.

## Verification Plan

### Manual Verification
- Navigate to the "Menu" tab in the bottom navigation.
- Tap on "Product Catalog".
- Verify that the `ProductCatalogueScreen` opens directly.
- Check the UI against the reference image for responsiveness and visual accuracy.
- Test the back button to ensure it returns to the "Menu" tab.
