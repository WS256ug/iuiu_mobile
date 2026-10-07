import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iuiu_mobile/features/authentication/presentation/login_screen.dart';

void main() {
  Future<void> pumpLogin(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    VoidCallback? onSignedIn,
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(onSignedIn: onSignedIn)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('validates required credentials and campus', (tester) async {
    await pumpLogin(tester);

    await tester.ensureVisible(find.byKey(const ValueKey('sign-in-button')));
    await tester.tap(find.byKey(const ValueKey('sign-in-button')));
    await tester.pump();

    expect(
      find.text('Enter your registration number or staff ID'),
      findsOneWidget,
    );
    expect(find.text('Enter your password'), findsWidgets);
    expect(find.text('Select your campus'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('submits complete credentials', (tester) async {
    var signedIn = false;
    await pumpLogin(tester, onSignedIn: () => signedIn = true);

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
    await tester.pump();

    expect(signedIn, isTrue);
  });

  testWidgets('opens email recovery and confirms a valid submission', (
    tester,
  ) async {
    await pumpLogin(tester);

    await tester.ensureVisible(
      find.byKey(const ValueKey('forgot-password-button')),
    );
    await tester.tap(find.byKey(const ValueKey('forgot-password-button')));
    await tester.pumpAndSettle();

    expect(find.text('Forgot password?'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('recovery-email-field')),
      'student@iuiu.ac.ug',
    );
    await tester.tap(find.byKey(const ValueKey('send-recovery-button')));
    await tester.pump();

    expect(find.byKey(const ValueKey('recovery-confirmation')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('remains overflow-free on a tablet', (tester) async {
    await pumpLogin(tester, size: const Size(1024, 768));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('ISLAMIC UNIVERSITY IN UGANDA'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('remains usable on a small phone', (tester) async {
    await pumpLogin(tester, size: const Size(320, 700));

    await tester.ensureVisible(find.byKey(const ValueKey('sign-in-button')));
    expect(find.byKey(const ValueKey('sign-in-button')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
