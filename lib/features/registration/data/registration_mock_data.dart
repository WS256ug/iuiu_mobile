/// One semester registration displayed in the Registration Centre.
class RegistrationRecord {
  const RegistrationRecord({
    required this.academicYear,
    required this.semester,
    required this.status,
    required this.studyYear,
    required this.residence,
    required this.examCardStatus,
  });

  final String academicYear;
  final int semester;
  final String status;
  final int studyYear;
  final String residence;
  final String examCardStatus;
}

/// One course unit displayed for a selected semester.
class CourseUnit {
  const CourseUnit({
    required this.code,
    required this.title,
    required this.creditUnits,
  });

  final String code;
  final String title;
  final double creditUnits;
}

/// Local data used until the registration API is connected.
abstract final class RegistrationMockData {
  static const List<RegistrationRecord> registrations = [
    RegistrationRecord(
      academicYear: '2025/2026',
      semester: 2,
      status: 'Registered',
      studyYear: 3,
      residence: 'Non Resident',
      examCardStatus: 'Card Printed',
    ),
    RegistrationRecord(
      academicYear: '2025/2026',
      semester: 1,
      status: 'Registered Late',
      studyYear: 3,
      residence: 'Non Resident',
      examCardStatus: 'Card Printed',
    ),
    RegistrationRecord(
      academicYear: '2024/2025',
      semester: 2,
      status: 'Registered',
      studyYear: 2,
      residence: 'Non Resident',
      examCardStatus: 'Card Printed',
    ),
  ];

  static const List<CourseUnit> regularCourseUnits = [
    CourseUnit(
      code: 'BIT 3202',
      title: 'Business Intelligence and Data Warehousing',
      creditUnits: 4,
    ),
    CourseUnit(
      code: 'BIT 3115',
      title: 'Data and Information Security',
      creditUnits: 4,
    ),
    CourseUnit(
      code: 'BIT 3104',
      title: 'IT Ethics and Professionalism',
      creditUnits: 3,
    ),
    CourseUnit(code: 'IQR 1101', title: 'Quran Recitation', creditUnits: 0),
    CourseUnit(
      code: 'BIT 3102',
      title: 'Systems and Network Administration',
      creditUnits: 4,
    ),
    CourseUnit(
      code: 'BIT 3209',
      title: 'Technopreneurship and E-Commerce',
      creditUnits: 4,
    ),
  ];

  static const List<CourseUnit> retakeCourseUnits = [];
}
