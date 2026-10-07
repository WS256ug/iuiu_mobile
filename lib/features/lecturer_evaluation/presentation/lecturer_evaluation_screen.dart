import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../data/lecturer_evaluation_mock_data.dart';
import '../models/lecturer_evaluation.dart';
import 'lecturer_evaluation_details_screen.dart';

/// Displays lecturer evaluations for a selected academic year and semester.
class LecturerEvaluationScreen extends StatefulWidget {
  const LecturerEvaluationScreen({
    this.periods = LecturerEvaluationMockData.periods,
    this.evaluations = LecturerEvaluationMockData.evaluations,
    super.key,
  });

  final List<EvaluationPeriod> periods;
  final List<LecturerEvaluation> evaluations;

  @override
  State<LecturerEvaluationScreen> createState() =>
      _LecturerEvaluationScreenState();
}

/// Remembers the chosen period and derives the lecturers visible for it.
class _LecturerEvaluationScreenState extends State<LecturerEvaluationScreen> {
  String? _selectedYear;
  int? _selectedSemester;

  @override
  void initState() {
    super.initState();
    if (widget.periods.isNotEmpty) {
      _selectedYear = widget.periods.first.academicYear;
      _selectedSemester = widget.periods.first.semester;
    }
  }

  List<String> get _academicYears => [
    ...{for (final period in widget.periods) period.academicYear},
  ];

  List<int> get _semesters => [
    ...{
      for (final period in widget.periods)
        if (period.academicYear == _selectedYear) period.semester,
    },
  ];

  EvaluationPeriod? get _selectedPeriod {
    for (final period in widget.periods) {
      if (period.academicYear == _selectedYear &&
          period.semester == _selectedSemester) {
        return period;
      }
    }
    return null;
  }

  List<LecturerEvaluation> get _visibleEvaluations {
    final period = _selectedPeriod;
    if (period == null) return const [];
    return widget.evaluations
        .where((evaluation) => evaluation.periodId == period.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final evaluations = _visibleEvaluations;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Column(
        children: [
          const AppTopBar(title: 'Lecturer Evaluation', showBackButton: true),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.pagePadding,
                    22,
                    AppConstants.pagePadding,
                    28,
                  ),
                  children: [
                    const _EvaluationHeading(),
                    const SizedBox(height: 18),
                    if (widget.periods.isEmpty)
                      const _NoEvaluationPeriods()
                    else ...[
                      _PeriodSelectorCard(
                        academicYears: _academicYears,
                        selectedYear: _selectedYear!,
                        semesters: _semesters,
                        selectedSemester: _selectedSemester!,
                        onYearChanged: _selectYear,
                        onSemesterChanged: (semester) {
                          setState(() => _selectedSemester = semester);
                        },
                      ),
                      const SizedBox(height: 18),
                      const _ConfidentialityNotice(),
                      const SizedBox(height: 18),
                      if (evaluations.isEmpty)
                        const _NoLecturers()
                      else
                        ...evaluations.map(
                          (evaluation) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _EvaluationCard(
                              evaluation: evaluation,
                              onTap: () => _openEvaluation(evaluation),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Changes year and selects its first available semester automatically.
  void _selectYear(String academicYear) {
    final periodsForYear = widget.periods.where(
      (period) => period.academicYear == academicYear,
    );
    setState(() {
      _selectedYear = academicYear;
      _selectedSemester = periodsForYear.first.semester;
    });
  }

  /// Opens the questionnaire for the lecturer card the student selected.
  void _openEvaluation(LecturerEvaluation evaluation) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LecturerEvaluationDetailsScreen(evaluation: evaluation),
      ),
    );
  }
}

/// Introduces the lecturer-evaluation area above its filters.
class _EvaluationHeading extends StatelessWidget {
  const _EvaluationHeading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.star_outline, color: AppColors.primary, size: 34),
        SizedBox(height: 8),
        Text(
          'MY LECTURER EVALUATION',
          textAlign: TextAlign.center,
          style: AppTextStyles.screenHeading,
        ),
      ],
    );
  }
}

