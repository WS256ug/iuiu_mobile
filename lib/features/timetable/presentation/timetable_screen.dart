import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../data/timetable_mock_data.dart';
import '../models/timetable.dart';

/// Opens the timetable type selector, then navigates to the chosen schedule.
Future<void> openTimetablePicker(BuildContext context) async {
  final type = await showModalBottomSheet<TimetableType>(
    context: context,
    showDragHandle: true,
    builder: (_) => const _TimetableTypeSheet(),
  );
  if (type == null || !context.mounted) return;
  Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => TimetableScreen(type: type)));
}

/// Displays one responsive class, tests, or exam timetable.
class TimetableScreen extends StatefulWidget {
  const TimetableScreen({
    required this.type,
    this.period,
    this.entries,
    super.key,
  });

  final TimetableType type;
  final TimetablePeriod? period;
  final List<TimetableEntry>? entries;

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

/// Remembers the selected period, study system, day, and timetable type.
class _TimetableScreenState extends State<TimetableScreen> {
  static const _studySystems = ['Semester', 'Quarter'];
  static const _semesterTerms = ['Semester 1', 'Semester 2'];
  static const _quarterTerms = [
    'Quarter 1',
    'Quarter 2',
    'Quarter 3',
    'Quarter 4',
  ];

  late String _studySystem;
  late String _academicYear;
  late String _selectedTerm;

  TimetablePeriod get _initialPeriod =>
      widget.period ??
      (widget.type == TimetableType.classSchedule
          ? TimetableMockData.classPeriod
          : TimetableMockData.assessmentPeriod);

  @override
  void initState() {
    super.initState();
    _studySystem = _initialPeriod.studySystem;
    _academicYear = _initialPeriod.academicYear;
    _selectedTerm = _initialPeriod.semester;
  }

  String get _screenTitle => switch (widget.type) {
    TimetableType.classSchedule => 'Class Timetable',
    TimetableType.tests => 'Tests Timetable',
    TimetableType.exams => 'Exam Timetable',
  };

  String get _heading => switch (widget.type) {
    TimetableType.classSchedule => 'PERSONAL TIMETABLE',
    TimetableType.tests => 'MY TESTS TIMETABLE',
    TimetableType.exams => 'MY EXAM TIMETABLE',
  };

  List<TimetableEntry> get _entries =>
      widget.entries ??
      switch (widget.type) {
        TimetableType.classSchedule => TimetableMockData.classEntries,
        TimetableType.tests => TimetableMockData.testEntries,
        TimetableType.exams => TimetableMockData.examEntries,
      };

  List<String> get _termOptions =>
      _studySystem == 'Semester' ? _semesterTerms : _quarterTerms;

