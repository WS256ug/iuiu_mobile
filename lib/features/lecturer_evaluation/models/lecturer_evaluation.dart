/// One academic period displayed on the Lecturer Evaluation screen.
class EvaluationPeriod {
  const EvaluationPeriod({
    required this.id,
    required this.academicYear,
    required this.semester,
  });

  final String id;
  final String academicYear;
  final int semester;
}

/// One course and lecturer available for evaluation.
class LecturerEvaluation {
  const LecturerEvaluation({
    required this.id,
    required this.courseCode,
    required this.courseTitle,
    required this.lecturer,
    required this.periodId,
    this.status,
    this.improvementComment,
  });

  final String id;
  final String courseCode;
  final String courseTitle;
  final String lecturer;
  final String periodId;
  final String? status;
  final String? improvementComment;
}

/// One scored statement in the lecturer evaluation questionnaire.
class EvaluationQuestion {
  const EvaluationQuestion({
    required this.id,
    required this.prompt,
    required this.currentScore,
  });

  final String id;
  final String prompt;
  final int currentScore;
}
