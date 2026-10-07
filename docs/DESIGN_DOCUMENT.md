# IUIU Mobile Design and Architecture Document

## 1. Purpose of this document

This document explains how the IUIU Mobile project is designed, why its files
are arranged as they are, how screens should be built, and how the current mock
data can later be replaced by APIs. It is written for developers, designers,
reviewers, and non-technical project stakeholders.

The application currently prioritizes a polished and complete user interface.
Most displayed information is local mock data. Backend integration must replace
the source of the data without changing the approved appearance of the screens.

## 2. Product goal

IUIU Mobile gives Islamic University in Uganda students one mobile place to:

- Sign in and recover access.
- View student and profile information.
- Open university services.
- Review registration and course units.
- View academic results and coursework.
- Review fees and payment history.
- View class, test, and examination timetables.
- Search the campus directory.
- Read and send local mock messages.
- Browse library resources and profile information.
- Complete lecturer evaluations.
- Enter the E-Learning Centre.

## 3. Design source of truth

The currently approved Flutter UI and approved screenshots are the visual
source of truth. A code refactor must not silently change layout, colors,
spacing, type, icons, labels, navigation, or interactions.

When an older screenshot is used as a content reference, the information is
transcribed into the current design language rather than restoring obsolete
styling. This keeps the whole application visually consistent.

## 4. Visual design principles

The Home screen establishes the shared visual language:

1. IUIU green is the primary brand color.
2. Pages use a pale green background with readable white content cards.
3. Cards use consistent corner radii, shadows, and internal spacing.
4. Typography has a clear hierarchy rather than unrelated sizes per screen.
5. Primary page titles live in the shared top bar.
6. Section headings are compact and normally uppercase.
7. Card titles use title case and a moderate bold weight.
8. Secondary information uses the shared grey text color.
9. Red is reserved for warnings, confidential notices, or important scores.
10. An entire card is tappable when there is only one logical action.
11. Duplicate action buttons are avoided when the card tap already performs
    the same action.
12. Loading, empty, and future placeholder states should explain what is
    happening in simple language.

The shared visual values are defined in:

- `lib/core/theme/app_colors.dart`
- `lib/core/theme/app_text_styles.dart`
- `lib/core/constants/app_constants.dart`

## 5. Project structure

```text
lib/
  core/
    constants/          Shared sizing and current student placeholder values
    navigation/         Main tab shell and service-to-screen routing
    theme/              Shared colors and text styles
    utils/              Formatting and small BuildContext helpers
  features/
    authentication/     Login and password recovery
    campus_directory/   Student/staff contact search
    elearning/          E-Learning dashboard and service list
    fees/               Balance and payment ledger
    home/               Main student dashboard
    lecturer_evaluation/Period filters, lecturer list, and questionnaire
    library/            Digital resources, catalogue, and member profile
    messages/           Conversation list and chat UI
    profile/            Student account summary and actions
    registration/       Semester registration and course units
    results/            Examination and coursework results
    services/           Shared catalogue of available student services
    timetable/          Class, test, and examination schedules
  shared/
    models/             Data shapes genuinely used by multiple features
    widgets/            Visual components genuinely used by multiple features
  app.dart              Material application and global theme
  main.dart             Program entry point
```

Tests mirror the feature layout under `test/`. Project-level design and backend
documents live under `docs/`.

## 6. Why the project is structured this way

### Feature-first organization

All files for one user-facing capability are kept together. For example, the
lecturer-evaluation models, mock data, list screen, and questionnaire are under
`features/lecturer_evaluation/`.

This structure makes it easier to answer questions such as “where is the
registration screen?” without searching unrelated global model, data, widget,
and screen folders. It also reduces the chance that a change to one feature
accidentally affects another.

### The `core` folder

`core` contains rules and utilities used by the application as a whole. It does
not belong to one student service. Colors, typography, navigation, shared
dimensions, and generic formatting belong here.

### The `shared` folder

`shared` contains components that are genuinely reused across features. A
widget should remain inside its feature until at least two features need the
same visual structure. This prevents `shared` from becoming an unorganized
collection of one-off widgets.

### Lightweight architecture

The application intentionally has no networking, database, caching, analytics,
or third-party state-management layer yet. Creating those layers before the
backend contract exists would add complexity without improving the UI.

## 7. Responsibility of folders inside a feature

```text
feature_name/
  data/          Replaceable local mock values and future data sources
  models/        Stable, typed information used by the feature UI
  presentation/  Screens and feature-only widgets
```

- Models contain data, not navigation callbacks.
- Mock data uses stable IDs so reordering does not change identity.
- Presentation code decides how values are formatted and displayed.
- Screens accept data through constructors where practical, which improves
  testing and prepares them for API-backed values.
