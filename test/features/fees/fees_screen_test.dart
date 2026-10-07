import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iuiu_mobile/features/fees/presentation/fees_screen.dart';
import 'package:iuiu_mobile/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('Home Fees Info opens the payment ledger', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: HomeScreen(currentTime: DateTime(2026, 1, 1, 14))),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Fees Info'));
    await tester.pumpAndSettle();

    expect(find.text('FEES PAYMENT LEDGER'), findsOneWidget);
    expect(find.text('CURRENT BALANCE: 149,940 DR'), findsOneWidget);
    expect(find.text('1,040,325'), findsWidgets);
    expect(find.text('700,000'), findsOneWidget);
    expect(find.textContaining('STANBIC BANK · TNo: 18916226'), findsOneWidget);
  });

  testWidgets('SchoolPay action gives local integration feedback', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: FeesScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('pay-fees-button')));
    await tester.pump();
    expect(
      find.text('SchoolPay fees payment will be available soon.'),
      findsOneWidget,
    );
  });

  testWidgets('fee ledger remains overflow-free on phones and tablets', (
    tester,
  ) async {
    for (final size in const [Size(320, 700), Size(900, 1000)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(key: ValueKey(size), home: const FeesScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('CURRENT BALANCE: 149,940 DR'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tester.binding.setSurfaceSize(null);
  });
}
