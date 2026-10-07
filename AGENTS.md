# AGENTS.md

## Project Overview

IUIU Mobile is a Flutter application for Islamic University in Uganda.

The project is currently focused on delivering a polished, responsive user
interface. Screens use local mock data so the complete user experience can be
built and reviewed before backend integration begins.

Future development will replace the mock data with data from APIs. The existing
UI should remain visually unchanged during that transition.

## Current Objective

Maintain and improve the existing Flutter UI without redesigning it.

All work must:

- Preserve the current layout and visual identity.
- Keep screens responsive and free of overflow.
- Improve code organization and reuse where this does not alter the UI.
- Keep mock data easy to replace with API data later.
- Keep the application compiling and passing analysis and tests.

## UI Is the Source of Truth

The current implemented UI and any approved design references are the source of
truth.

Do not change the following unless the user explicitly requests a design change:

- Layout and component positions
- Colors and gradients
- Typography
- Icons
- Spacing and sizing
- Images and branding
- Navigation flow
- Visible text and labels
- Animations or interaction behavior

Refactoring is allowed only when the rendered result and user interaction remain
the same.

If a requested change conflicts with the current UI or an approved design, ask
for clarification before changing the design.

## Current Development Scope

Allowed:

- Implement and maintain Flutter screens.
- Fix UI bugs, overflow, and responsiveness issues.
- Extract repeated UI into reusable widgets.
- Organize files by feature.
- Improve themes, constants, and shared visual primitives.
- Use local mock data for all displayed content.
- Add placeholder destinations for navigation already represented in the UI.
- Add or update widget and golden tests.
- Refactor data access behind simple interfaces when needed for API readiness.

Do not add unless explicitly requested:

- Real API calls
- HTTP clients or networking packages
- Authentication
- State-management packages
- Database or local-storage code
- Caching or offline synchronization
- Analytics
- Backend business rules
- Unrelated third-party packages

## Mock Data and Future APIs

All current student, service, course, message, notification, and profile data is
mock data.

Mock data must be treated as replaceable input, not embedded permanently in
widget layout code.

When adding or changing a screen:

1. Define the data needed by the UI using small, typed models.
2. Keep mock values in dedicated mock-data or data-source files.
3. Pass data into widgets through constructor parameters where practical.
4. Keep formatting and display decisions in the presentation layer.
5. Keep navigation callbacks outside data models.
6. Do not make widgets depend directly on a future API response shape.

When API integration begins, API DTOs should be mapped into the existing
application or presentation models. Do not reshape the UI around raw API
responses.

Replacing mock data with API data must not require redesigning reusable widgets
or changing the visual structure of a screen.

## Architecture Direction

Use a feature-first structure for new code and migrate existing code gradually
when working in the same area:

```text
lib/
  core/
    theme/
    constants/
    navigation/
    utils/
  shared/
    models/
    widgets/
  features/
    home/
      data/
      presentation/
    services/
      data/
      presentation/
    elearning/
      data/
      presentation/
    messages/
      data/
      presentation/
    profile/
      data/
      presentation/
  app.dart
  main.dart
```

For the current UI phase, keep architecture lightweight:

- `presentation/` contains screens and feature-specific widgets.
- `data/` contains mock data and, later, API implementations.
- `shared/` contains components genuinely reused by multiple features.
- `core/` contains app-wide theme, constants, navigation, and utilities.
- Do not create empty layers or speculative abstractions.
- Do not move unrelated files as part of a small feature change.

## Models and Data Boundaries

- Use stable IDs for navigation and item identity; do not rely on visible titles.
- Keep callbacks such as `onTap` out of data models.
- Prefer immutable models with `const` constructors where possible.
- Keep API transport objects separate from UI-facing models when APIs are added.
- Do not import screens or navigation code into model or mock-data files.
- Flutter-specific visual properties such as `IconData` and `Color` may be used
  in presentation models, but should not be added to future API/domain models.

## Reusable Widgets

Before creating a widget, check for an existing component that already provides
the same structure.

Common reusable components include:

- App bars and search headers
- Buttons and text fields
- Service list and grid items
- Information cards
- Empty states
- Profile avatars
- Navigation components
- Branded banners

If substantially the same UI appears more than twice, extract or extend a shared
widget. Prefer configuration parameters over creating another nearly identical
component.

Feature-specific widgets should remain inside their feature. Move a widget to
`shared/widgets/` only when it is genuinely reused across features.

## Styling and Theming

- Preserve the existing appearance.
- Use the project theme, `AppColors`, and shared constants.
- Avoid introducing new hardcoded colors, typography, radii, or repeated spacing
  values when an existing token applies.
- Consolidating existing values into theme tokens is allowed only if the
  rendered output remains unchanged.
- Bundle any required custom font instead of relying on a font that may not be
  available on every platform.
- Use current, non-deprecated Flutter APIs.

## Responsiveness

Every changed screen must continue to support:

- Small phones
- Large phones
- Tablets
- Text scaling
- Safe areas and keyboard insets where relevant

Avoid introducing unnecessary fixed widths or heights. Use `LayoutBuilder`,
constraints, wrapping, or adaptive column counts when needed, while preserving
the approved layout at its reference size.

## Navigation

- Preserve the navigation flow already represented by the UI.
- Use stable route or destination identifiers instead of comparing display text.
- Reuse one navigation approach consistently.
- Placeholder screens or “coming soon” feedback are acceptable during the UI
  phase, but do not keep multiple disconnected placeholders for the same
  destination.
- Do not add authentication guards or backend-driven routing yet.

## Code Quality

- Keep widgets small and focused.
- Prefer `const` constructors and immutable values.
- Use meaningful names.
- Remove dead statements and obsolete commented-out code when working nearby.
- Do not duplicate filtering, empty-state, card, tile, or banner implementations.
- Use one consistent import style within the project.
- Avoid broad refactors unrelated to the requested task.
- Preserve existing user changes.

## Dependencies

- Do not add a package unless the user explicitly requests it or the task cannot
  reasonably be completed with Flutter and the existing dependencies.
- Before adding a dependency, explain why it is needed.
- Remove a dependency only after verifying that it is unused in application,
  test, build, and platform code.
- Prefer Flutter SDK capabilities for UI work.

## Testing and Validation

Before completing a code change:

1. Format changed Dart files.
2. Run `flutter analyze`.
3. Run relevant widget tests, then `flutter test` when practical.
4. Check for overflow at small-phone and tablet sizes when UI was changed.
5. Confirm the visible UI and navigation behavior remain unchanged unless the
   user requested otherwise.
6. Confirm no API, persistence, authentication, or business logic was added
   unintentionally.

When adding new screens or reusable widgets, add focused widget tests where
practical. Tests should cover important content, interactions, navigation, and
at least representative phone and tablet constraints for responsive layouts.

## Working Rules for Agents

- Read this file before modifying the project.
- Inspect existing widgets before creating new ones.
- Make the smallest change that fully satisfies the request.
- Do not redesign the application without explicit approval.
- Do not replace mock data with networking until API integration is requested.
- Do not infer backend behavior from placeholder UI.
- If an implementation detail is unclear and could visibly change the design,
  ask for clarification.
- Clearly report changed files and validation results when work is complete.
