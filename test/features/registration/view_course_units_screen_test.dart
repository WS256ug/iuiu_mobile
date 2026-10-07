import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iuiu_mobile/features/registration/data/registration_mock_data.dart';
import 'package:iuiu_mobile/features/registration/presentation/view_course_units_screen.dart';

void main() {
  testWidgets('course actions remain matched on phones and tablets', (
    tester,
  ) async {
    for (final size in const [Size(320, 700), Size(800, 1000)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(size),
          home: MediaQuery(
            data: MediaQueryData(
              size: size,
              textScaler: const TextScaler.linear(1.3),
            ),
            child: ViewCourseUnitsScreen(
              registration: RegistrationMockData.registrations.first,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final addButton = tester.getSize(
        find.byKey(const ValueKey('add-course-units-action')),
      );
      final facultyButton = tester.getSize(
        find.byKey(const ValueKey('faculty-registration-action')),
      );

      expect(addButton.width, facultyButton.width);
      expect(addButton.height, 68);
      expect(facultyButton.height, 68);

      await tester.tap(find.text('Retake Courses'));
      await tester.pumpAndSettle();

      final retakeFinder = find.byKey(
        const ValueKey('add-retake-course-units-action'),
      );
      final retakeButton = tester.getSize(retakeFinder);
      final retakeButtonCenter = tester.getCenter(retakeFinder);

      expect(retakeButton.width, addButton.width);
      expect(retakeButton.height, 68);
      expect(retakeButtonCenter.dx, closeTo(size.width / 2, 0.01));
      expect(tester.takeException(), isNull);
    }

    await tester.binding.setSurfaceSize(null);
  });
}