/// Places year and semester selectors in one consistent white card.
class _PeriodSelectorCard extends StatelessWidget {
  const _PeriodSelectorCard({
    required this.academicYears,
    required this.selectedYear,
    required this.semesters,
    required this.selectedSemester,
    required this.onYearChanged,
    required this.onSemesterChanged,
  });

  final List<String> academicYears;
  final String selectedYear;
  final List<int> semesters;
  final int selectedSemester;
  final ValueChanged<String> onYearChanged;
  final ValueChanged<int> onSemesterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _PeriodDropdown<String>(
              key: const ValueKey('evaluation-year-selector'),
              label: 'YEAR',
              value: selectedYear,
              items: academicYears,
              itemLabel: (year) => year,
              onChanged: onYearChanged,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _PeriodDropdown<int>(
              key: const ValueKey('evaluation-semester-selector'),
              label: 'SEMESTER',
              value: selectedSemester,
              items: semesters,
              itemLabel: (semester) => 'Semester $semester',
              onChanged: onSemesterChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable labelled dropdown for either a year or semester value.
class _PeriodDropdown<T> extends StatelessWidget {
  const _PeriodDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    super.key,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          isDense: true,
          style: AppTextStyles.cardTitle.copyWith(color: AppColors.textPrimary),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item), overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (selection) {
            if (selection != null) onChanged(selection);
          },
        ),
      ),
    );
  }
}

/// Reassures students that their evaluation answers remain confidential.
class _ConfidentialityNotice extends StatelessWidget {
  const _ConfidentialityNotice();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'NB: Your evaluation is totally confidential and is not visible to any '
      'other individual',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.red,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        height: 1.35,
      ),
    );
  }
}

/// Summarizes a lecturer/course and opens its questionnaire when tapped.
class _EvaluationCard extends StatelessWidget {
  const _EvaluationCard({required this.evaluation, required this.onTap});

  final LecturerEvaluation evaluation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: ValueKey('lecturer-evaluation-${evaluation.id}'),
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      '${evaluation.courseCode} - ${evaluation.courseTitle}',
                      style: AppTextStyles.cardTitle.copyWith(height: 1.25),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const Divider(height: 24, color: AppColors.primaryLight),
              Text(
                'BY: ${evaluation.lecturer}',
                style: AppTextStyles.cardTitle.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 18),
              const Text('EVALUATION STATUS', style: AppTextStyles.fieldLabel),
              if (evaluation.status case final status?) ...[
                const SizedBox(height: 5),
                Text(status, style: AppTextStyles.bodyValue),
              ],
              if (evaluation.improvementComment case final comment?) ...[
                const SizedBox(height: 18),
                const Text(
                  'IMPROVEMENT COMMENT',
                  style: AppTextStyles.fieldLabel,
                ),
                const SizedBox(height: 5),
                Text(comment, style: AppTextStyles.bodyValue),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Explains that the selected period has no lecturers to evaluate.
class _NoLecturers extends StatelessWidget {
  const _NoLecturers();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.person_search_outlined,
            color: AppColors.textSecondary,
            size: 48,
          ),
          SizedBox(height: 12),
          Text('No lecturers found', style: AppTextStyles.cardTitle),
          SizedBox(height: 5),
          Text(
            'No lecturers are available for the selected period.',
            textAlign: TextAlign.center,
            style: AppTextStyles.supporting,
          ),
        ],
      ),
    );
  }
}

/// Explains that no academic periods are currently available.
class _NoEvaluationPeriods extends StatelessWidget {
  const _NoEvaluationPeriods();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: AppColors.textSecondary,
            size: 48,
          ),
          SizedBox(height: 12),
          Text('No evaluation periods', style: AppTextStyles.cardTitle),
          SizedBox(height: 5),
          Text(
            'Evaluation periods will appear here when available.',
            textAlign: TextAlign.center,
            style: AppTextStyles.supporting,
          ),
        ],
      ),
    );
  }
}
