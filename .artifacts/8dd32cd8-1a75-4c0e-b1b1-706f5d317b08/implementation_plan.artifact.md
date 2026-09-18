# Implementation Plan - Application Size Optimization

This plan outlines the steps to optimize the Flutter application by removing unused code, files, dependencies, and enabling build-time optimizations. The goal is to reduce the current ~53 MB size while maintaining 100% functionality.

## User Review Required

> [!IMPORTANT]
> - Several placeholder screens (Categories, Settings, Account) will be removed as they are not registered in the routing system or used in the UI.
> - The `cupertino_icons` dependency will be removed from `pubspec.yaml` as it is not used in the codebase.
> - Android build optimizations (Minification and Resource Shrinking) will be enabled, which might affect stack trace readability in production unless mapping files are used.

## Proposed Changes

### 1. Remove Unused Presentation Files
Identified several screen placeholders and widgets that are never navigated to or imported.

#### [DELETE] [categories_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/categories/categories_screen.dart)
#### [DELETE] [settings_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/settings/settings_screen.dart)
#### [DELETE] [account_screen.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/account/account_screen.dart)
#### [DELETE] [category_item.dart](file:///E:/FlutterPracticeSrLevel/lib/presentation/home/widgets/category_item.dart)

### 2. Clean Up Data Layer
#### [DELETE] [lib/data/repository/](file:///E:/FlutterPracticeSrLevel/lib/data/repository/)
Removing the empty directory to maintain project cleanliness.

### 3. Dependency Optimization
#### [MODIFY] [pubspec.yaml](file:///E:/FlutterPracticeSrLevel/pubspec.yaml)
- Remove `cupertino_icons` dependency.
- Run `flutter pub get` to update project state.

### 4. Build Configuration Optimization
Enable R8/ProGuard to shrink code and resources in the release build.

#### [MODIFY] [build.gradle.kts](file:///E:/FlutterPracticeSrLevel/android/app/build.gradle.kts)
- Set `isMinifyEnabled = true` in the `release` build type.
- Set `isShrinkResources = true` in the `release` build type.

### 5. Final Cleanup & Verification
- Remove unused imports resulting from file deletions.
- Verify that `SplashView` logic remains intact and no "splash loop" issue is introduced.
- Verify all main screens: `HomeScreen`, `DashboardScreen`, `LoginScreen`, and all menu options in `FavoritesScreen`.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no broken imports or errors.
- Run `flutter test` (if applicable) to verify core logic.

### Manual Verification
1. **Launch App**: Verify Splash screen transitions to Login or Dashboard correctly.
2. **Dashboard Navigation**: Test all tabs (Home, Add Outlet, Visits, Menu).
3. **Menu Options**: Test all navigation items in the "Menu" (Favorites) tab to ensure they open their respective screens.
4. **Build Release**: Generate a release APK using `flutter build apk --release` and compare the size with the original ~53 MB.
