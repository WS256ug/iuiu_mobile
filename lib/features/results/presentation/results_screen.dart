import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../data/results_mock_data.dart';
import '../models/academic_result.dart';

/// Displays selectable examination results and coursework records.
class ResultsScreen extends StatefulWidget {
  const ResultsScreen({this.periods = ResultsMockData.periods, super.key});

  final List<AcademicResultPeriod> periods;

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

/// Remembers the selected year, semester, and result tab.
class _ResultsScreenState extends State<ResultsScreen> {
  late int _selectedYear;
  late int _selectedSemester;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.periods.first.year;
    _selectedSemester = widget.periods.first.semester;
  }

  List<int> get _years =>
      widget.periods.map((period) => period.year).toSet().toList()..sort();

  List<int> get _semesters =>
      widget.periods
          .where((period) => period.year == _selectedYear)
          .map((period) => period.semester)
          .toSet()
          .toList()
        ..sort();

  AcademicResultPeriod get _period => widget.periods.firstWhere(
    (period) =>
        period.year == _selectedYear && period.semester == _selectedSemester,
  );

  /// Changes year and moves to its first available semester.
  void _selectYear(int year) {
    final firstSemester = widget.periods
        .firstWhere((period) => period.year == year)
        .semester;
    setState(() {
      _selectedYear = year;
      _selectedSemester = firstSemester;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppTopBar(title: 'My Results', showBackButton: true),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 760 ? 2 : 1;
                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppConstants.pagePadding,
                          18,
                          AppConstants.pagePadding,
                          14,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 960),
                              child: Column(
                                children: [
                                  _PeriodSelectors(
                                    selectedYear: _selectedYear,
                                    selectedSemester: _selectedSemester,
                                    years: _years,
                                    semesters: _semesters,
                                    onYearChanged: _selectYear,
                                    onSemesterChanged: (semester) => setState(
                                      () => _selectedSemester = semester,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  if (_selectedTab == 0)
                                    _ResultsSummary(period: _period)
                                  else
                                    _CourseworkSummary(
                                      items: _period.courseworkResults,
                                    ),
                                  const SizedBox(height: 18),
                                  Text(
                                    'YEAR $_selectedYear SEMESTER $_selectedSemester ${_selectedTab == 0 ? 'DETAILS' : 'COURSEWORK'}',
                                    style: AppTextStyles.screenHeading,
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
                          0,
                          AppConstants.pagePadding,
                          28,
                        ),
                        sliver: _selectedTab == 0
                            ? SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: columns,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      mainAxisExtent: 145,
                                    ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => _CourseResultCard(
                                    result: _period.courseResults[index],
                                  ),
                                  childCount: _period.courseResults.length,
                                ),
                              )
                            : SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: columns,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      mainAxisExtent: 155,
                                    ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => _CourseworkCard(
                                    result: _period.courseworkResults[index],
                                  ),
                                  childCount: _period.courseworkResults.length,
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) => setState(() => _selectedTab = index),
        destinations: const [
          NavigationDestination(
            key: ValueKey('exam-results-tab'),
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Exam Results',
          ),
          NavigationDestination(
            key: ValueKey('coursework-tab'),
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: 'Coursework',
          ),
        ],
      ),
    );
  }
}

/// Places the year and semester controls above the selected results.
class _PeriodSelectors extends StatelessWidget {
  const _PeriodSelectors({
    required this.selectedYear,
    required this.selectedSemester,
    required this.years,
    required this.semesters,
    required this.onYearChanged,
    required this.onSemesterChanged,
  });

