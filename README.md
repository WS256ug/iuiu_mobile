# IUIU Mobile

IUIU Mobile is a Flutter application for Islamic University in Uganda. The
current application is UI-focused and uses local mock data while the screens
and navigation are being completed.

For the complete non-technical explanation of the design, architecture, data
flow, dependencies, screen-building order, and testing rules, read
[`docs/DESIGN_DOCUMENT.md`](docs/DESIGN_DOCUMENT.md).

## Project structure

```text
lib/
  core/
    constants/    App-wide values
    navigation/   Main shell and service navigation
    theme/        Colors and other visual tokens
    utils/        Formatting and context helpers
  features/
    elearning/
    home/
    messages/
    profile/
    registration/
    services/
  shared/
    models/       Models used by more than one feature
    widgets/      Widgets used by more than one feature
  app.dart        Application and theme configuration
  main.dart       Application entry point
```

Each feature keeps its own files together:

- `data/` contains replaceable mock data.
- `presentation/` contains screens and feature-specific widgets.
- `presentation/screens/` contains secondary screens when a feature has several.
- `presentation/widgets/` contains widgets used only by that feature.

Move a model or widget into `shared/` only when multiple features use it.
App-wide navigation, styling, constants, and utilities belong in `core/`.

## Common commands

```sh
flutter pub get
flutter run
flutter analyze
flutter test
```

## Development direction

Preserve the existing UI and navigation behavior. Keep displayed content in
typed models and dedicated mock-data files so APIs can replace the mock sources
later without changing the screens or reusable widgets.
