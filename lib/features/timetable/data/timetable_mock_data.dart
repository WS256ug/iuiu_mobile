import '../models/timetable.dart';

/// Replaceable local timetable content used before API integration.
abstract final class TimetableMockData {
  static const List<String> academicYears = [
    '2026/2027',
    '2025/2026',
    '2024/2025',
  ];

  static const TimetablePeriod classPeriod = TimetablePeriod(
    studySystem: 'Semester',
    academicYear: '2025/2026',
    semester: 'Semester 2',
  );

  static const TimetablePeriod assessmentPeriod = TimetablePeriod(
    studySystem: 'Semester',
    academicYear: '2026/2027',
    semester: 'Semester 2',
  );

  static const String programme =
      'Bachelor of Information Technology 3 (Evening)';

  static const List<TimetableEntry> classEntries = [
    TimetableEntry(
      id: 'class-bit-3102-monday',
      courseCode: 'BIT 3102',
      courseTitle: 'Systems and Network Administration',
      programme: programme,
      dayOrDate: 'Monday',
      time: '07:30 PM–09:30 PM',
      venue: 'Lab 5',
      lecturer: 'Mr. Seguya Asad',
      engagement: 'Full time',
    ),
    TimetableEntry(
      id: 'class-bit-3209-monday',
      courseCode: 'BIT 3209',
      courseTitle: 'Technopreneurship and E-Commerce',
      programme: programme,
      dayOrDate: 'Monday',
      time: '05:00 PM–09:00 PM',
      venue: 'Venue pending',
      lecturer: 'Matovu Moses',
      engagement: 'Part time',
    ),
    TimetableEntry(
      id: 'class-bit-3102-tuesday',
      courseCode: 'BIT 3102',
      courseTitle: 'Systems and Network Administration',
      programme: programme,
      dayOrDate: 'Tuesday',
      time: '05:00 PM–07:00 PM',
      venue: 'Lab 5',
      lecturer: 'Mr. Seguya Asad',
      engagement: 'Full time',
    ),
    TimetableEntry(
      id: 'class-bit-3104-wednesday',
      courseCode: 'BIT 3104',
      courseTitle: 'IT Ethics and Professionalism',
      programme: programme,
      dayOrDate: 'Wednesday',
      time: '04:00 PM–07:00 PM',
      venue: 'Venue pending',
      lecturer: 'Ms. Nassanga Sharifah',
      engagement: 'Full time',
    ),
    TimetableEntry(
      id: 'class-bit-3202-thursday',
      courseCode: 'BIT 3202',
      courseTitle: 'Business Intelligence and Data Warehousing',
      programme: programme,
      dayOrDate: 'Thursday',
      time: '05:00 PM–09:00 PM',
      venue: 'Lab 5',
      lecturer: 'Mr. Wahab Ismael',
      engagement: 'Extra load',
    ),
    TimetableEntry(
      id: 'class-iqr-1101-thursday',
      courseCode: 'IQR 1101',
      courseTitle: 'Quran Recitation',
      programme: programme,
      dayOrDate: 'Thursday',
      time: '02:00 PM–04:00 PM',
      venue: 'Room A2',
      lecturer: 'To be assigned',
      engagement: 'Part time',
    ),
  ];

  static const List<TimetableEntry> testEntries = [
    TimetableEntry(
      id: 'test-bit-3102',
      courseCode: 'BIT 3102',
      courseTitle: 'Systems and Network Administration',
      dayOrDate: 'Tuesday, 31 March 2026',
      time: '05:30 PM–06:30 PM',
      venue: 'Venue pending',
      lecturer: 'Mr. Seguya Asad',
      engagement: 'Full time',
    ),
    TimetableEntry(
      id: 'test-bit-3104',
      courseCode: 'BIT 3104',
      courseTitle: 'IT Ethics and Professionalism',
      dayOrDate: 'Wednesday, 01 April 2026',
      time: '05:30 PM–06:30 PM',
      venue: 'Venue pending',
      lecturer: 'Ms. Nassanga Sharifah',
      engagement: 'Full time',
    ),
    TimetableEntry(
      id: 'test-bit-3202',
      courseCode: 'BIT 3202',
      courseTitle: 'Business Intelligence and Data Warehousing',
      dayOrDate: 'Thursday, 02 April 2026',
      time: '05:00 PM–07:00 PM',
      venue: 'Venue pending',
      lecturer: 'Mr. Wahab Ismael',
      engagement: 'Full time',
    ),
    TimetableEntry(
      id: 'test-bit-3115',
      courseCode: 'BIT 3115',
      courseTitle: 'Data and Information Security',
      dayOrDate: 'Saturday, 04 April 2026',
      time: '10:00 AM–11:00 AM',
      venue: 'Main Hall',
      lecturer: 'Dr. Nakkazi Rukia',
      engagement: 'Full time',
    ),
  ];

  static const List<TimetableEntry> examEntries = [
    TimetableEntry(
      id: 'exam-bit-3102',
      courseCode: 'BIT 3102',
      courseTitle: 'Systems and Network Administration',
      dayOrDate: 'Monday, 08 June 2026',
      time: '09:00 AM–12:00 PM',
      venue: 'Main Hall',
      lecturer: 'Mr. Seguya Asad',
      engagement: 'Final examination',
    ),
    TimetableEntry(
      id: 'exam-bit-3104',
      courseCode: 'BIT 3104',
      courseTitle: 'IT Ethics and Professionalism',
      dayOrDate: 'Wednesday, 10 June 2026',
      time: '02:00 PM–05:00 PM',
      venue: 'Block B · Room 4',
      lecturer: 'Ms. Nassanga Sharifah',
      engagement: 'Final examination',
    ),
    TimetableEntry(
      id: 'exam-bit-3202',
      courseCode: 'BIT 3202',
      courseTitle: 'Business Intelligence and Data Warehousing',
      dayOrDate: 'Friday, 12 June 2026',
      time: '09:00 AM–12:00 PM',
      venue: 'Computer Lab 2',
      lecturer: 'Mr. Wahab Ismael',
      engagement: 'Final examination',
    ),
  ];
}
