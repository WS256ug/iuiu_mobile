import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iuiu_mobile/features/home/presentation/home_screen.dart';
import 'package:iuiu_mobile/features/results/presentation/results_screen.dart';

void main() {
  testWidgets('Home My Results opens examination results', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: HomeScreen(currentTime: DateTime(2026, 1, 1, 14))),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('My Results'));
    await tester.pumpAndSettle();

    expect(find.text('EXAMINATION RESULTS'), findsOneWidget);
    expect(find.textContaining('GPA: 4.14'), findsOneWidget);
    expect(find.textContaining('CGPA: 4.32'), findsOneWidget);
    expect(
      find.text('BIT 1106 · MATHEMATICS FOR INFORMATION TECHNOLOGY'),
      findsOneWidget,
    );
  });

  testWidgets('switches academic period and coursework content', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: ResultsScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('result-year-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Year 2').last);
    await tester.pumpAndSettle();

    expect(find.text('YEAR 2 SEMESTER 1 DETAILS'), findsOneWidget);
    expect(
      find.text('BIT 2101 · DATA STRUCTURES AND ALGORITHMS'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('coursework-tab')));
    await tester.pumpAndSettle();
    expect(find.text('COURSEWORK PERFORMANCE'), findsOneWidget);
    expect(find.text('YEAR 2 SEMESTER 1 COURSEWORK'), findsOneWidget);
    expect(find.text('Assignment: 19/20'), findsOneWidget);
    expect(find.text('43/50'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('results remain overflow-free on small phones and tablets', (
    tester,
  ) async {
    for (final size in const [Size(320, 700), Size(900, 1000)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(key: ValueKey(size), home: const ResultsScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('EXAMINATION RESULTS'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tester.binding.setSurfaceSize(null);
  });
}
