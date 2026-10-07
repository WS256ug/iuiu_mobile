import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iuiu_mobile/app.dart';

void main() {
  testWidgets('main tabs open their matching screens', (tester) async {
    // Starts the complete app at a common phone-sized test surface.
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const IuiuApp());
    await tester.pumpAndSettle();

    // Completes the local sign-in UI to enter the application shell.
    await tester.enterText(
      find.byKey(const ValueKey('identifier-field')),
      '223-063012-25992',
    );
    await tester.enterText(
      find.byKey(const ValueKey('password-field')),
      'password',
    );
    await tester.tap(find.byKey(const ValueKey('campus-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kampala Campus').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('sign-in-button')));
    await tester.tap(find.byKey(const ValueKey('sign-in-button')));
    await tester.pumpAndSettle();

    // Confirms that the dashboard is the initial signed-in destination.
    expect(
      find.textContaining(RegExp(r'Good (Morning|Afternoon|Evening),')),
      findsOneWidget,
    );
    expect(find.text('View all'), findsNothing);

    // Opens the existing Profile destination from the Home shortcut.
    await tester.tap(find.text('My Profile'));
    await tester.pumpAndSettle();
    expect(find.text('WASSWA SWALLEH'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('app-top-bar-title-Profile')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('bottom-nav-0')));
    await tester.pumpAndSettle();

    // Opens Services through the shared bottom navigation.
    await tester.tap(find.byKey(const ValueKey('bottom-nav-1')));
    await tester.pumpAndSettle();
    expect(find.text('Search services...'), findsOneWidget);
    expect(
      tester
          .getTopLeft(find.byKey(const ValueKey('app-top-bar-title-Services')))
          .dx,
      12,
    );

    // Confirms that Messages uses the same leading title alignment.
    await tester.tap(find.byKey(const ValueKey('bottom-nav-2')));
    await tester.pumpAndSettle();
    expect(
      tester
          .getTopLeft(find.byKey(const ValueKey('app-top-bar-title-Messages')))
          .dx,
      12,
    );

    // Opens Profile and confirms the account overview is present.
    await tester.tap(find.byKey(const ValueKey('bottom-nav-3')));
    await tester.pumpAndSettle();
    expect(
      tester
          .getTopLeft(find.byKey(const ValueKey('app-top-bar-title-Profile')))
          .dx,
      12,
    );
    expect(find.text('WASSWA SWALLEH'), findsOneWidget);
    expect(find.text('223-063012-25992'), findsOneWidget);
    expect(find.text('0753304550'), findsOneWidget);
    expect(find.text('wasswaswalleh@iuiu.ac.ug'), findsOneWidget);
    expect(find.text('Kampala Campus'), findsOneWidget);
    expect(find.text('Full Profile'), findsOneWidget);
    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
    expect(find.text('REFRESH DATA'), findsNothing);

    // Confirms logout and verifies that the signed-in routes are removed.
    await tester.ensureVisible(find.byKey(const ValueKey('logout-button')));
    await tester.tap(find.byKey(const ValueKey('logout-button')));
    await tester.pumpAndSettle();
    expect(find.text('Log out?'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('confirm-logout-button')));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byKey(const ValueKey('bottom-nav-0')), findsNothing);

    // Restores the default surface size for any later tests.
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('registration service opens course units', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const IuiuApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('identifier-field')),
      '223-063012-25992',
    );
    await tester.enterText(
      find.byKey(const ValueKey('password-field')),
      'password',
    );
    await tester.tap(find.byKey(const ValueKey('campus-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kampala Campus').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('sign-in-button')));
    await tester.tap(find.byKey(const ValueKey('sign-in-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('bottom-nav-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Registration'));
    await tester.pumpAndSettle();

    expect(find.text('REGISTRATION CENTRE'), findsOneWidget);
    expect(find.text('2025/2026  •  Semester 2'), findsOneWidget);
    expect(find.text('REGISTERED LATE'), findsOneWidget);

    await tester.tap(find.text('2025/2026  •  Semester 2'));
    await tester.pumpAndSettle();
    expect(find.text('Self Registration'), findsOneWidget);
    expect(find.text('View Course Units'), findsOneWidget);

    await tester.tap(find.text('View Course Units'));
    await tester.pumpAndSettle();

    expect(find.text('COURSE UNITS AND FACULTY REGISTRATION'), findsOneWidget);
    expect(
      find.text('BIT 3202 - Business Intelligence and Data Warehousing'),
      findsOneWidget,
    );
    expect(find.text('Regular Courses'), findsOneWidget);
    expect(find.text('Retake Courses'), findsOneWidget);

    await tester.tap(find.text('Retake Courses'));
    await tester.pumpAndSettle();
    expect(find.text('Add Course Units'), findsOneWidget);
    expect(find.text('Faculty Registration'), findsNothing);
    expect(find.text('No retake courses'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
