/// One final examination result for a registered course.
/// Stores the final mark, grade, and credits for one completed course.
class CourseResult {
  const CourseResult({
    required this.id,
    required this.courseCode,
    required this.courseTitle,
    required this.creditUnits,
    required this.score,
    required this.grade,
    required this.gradePoint,
  });

  final String id;
  final String courseCode;
  final String courseTitle;
  final int creditUnits;
  final int score;
  final String grade;
  final double gradePoint;
}

/// Coursework components shown separately from final examination results.
/// Stores the continuous-assessment marks shown before final results.
class CourseworkResult {
  const CourseworkResult({
    required this.id,
    required this.courseCode,
    required this.courseTitle,
    required this.assignmentScore,
    required this.testScore,
    required this.total,
  });

  final String id;
  final String courseCode;
  final String courseTitle;
  final int assignmentScore;
  final int testScore;
  final int total;
}

/// Results and summary values for one academic period.
/// Groups all result information for one academic year and semester.
class AcademicResultPeriod {
  const AcademicResultPeriod({
    required this.id,
    required this.year,
    required this.semester,
    required this.gpa,
    required this.cgpa,
    required this.classification,
    required this.courseResults,
    required this.courseworkResults,
  });

  final String id;
  final int year;
  final int semester;
  final double gpa;
  final double cgpa;
  final String classification;
  final List<CourseResult> courseResults;
  final List<CourseworkResult> courseworkResults;
}
