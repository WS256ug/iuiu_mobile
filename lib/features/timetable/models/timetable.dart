/// Timetable destinations available from the service selector.
/// Lists the three timetable categories a student can open.
enum TimetableType { classSchedule, tests, exams }

/// Study-period information shown above a timetable.
/// Stores one selectable academic year and semester combination.
class TimetablePeriod {
  const TimetablePeriod({
    required this.studySystem,
    required this.academicYear,
    required this.semester,
  });

  final String studySystem;
  final String academicYear;
  final String semester;
}

/// One class, test, or examination schedule entry.
/// Stores the time, place, and course information for one schedule row.
class TimetableEntry {
  const TimetableEntry({
    required this.id,
    required this.courseCode,
    required this.courseTitle,
    required this.dayOrDate,
    required this.time,
    required this.venue,
    required this.lecturer,
    required this.engagement,
    this.programme,
  });

  final String id;
  final String courseCode;
  final String courseTitle;
  final String dayOrDate;
  final String time;
  final String venue;
  final String lecturer;
  final String engagement;
  final String? programme;
}
