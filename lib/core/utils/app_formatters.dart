/// Contains small formatting helpers that do not need external packages.
abstract final class AppFormatters {
  /// Returns a greeting appropriate for the supplied local time.
  static String greetingFor(DateTime localTime) {
    if (localTime.hour < 12) {
      return 'Good Morning';
    }
    if (localTime.hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  /// Creates initials for simple avatar placeholders.
  static String initials(String name) {
    return name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();
  }

  /// Adds thousands separators to whole-number monetary values.
  static String wholeNumber(int value) {
    final digits = value.abs().toString();
    final buffer = StringBuffer(value.isNegative ? '-' : '');
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[index]);
    }
    return buffer.toString();
  }
}
