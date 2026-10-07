import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iuiu_mobile/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('shows the supplied student and time-aware greeting', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeScreen(
            studentName: 'API Student',
            currentTime: DateTime(2026, 1, 1, 14),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Good Afternoon,'), findsOneWidget);
    expect(find.text('API Student'), findsOneWidget);
    expect(find.text('View all'), findsNothing);
    expect(find.byIcon(Icons.wb_sunny_outlined), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('uses a night icon for an evening greeting', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: HomeScreen(currentTime: DateTime(2026, 1, 1, 19))),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Good Evening,'), findsOneWidget);
    expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
    expect(find.byIcon(Icons.wb_sunny_outlined), findsNothing);

    await tester.binding.setSurfaceSize(null);
  });
}
