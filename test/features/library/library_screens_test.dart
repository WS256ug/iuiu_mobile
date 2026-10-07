import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iuiu_mobile/features/library/presentation/library_screens.dart';
import 'package:iuiu_mobile/features/services/presentation/services_screen.dart';

void main() {
  testWidgets('Library Centre opens digital resources through its selector', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ServicesScreen())),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'library');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Library Centre'));
    await tester.pumpAndSettle();

    expect(find.text('View Profile'), findsOneWidget);
    expect(find.text('Digital Library'), findsOneWidget);
    expect(find.text('Search Catalog'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('digital-library-option')));
    await tester.pumpAndSettle();
    expect(find.text('IUIU MOBILE DIGITAL LIBRARY'), findsOneWidget);
    expect(find.text('100,000+'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('library-category-law-library')),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('LAW LIBRARY'), findsOneWidget);
    expect(find.text('1957 EAST AFRICA LAW REPORTS'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('resource-search-field')),
      '1959',
    );
    await tester.pump();
    expect(find.text('1959 EAST AFRICA LAW REPORTS'), findsOneWidget);
    expect(find.text('1957 EAST AFRICA LAW REPORTS'), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('download-east-africa-law-reports-1959')),
    );
    await tester.pump();
    expect(
      find.text('Resource download will be available soon.'),
      findsOneWidget,
    );
  });

  testWidgets('profile and catalog expose relevant local library data', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: LibraryProfileScreen()));
    await tester.pumpAndSettle();
    expect(find.text('WASSWA SWALLEH'), findsOneWidget);
    expect(find.text('Computer Networks'), findsOneWidget);
    expect(find.text('UGX 0'), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: CatalogSearchScreen()));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('catalog-search-field')),
      'Clean Code',
    );
    await tester.pump();
    expect(find.text('Clean Code'), findsWidgets);
    expect(find.text('Available'), findsOneWidget);
    expect(find.text('Database System Concepts'), findsNothing);
  });

  testWidgets('digital library remains responsive on phones and tablets', (
    tester,
  ) async {
    for (final size in const [Size(320, 700), Size(900, 1000)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(key: ValueKey(size), home: const DigitalLibraryScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('IUIU MOBILE DIGITAL LIBRARY'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tester.binding.setSurfaceSize(null);
  });
}