- Navigation is initiated by presentation or central navigation code, never by
  a model.

Some older/simple features keep small models in their data file. They can be
moved gradually when that feature is next changed; unrelated broad migrations
are avoided.

## 8. Application flow

1. `main.dart` starts Flutter and creates `IuiuApp`.
2. `app.dart` defines the Material 3 theme and opens `LoginScreen`.
3. The local sign-in form validates visible input only; it does not contact a
   backend.
4. Successful local sign-in opens `AppShell`.
5. `AppShell` keeps Home, Services, Messages, and Profile alive in an
   `IndexedStack` while bottom navigation changes the visible tab.
6. Home shortcuts may open Profile, Results, or Fees directly.
7. Service cards use `ServiceDestination` and `openService` to open implemented
   screens or consistent “coming soon” feedback.
8. Feature screens use normal Flutter routes for child/detail screens and the
   shared top bar for back navigation.

## 9. Navigation design

The main tabs are:

| Index | Tab | Purpose |
| --- | --- | --- |
| 0 | Home | Student greeting, quick information, and common services |
| 1 | Services | Searchable catalogue of student services |
| 2 | Messages | Conversations and local chat experience |
| 3 | Profile | Student information and account actions |

Implemented service destinations include Campus Directory, E-Learning,
Registration, Timetable, Lecturer Evaluation, and Library. Unimplemented
services use one shared “coming soon” message instead of separate placeholder
screens.

Stable destination enums are used instead of comparing visible titles. A title
can therefore change without breaking routing.

## 10. Data flow today

```text
typed mock data -> screen constructor/state -> small UI widgets -> user display
```

Examples:

- `RegistrationMockData` supplies semester registrations and course units.
- `ResultsMockData` supplies result periods and course marks.
- `TimetableMockData` supplies selectable periods and timetable entries.
- `LecturerEvaluationMockData` supplies periods, lecturers, and questions.
- `MessageMockData` supplies conversations and chat messages.
- `LibraryMockData` supplies categories, resources, books, and member details.

Widgets do not parse JSON and do not depend on a future API response shape.

## 11. Future API data flow

The recommended backend flow is:

```text
API response JSON
  -> transport DTO
  -> mapper
  -> existing application/presentation model
  -> existing screen and widgets
```

The API integration should add repository contracts and implementations only
when endpoints are ready. For example:

```text
LecturerEvaluationApiDto
  -> LecturerEvaluationMapper
  -> LecturerEvaluation
  -> LecturerEvaluationScreen
```

This boundary prevents backend naming or nesting from redesigning the UI.
Loading, error, empty, and success states should be introduced around the
existing successful layout.

See `docs/ASP_NET_API_IMPLEMENTATION.md` for the backend-oriented plan.

## 12. Dependencies

### Runtime dependencies

| Dependency | Reason |
| --- | --- |
| Flutter SDK | UI framework, navigation, Material widgets, and platform builds |
| `cupertino_icons` | Optional iOS-style icons supplied by the Flutter template |

### Development dependencies

| Dependency | Reason |
| --- | --- |
| `flutter_test` | Unit and widget testing |
| `flutter_lints` | Static code-quality rules |

No networking, state-management, database, local-storage, or analytics package
is currently required. Flutter SDK tools are preferred until a real requirement
cannot reasonably be met without another dependency.

The theme currently requests Arial. No custom font asset is bundled, so Flutter
may use a platform fallback where Arial is unavailable. A font should be bundled
before typography must be pixel-identical on every platform.

## 13. Screen design order

New screens and major changes should follow this order:

1. **Confirm the source of truth.** Review the existing UI, approved screenshot,
   labels, and expected navigation.
2. **Identify the information.** List every value the user needs to see or
   change. Do not invent backend behavior from incomplete references.
3. **Create typed models.** Give each navigable or repeatable record a stable ID.
4. **Create mock data.** Keep sample values outside the widget tree.
5. **Find reusable components.** Reuse top bars, search headers, cards, avatars,
   section headings, and service tiles before creating another variant.
6. **Build the successful state.** Match the approved layout using shared
   colors, typography, radii, and spacing.
7. **Add interactions.** Keep callbacks in presentation code and provide clear
   placeholder feedback when backend behavior does not exist.
8. **Add empty and error-ready states.** Explain the situation instead of
   leaving a blank screen.
9. **Make the layout responsive.** Check small phones, large phones, tablets,
   safe areas, keyboard insets, and enlarged text.
10. **Write focused tests.** Cover important content, filtering, navigation,
    actions, phone constraints, and tablet constraints.
