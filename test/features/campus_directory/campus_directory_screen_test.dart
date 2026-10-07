import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iuiu_mobile/features/campus_directory/presentation/campus_directory_screen.dart';

void main() {
  Future<void> pumpDirectory(
    WidgetTester tester, {
    Size size = const Size(390, 844),
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: CampusDirectoryScreen()));
    await tester.pumpAndSettle();
  }

  testWidgets('searches students and switches to staff', (tester) async {
    await pumpDirectory(tester);

    expect(find.text('KAMPALA CAMPUS DIRECTORY'), findsOneWidget);
    expect(find.text('WASSWA SWALLEH'), findsOneWidget);
    expect(find.text('MR. WAHAB ISMAEL'), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('directory-search-field')),
      'Aisha',
    );
    await tester.pump();
    expect(find.text('AISHA NAMULI'), findsOneWidget);
    expect(find.text('WASSWA SWALLEH'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('clear-directory-search')));
    await tester.pump();
    await tester.tap(find.text('Staff'));
    await tester.pumpAndSettle();

    expect(find.text('MR. WAHAB ISMAEL'), findsOneWidget);
    expect(find.text('WASSWA SWALLEH'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('confirms a call and opens an in-app conversation', (
    tester,
  ) async {
    await pumpDirectory(tester);

    await tester.tap(find.byKey(const ValueKey('call-student-wasswa-swalleh')));
    await tester.pumpAndSettle();
    expect(find.text('Initiate call?'), findsOneWidget);
    expect(find.text('Call Wasswa Swalleh on 0753304550?'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('confirm-directory-call')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Calling 0753304550'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('message-student-wasswa-swalleh')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Wasswa Swalleh'), findsWidgets);
    expect(find.byKey(const ValueKey('message-composer')), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('message-composer')),
      'Hello from the directory',
    );
    await tester.tap(find.byKey(const ValueKey('send-message-button')));
    await tester.pumpAndSettle();
    expect(find.text('Hello from the directory'), findsOneWidget);
  });

  testWidgets('remains overflow-free on phone and tablet layouts', (
    tester,
  ) async {
    for (final size in const [Size(320, 700), Size(900, 1000)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(key: ValueKey(size), home: const CampusDirectoryScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('KAMPALA CAMPUS DIRECTORY'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tester.binding.setSurfaceSize(null);
  });
}