  /// Changes study system and resets the day to one available in that system.
  void _changeStudySystem(String value) {
    setState(() {
      _studySystem = value;
      _selectedTerm = value == 'Semester'
          ? _semesterTerms.first
          : _quarterTerms.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AppTopBar(title: _screenTitle, showBackButton: true),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 760 ? 2 : 1;
                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppConstants.pagePadding,
                          20,
                          AppConstants.pagePadding,
                          12,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 960),
                              child: Column(
                                children: [
                                  Text(
                                    _heading,
                                    style: AppTextStyles.screenHeading,
                                  ),
                                  const SizedBox(height: 14),
                                  _PeriodCard(
                                    studySystem: _studySystem,
                                    academicYear: _academicYear,
                                    selectedTerm: _selectedTerm,
                                    studySystems: _studySystems,
                                    academicYears: {
                                      _academicYear,
                                      ...TimetableMockData.academicYears,
                                    }.toList(),
                                    termOptions: _termOptions,
                                    onStudySystemChanged: _changeStudySystem,
                                    onAcademicYearChanged: (value) =>
                                        setState(() => _academicYear = value),
                                    onTermChanged: (value) =>
                                        setState(() => _selectedTerm = value),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppConstants.pagePadding,
                          2,
                          AppConstants.pagePadding,
                          28,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent:
                                    widget.type == TimetableType.classSchedule
                                    ? 228
                                    : 225,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                _TimetableCard(entry: _entries[index]),
                            childCount: _entries.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Groups year, semester, study-system, and day selectors.
class _PeriodCard extends StatelessWidget {
  const _PeriodCard({
    required this.studySystem,
    required this.academicYear,
    required this.selectedTerm,
    required this.studySystems,
    required this.academicYears,
    required this.termOptions,
    required this.onStudySystemChanged,
    required this.onAcademicYearChanged,
    required this.onTermChanged,
  });

  final String studySystem;
  final String academicYear;
  final String selectedTerm;
  final List<String> studySystems;
  final List<String> academicYears;
  final List<String> termOptions;
  final ValueChanged<String> onStudySystemChanged;
  final ValueChanged<String> onAcademicYearChanged;
  final ValueChanged<String> onTermChanged;

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
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _PeriodSelector(
            fieldKey: const ValueKey('study-system-selector'),
            icon: Icons.school_outlined,
            label: 'Study System',
            value: studySystem,
            options: studySystems,
            onChanged: onStudySystemChanged,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PeriodSelector(
                  fieldKey: const ValueKey('academic-year-selector'),
                  icon: Icons.calendar_today_outlined,
                  label: 'Academic Year',
                  value: academicYear,
                  options: academicYears,
                  onChanged: onAcademicYearChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PeriodSelector(
                  fieldKey: const ValueKey('academic-term-selector'),
                  icon: Icons.view_timeline_outlined,
                  label: studySystem,
                  value: selectedTerm,
                  options: termOptions,
                  onChanged: onTermChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Draws one labelled timetable dropdown with readable values.
class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.fieldKey,
    required this.icon,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final Key fieldKey;
  final IconData icon;
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.supporting),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 19),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    key: fieldKey,
                    value: value,
                    isExpanded: true,
                    isDense: true,
                    borderRadius: BorderRadius.circular(
                      AppConstants.smallRadius,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 19,
                    ),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                    items: options
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(
                              option,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (nextValue) {
                      if (nextValue != null) onChanged(nextValue);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Displays one class, test, or exam event and its location details.
class _TimetableCard extends StatelessWidget {
  const _TimetableCard({required this.entry});

  final TimetableEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('timetable-entry-${entry.id}'),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${entry.courseCode} · ${entry.courseTitle}'.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 10),
          Container(height: 2, color: AppColors.primary),
          if (entry.programme != null) ...[
            const SizedBox(height: 9),
            Text(
              entry.programme!.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ],
          const SizedBox(height: 11),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.pageBackground,
                borderRadius: BorderRadius.circular(AppConstants.smallRadius),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.dayOrDate,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          entry.time,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(entry.venue, style: AppTextStyles.supporting),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          entry.lecturer,
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Spacer(),
                        Text(
                          entry.engagement.toUpperCase(),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lets the student choose classes, tests, or examinations.
class _TimetableTypeSheet extends StatelessWidget {
  const _TimetableTypeSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select timetable type',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose the schedule you want to view.',
              style: AppTextStyles.supporting,
            ),
            const SizedBox(height: 16),
            _TypeOption(
              key: const ValueKey('class-timetable-option'),
              type: TimetableType.classSchedule,
              icon: Icons.menu_book_outlined,
              title: 'Class Timetable',
              subtitle: 'Weekly lectures and class venues',
            ),
            const SizedBox(height: 10),
            _TypeOption(
              key: const ValueKey('tests-timetable-option'),
              type: TimetableType.tests,
              icon: Icons.assignment_outlined,
              title: 'Tests Timetable',
              subtitle: 'Upcoming continuous assessment tests',
            ),
            const SizedBox(height: 10),
            _TypeOption(
              key: const ValueKey('exam-timetable-option'),
              type: TimetableType.exams,
              icon: Icons.fact_check_outlined,
              title: 'Exam Timetable',
              subtitle: 'Final examination dates and venues',
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws one timetable category choice inside the selector sheet.
class _TypeOption extends StatelessWidget {
  const _TypeOption({
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final TimetableType type;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.pageBackground,
      borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(type),
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 3),
                    Text(subtitle, style: AppTextStyles.supporting),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