11. **Format and validate.** Run `dart format`, `flutter analyze`, and
    `flutter test`.
12. **Document important decisions.** Update this document when architecture or
    design rules change.

## 14. Responsive design rules

- Main content is normally centered and limited to approximately 720 logical
  pixels on wide devices.
- Horizontal page padding comes from `AppConstants.pagePadding`.
- Rows use `Expanded`, `Flexible`, wrapping, or calculated widths so text does
  not overflow.
- Long lists use `ListView`, `GridView`, or slivers rather than fixed-height
  columns.
- Forms allow the scaffold to respond to the keyboard.
- Important screens are tested at a small phone width and a tablet width, often
  with 130% text scaling.
- Text is allowed to wrap unless truncation is explicitly part of the design.

## 15. Typography rules

`AppTextStyles` provides the shared hierarchy:

- `screenHeading`: important content heading beneath the top bar.
- `sectionHeading`: compact group label.
- `cardTitle`: primary text inside a card.
- `fieldLabel`: small label above a value.
- `bodyValue`: normal displayed value.
- `supporting`: lower-emphasis explanation.

New screens should use these styles before creating a new `TextStyle`. A new
style belongs in the shared theme only when it represents a repeated semantic
role, not just one convenient font size.

## 16. Reusable component rules

- `AppTopBar` provides consistent page titles and optional back navigation.
- `SearchHeader` combines a top bar with search/filter controls.
- `SectionHeader` labels content groups.
- `ServiceGridCard` and `ServiceListTile` show shared service data.
- `ProfileAvatar` creates a consistent student identity placeholder.
- `AppBottomNavigation` owns the four primary tab controls.

Feature-specific components remain private in their screen or feature until
another feature genuinely needs them.

## 17. Interaction guidelines

- If a card has one action, make the full card tappable.
- Use a chevron as a quiet navigation hint; do not add a second button that
  performs the same action.
- Confirm destructive or account-changing actions such as logout.
- Preserve entered form text while showing validation errors.
- Use bottom sheets for short choices that should not require a new page.
- Clearly label placeholder actions so users are not led to believe data was
  saved to a server.

## 18. Testing strategy

The project uses unit and widget tests.

- Formatter tests verify pure text/number formatting.
- Authentication tests verify validation and entry into the app shell.
- Feature tests verify visible content, filtering, navigation, and interaction.
- Responsive tests check small-phone and tablet constraints with increased text
  scale.
- The top-level widget test verifies the main navigation and major service flow.

Before a change is considered complete:

```sh
dart format lib test
flutter analyze
flutter test
```

## 19. Commenting standard

Code comments explain **why a block exists**, **what user-visible responsibility
it has**, or **why a choice is important**. They should not repeat obvious Dart
syntax. Recommended forms are:

- File/class documentation for each screen, model, data source, and component.
- Method documentation for filtering, navigation, validation, confirmation,
  formatting, and other behavior.
- Short inline comments before important state transitions or responsive layout
  decisions.

Comments must be updated when behavior changes. Incorrect comments are more
harmful than missing comments.

## 20. Current limitations

- Authentication is UI-only and does not verify credentials remotely.
- Data is local and resets when the app restarts.
- Submit, download, payment, calling, and similar backend actions are mock or
  placeholder interactions.
- There is no offline cache or persistence layer.
- There is no analytics or production error-reporting integration.
- Some screen files are large and can be split gradually when components become
  reused or independent testing would materially improve.

## 21. Definition of done for UI work

A UI task is complete when:

- It matches the approved design and current visual language.
- It uses typed, replaceable data.
- It has stable identity for repeatable records.
- It has clear navigation and interaction feedback.
- It handles empty content where relevant.
- It does not overflow on supported phone/tablet sizes and text scaling.
- It adds no unrequested backend or dependency.
- Changed Dart files are formatted.
- Static analysis reports no issues.
- Relevant and full tests pass.
- The changed behavior is documented in plain language.

## 22. Glossary for non-technical readers

- **Widget:** A visible or structural piece of a Flutter screen.
- **Screen:** A full page the user can navigate to.
- **Model:** A named description of information, such as a course or message.
- **Mock data:** Temporary sample information used before a backend is connected.
- **API:** The agreed method the mobile app uses to request server data.
- **DTO:** A technical object matching the server response before it is converted
  into an app model.
- **Route:** A navigation path from one screen to another.
- **State:** Temporary information the screen must remember, such as selected
  semester, search text, or typed message.
- **Responsive:** Able to fit different screen sizes and text settings.
- **Static analysis:** Automated checks that find code problems without running
  the app.
- **Widget test:** An automated test that builds Flutter UI and interacts with it.
