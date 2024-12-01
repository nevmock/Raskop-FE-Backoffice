# Raskop-FE-Backoffice

Characteristics:

- Clean Architecture
- State Management: riverpod
- Routing: go_router
- Data Modelling: freezed & json_serializable
- Analysis Options: very_good_analysis

## IMPORTANT CMD

-> Inisialisasi awal custom_lint dan riverpod_lint (cukup sekali) :

- `dart run custom_lint`

-> Generate file _.g.dart, _.freezed.dart (dijalankan tiap kali membuat/memodifikasi file yang berisi riverpod_annotation atau freezed_annotation atau json_annotation) :

- `dart run build_runner build`

## Referensi

- [Riverpod Docs](https://riverpod.dev/docs/essentials/first_request)
- [Clean Architecture Introduction](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)
- [Flutter Packages](https://pub.dev/)

## Development Guide

### 1. Run Flutter Pub Get

`flutter pub get`

### 2. Run Build Runner

`dart run build_runner build`

### 3. Run Project

`flutter run`

NOTE: Jika menemukan error yang berhubungan dengan Android SDK, tolong update Android SDK di Android Studio
