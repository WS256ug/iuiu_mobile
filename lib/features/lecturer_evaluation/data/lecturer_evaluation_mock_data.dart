import '../models/lecturer_evaluation.dart';

/// Local Lecturer Evaluation content transcribed from the supplied references.
abstract final class LecturerEvaluationMockData {
  static const List<EvaluationPeriod> periods = [
    EvaluationPeriod(id: '2025-2026-2', academicYear: '2025/2026', semester: 2),
  ];

  static const List<LecturerEvaluation> evaluations = [
    LecturerEvaluation(
      id: 'bit-3202-2025-2026-2',
      courseCode: 'BIT 3202',
      courseTitle: 'Business Intelligence and Data Warehousing',
      lecturer: 'Mr.Wahab Ismael',
      periodId: '2025-2026-2',
      improvementComment: 'Excellent',
    ),
    LecturerEvaluation(
      id: 'bit-3115-2025-2026-2',
      courseCode: 'BIT 3115',
      courseTitle: 'Data and Information Security',
      lecturer: 'Mr. Walusimbi Hakim',
      periodId: '2025-2026-2',
      improvementComment: '-Very Good',
    ),
    LecturerEvaluation(
      id: 'bit-3104-2025-2026-2',
      courseCode: 'BIT 3104',
      courseTitle: 'IT Ethics and Professionalism',
      lecturer: 'Ms. Nassaanga Sharifah',
      periodId: '2025-2026-2',
      improvementComment: '-good',
    ),
    LecturerEvaluation(
      id: 'iqr-1101-2025-2026-2',
      courseCode: 'IQR 1101',
      courseTitle: 'Quran Recitation',
      lecturer: '-',
      periodId: '2025-2026-2',
    ),
  ];

  static const List<EvaluationQuestion> questions = [
    EvaluationQuestion(
      id: 'punctual',
      prompt: 'Always punctual for lectures',
      currentScore: 5,
    ),
    EvaluationQuestion(
      id: 'starts-first-week',
      prompt: 'Starts lectures in the first week of the semester',
      currentScore: 5,
    ),
    EvaluationQuestion(
      id: 'prepared',
      prompt: 'Is always prepared for lectures',
      currentScore: 5,
    ),
    EvaluationQuestion(
      id: 'course-outline',
      prompt: 'Gives out the course outline',
      currentScore: 5,
    ),
    EvaluationQuestion(
      id: 'learning-outcomes',
      prompt: 'Clearly explains the learning outcomes of the course unit',
      currentScore: 5,
    ),
    EvaluationQuestion(
      id: 'subject-matter',
      prompt: 'Adequately explains the subject matter',
      currentScore: 5,
    ),
    EvaluationQuestion(
      id: 'coursework-timing',
      prompt: 'Gives a Coursework test/assignment in time',
      currentScore: 5,
    ),
    EvaluationQuestion(
      id: 'coursework-outcomes',
      prompt: 'The course work tests are in line with the learning outcomes',
      currentScore: 5,
    ),
    EvaluationQuestion(
      id: 'student-participation',
      prompt:
          'Provides opportunities for student’s participation or involvement '
          'during lectures',
      currentScore: 5,
    ),
    EvaluationQuestion(
      id: 'audible',
      prompt: 'Is audible enough when explaining in lectures',
      currentScore: 5,
    ),
    EvaluationQuestion(
      id: 'consultation',
      prompt: 'Always available for academic consultation.',
      currentScore: 5,
    ),
    EvaluationQuestion(
      id: 'covered-content',
      prompt:
          'Sets questions that are in line with what was covered during '
          'lectures.',
      currentScore: 5,
    ),
    EvaluationQuestion(
      id: 'returns-results',
      prompt: 'Returned the Coursework/Continuous Assessment results returned?',
      currentScore: 5,
    ),
  ];
}
