import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/context_extensions.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../data/registration_mock_data.dart';

/// Displays regular or retake course units for one registration.
class ViewCourseUnitsScreen extends StatefulWidget {
  const ViewCourseUnitsScreen({required this.registration, super.key});

  final RegistrationRecord registration;

  @override
  State<ViewCourseUnitsScreen> createState() => _ViewCourseUnitsScreenState();
}

/// Remembers whether regular or retake courses are currently selected.
class _ViewCourseUnitsScreenState extends State<ViewCourseUnitsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final units = _selectedTab == 0
        ? RegistrationMockData.regularCourseUnits
        : RegistrationMockData.retakeCourseUnits;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Column(
        children: [
          const AppTopBar(title: 'Course Units', showBackButton: true),
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
                    _CourseUnitsHeading(registration: widget.registration),
                    const SizedBox(height: 20),
                    if (_selectedTab == 0)
                      Row(
                        children: [
                          Expanded(
                            child: _CourseActionButton(
                              key: const ValueKey('add-course-units-action'),
                              icon: Icons.playlist_add,
                              label: 'Add Course Units',
                              onTap: () =>
                                  context.showComingSoon('Add course units'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _CourseActionButton(
                              key: const ValueKey(
                                'faculty-registration-action',
                              ),
                              icon: Icons.groups_outlined,
                              label: 'Faculty Registration',
                              onTap: () => context.showComingSoon(
                                'Faculty registration',
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          const actionGap = 12.0;
                          final actionWidth =
                              (constraints.maxWidth - actionGap) / 2;

                          return Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: actionWidth,
                              child: _CourseActionButton(
                                key: const ValueKey(
                                  'add-retake-course-units-action',
                                ),
                                icon: Icons.playlist_add_check,
                                label: 'Add Course Units',
                                onTap: () => context.showComingSoon(
                                  'Add retake courses',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 20),
                    if (units.isEmpty)
                      const _EmptyCourseUnits()
                    else
                      ...units.map(
                        (unit) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CourseUnitCard(unit: unit),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) {
          setState(() => _selectedTab = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Regular Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined),
            selectedIcon: Icon(Icons.fact_check),
            label: 'Retake Courses',
          ),
        ],
      ),
    );
  }
}

/// Identifies the selected academic year and semester above the course list.
class _CourseUnitsHeading extends StatelessWidget {
  const _CourseUnitsHeading({required this.registration});

  final RegistrationRecord registration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'COURSE UNITS AND FACULTY REGISTRATION',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionHeading,
        ),
        const SizedBox(height: 5),
        Text(
          '${registration.academicYear}, SEMESTER ${registration.semester}',
          textAlign: TextAlign.center,
          style: AppTextStyles.supporting.copyWith(
            color: AppColors.primaryDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Draws a compact action used for adding units or faculty registration.
class _CourseActionButton extends StatelessWidget {
  const _CourseActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.smallRadius),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(height: 3),
            SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.fieldLabel.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows one course code, course name, and credit-unit value.
class _CourseUnitCard extends StatelessWidget {
  const _CourseUnitCard({required this.unit});

  final CourseUnit unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                  '${unit.code} - ${unit.title}',
                  style: AppTextStyles.cardTitle.copyWith(height: 1.25),
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.primaryLight),
          Row(
            children: [
              const Flexible(
                child: Text('Credit Units', style: AppTextStyles.supporting),
              ),
              const SizedBox(width: 18),
              Text(
                unit.creditUnits.toStringAsFixed(1),
                style: AppTextStyles.cardTitle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Reassures the student when no retake units are available.
class _EmptyCourseUnits extends StatelessWidget {
  const _EmptyCourseUnits();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.fact_check_outlined,
            color: AppColors.textSecondary,
            size: 48,
          ),
          SizedBox(height: 12),
          Text('No retake courses', style: AppTextStyles.cardTitle),
          SizedBox(height: 5),
          Text(
            'Retake course units will appear here.',
            textAlign: TextAlign.center,
            style: AppTextStyles.supporting,
          ),
        ],
      ),
    );
  }
}