  final int selectedYear;
  final int selectedSemester;
  final List<int> years;
  final List<int> semesters;
  final ValueChanged<int> onYearChanged;
  final ValueChanged<int> onSemesterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
            child: _ResultDropdown(
              fieldKey: const ValueKey('result-year-selector'),
              icon: Icons.calendar_today_outlined,
              value: selectedYear,
              items: years,
              labelBuilder: (year) => 'Year $year',
              onChanged: onYearChanged,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ResultDropdown(
              fieldKey: const ValueKey('result-semester-selector'),
              icon: Icons.view_timeline_outlined,
              value: selectedSemester,
              items: semesters,
              labelBuilder: (semester) => 'Semester $semester',
              onChanged: onSemesterChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws one labelled dropdown used by the result period controls.
class _ResultDropdown extends StatelessWidget {
  const _ResultDropdown({
    required this.fieldKey,
    required this.icon,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  final Key fieldKey;
  final IconData icon;
  final int value;
  final List<int> items;
  final String Function(int) labelBuilder;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                key: fieldKey,
                value: value,
                isExpanded: true,
                isDense: true,
                borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                items: items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          labelBuilder(item),
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
    );
  }
}

/// Summarizes GPA and credit totals for examination results.
class _ResultsSummary extends StatelessWidget {
  const _ResultsSummary({required this.period});

  final AcademicResultPeriod period;

  @override
  Widget build(BuildContext context) {
    return _SummaryCard(
      title: 'EXAMINATION RESULTS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'GPA',
                  value: period.gpa.toStringAsFixed(2),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _Metric(
                  label: 'CGPA',
                  value: period.cgpa.toStringAsFixed(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            period.classification.toUpperCase(),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

/// Summarizes average coursework performance and course count.
class _CourseworkSummary extends StatelessWidget {
  const _CourseworkSummary({required this.items});

  final List<CourseworkResult> items;

  @override
  Widget build(BuildContext context) {
    final average = items.isEmpty
        ? 0
        : items.map((item) => item.total).reduce((a, b) => a + b) /
              items.length;
    return _SummaryCard(
      title: 'COURSEWORK PERFORMANCE',
      child: _Metric(
        label: 'Average coursework mark',
        value: '${average.toStringAsFixed(1)} / 50',
      ),
    );
  }
}

/// Provides a shared white surface around one summary group.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: Column(
        children: [
          Text(title, style: AppTextStyles.screenHeading),
          const SizedBox(height: 10),
          Container(height: 2, color: AppColors.primary),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

/// Displays one short result label and its important value.
class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(text: value),
        ],
      ),
      style: const TextStyle(fontSize: 13),
    );
  }
}

/// Presents one course's final mark, grade, and credits.
class _CourseResultCard extends StatelessWidget {
  const _CourseResultCard({required this.result});

  final CourseResult result;

  @override
  Widget build(BuildContext context) {
    return _CourseCardShell(
      key: ValueKey('course-result-${result.id}'),
      title: '${result.courseCode} · ${result.courseTitle}',
      details: Row(
        children: [
          Expanded(child: Text('Credit Units: ${result.creditUnits}')),
          Text('Score: ${result.score}'),
          const SizedBox(width: 16),
          Text(
            result.grade,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 16),
          Text(result.gradePoint.toStringAsFixed(1)),
        ],
      ),
    );
  }
}

/// Presents the coursework components and calculated total for one course.
class _CourseworkCard extends StatelessWidget {
  const _CourseworkCard({required this.result});

  final CourseworkResult result;

  @override
  Widget build(BuildContext context) {
    return _CourseCardShell(
      key: ValueKey('coursework-result-${result.id}'),
      title: '${result.courseCode} · ${result.courseTitle}',
      details: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Assignment: ${result.assignmentScore}/20')),
              Text('Test: ${result.testScore}/30'),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'TOTAL COURSEWORK',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '${result.total}/50',
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Gives every result card the same border, shadow, and spacing.
class _CourseCardShell extends StatelessWidget {
  const _CourseCardShell({
    required this.title,
    required this.details,
    super.key,
  });

  final String title;
  final Widget details;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            title.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 11),
          Container(height: 2, color: AppColors.primary),
          const SizedBox(height: 13),
          Expanded(
            child: DefaultTextStyle.merge(
              style: const TextStyle(fontSize: 12),
              child: details,
            ),
          ),
        ],
      ),
    );
  }
}
