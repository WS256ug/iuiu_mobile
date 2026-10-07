import 'package:flutter_test/flutter_test.dart';
import 'package:iuiu_mobile/core/utils/app_formatters.dart';

void main() {
  group('AppFormatters.greetingFor', () {
    test('uses morning before noon', () {
      expect(
        AppFormatters.greetingFor(DateTime(2026, 1, 1, 11, 59)),
        'Good Morning',
      );
    });

    test('uses afternoon from noon until 5 PM', () {
      expect(
        AppFormatters.greetingFor(DateTime(2026, 1, 1, 12)),
        'Good Afternoon',
      );
      expect(
        AppFormatters.greetingFor(DateTime(2026, 1, 1, 16, 59)),
        'Good Afternoon',
      );
    });

    test('uses evening from 5 PM', () {
      expect(
        AppFormatters.greetingFor(DateTime(2026, 1, 1, 17)),
        'Good Evening',
      );
    });
  });

  test('wholeNumber adds thousands separators', () {
    expect(AppFormatters.wholeNumber(149940), '149,940');
    expect(AppFormatters.wholeNumber(1040325), '1,040,325');
    expect(AppFormatters.wholeNumber(-650000), '-650,000');
  });
}
