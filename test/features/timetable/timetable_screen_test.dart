import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iuiu_mobile/features/services/presentation/services_screen.dart';
import 'package:iuiu_mobile/features/timetable/models/timetable.dart';
import 'package:iuiu_mobile/features/timetable/presentation/timetable_screen.dart';

void main() {
  testWidgets('My Timetables requires a type selection before proceeding', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ServicesScreen())),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'timetable');
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Timetables'));
    await tester.pumpAndSettle();

    expect(find.text('Select timetable type'), findsOneWidget);
    expect(find.text('Class Timetable'), findsOneWidget);
    expect(find.text('Tests Timetable'), findsOneWidget);
    expect(find.text('Exam Timetable'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('tests-timetable-option')));
    await tester.pumpAndSettle();
    expect(find.text('MY TESTS TIMETABLE'), findsOneWidget);
    expect(find.text('Tuesday, 31 March 2026'), findsOneWidget);
    expect(
      find.text('BIT 3102 · SYSTEMS AND NETWORK ADMINISTRATION'),
      findsOneWidget,
    );
  });

  testWidgets('class and exam types display their matching schedule data', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: TimetableScreen(type: TimetableType.classSchedule),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('PERSONAL TIMETABLE'), findsOneWidget);
    expect(find.text('Monday'), findsWidgets);
    expect(find.text('07:30 PM–09:30 PM'), findsOneWidget);
    expect(find.text('Lab 5'), findsWidgets);

    await tester.pumpWidget(
      const MaterialApp(home: TimetableScreen(type: TimetableType.exams)),
    );
    await tester.pumpAndSettle();
    expect(find.text('MY EXAM TIMETABLE'), findsOneWidget);
    expect(find.text('Monday, 08 June 2026'), findsOneWidget);
    expect(find.text('Main Hall'), findsOneWidget);
  });

  testWidgets('study system controls the available academic terms', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(
        home: TimetableScreen(type: TimetableType.classSchedule),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Semester 2'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('study-system-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quarter').last);
    await tester.pumpAndSettle();

    expect(find.text('Quarter 1'), findsOneWidget);
    expect(find.text('Semester 2'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('academic-term-selector')));
    await tester.pumpAndSettle();
    expect(find.text('Quarter 4'), findsOneWidget);
    await tester.tap(find.text('Quarter 3').last);
    await tester.pumpAndSettle();
    expect(find.text('Quarter 3'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('academic-year-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2024/2025').last);
    await tester.pumpAndSettle();
    expect(find.text('2024/2025'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('timetable remains overflow-free on small phones and tablets', (
    tester,
  ) async {
    for (final size in const [Size(320, 700), Size(900, 1000)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(size),
          home: const TimetableScreen(type: TimetableType.classSchedule),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('PERSONAL TIMETABLE'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tester.binding.setSurfaceSize(null);
  });
}
