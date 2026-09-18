# Task: Application Size Optimization

- [x] Delete unused presentation files (Screens and Widgets)
    - [x] `lib/presentation/categories/categories_screen.dart`
    - [x] `lib/presentation/settings/settings_screen.dart`
    - [x] `lib/presentation/account/account_screen.dart`
    - [x] `lib/presentation/home/widgets/category_item.dart`
- [x] Clean up empty data directories
    - [x] `lib/data/repository/`
- [x] Optimize dependencies in `pubspec.yaml`
    - [x] Remove `cupertino_icons`
    - [x] Run `flutter pub get`
- [x] Enable Android build optimizations in `android/app/build.gradle.kts`
    - [x] Set `isMinifyEnabled = true`
    - [x] Set `isShrinkResources = true`
- [x] Final Verification
    - [x] Run `flutter analyze`
    - [x] Verify Splash logic and routing
- [x] Create Walkthrough
