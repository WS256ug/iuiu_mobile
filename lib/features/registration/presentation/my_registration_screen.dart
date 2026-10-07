import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../data/registration_mock_data.dart';
import 'view_course_units_screen.dart';

/// Shows the student's semester registration history.
class MyRegistrationScreen extends StatelessWidget {
  const MyRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Column(
        children: [
          const AppTopBar(title: 'My Registration', showBackButton: true),
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
                    const _RegistrationHeading(),
                    const SizedBox(height: 18),
                    ...List.generate(
                      RegistrationMockData.registrations.length,
                      (index) {
                        final registration =
                            RegistrationMockData.registrations[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _RegistrationCard(
                            registration: registration,
                            actionKey: ValueKey('registration-actions-$index'),
                            onActionsPressed: () =>
                                _showRegistrationActions(context, registration),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Opens the available actions for the semester card the user selected.
  void _showRegistrationActions(
    BuildContext context,
    RegistrationRecord registration,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
                  child: Text(
                    'Self Registration',
                    style: AppTextStyles.screenHeading,
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.format_list_bulleted,
                    color: AppColors.primary,
                  ),
                  title: const Text('View Course Units'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ViewCourseUnitsScreen(registration: registration),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Introduces the registration history section in plain language.
class _RegistrationHeading extends StatelessWidget {
  const _RegistrationHeading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.how_to_reg_outlined, color: AppColors.primary, size: 34),
        SizedBox(height: 8),
        Text(
          'REGISTRATION CENTRE',
          textAlign: TextAlign.center,
          style: AppTextStyles.screenHeading,
        ),
        SizedBox(height: 5),
        Text(
          'View your registration history and course units',
          textAlign: TextAlign.center,
          style: AppTextStyles.supporting,
        ),
      ],
    );
  }
}

/// Summarizes one semester and opens its course-unit actions when tapped.
class _RegistrationCard extends StatelessWidget {
  const _RegistrationCard({
    required this.registration,
    required this.actionKey,
    required this.onActionsPressed,
  });

  final RegistrationRecord registration;
  final Key actionKey;
  final VoidCallback onActionsPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onActionsPressed,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${registration.academicYear}  •  Semester ${registration.semester}',
                        style: AppTextStyles.cardTitle,
                      ),
                    ),
                    IconButton(
                      key: actionKey,
                      tooltip: 'Registration actions',
                      onPressed: onActionsPressed,
                      color: AppColors.primary,
                      icon: const Icon(Icons.format_list_bulleted, size: 25),
                    ),
                  ],
                ),
                const Divider(height: 24, color: AppColors.primaryLight),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _DetailLabel('REG STATUS'),
                          const SizedBox(height: 8),
                          _StatusChip(label: registration.status),
                          const SizedBox(height: 16),
                          const _DetailLabel('RESIDENCE'),
                          const SizedBox(height: 5),
                          _DetailValue(registration.residence),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _DetailLabel('YEAR'),
                          const SizedBox(height: 5),
                          _DetailValue('${registration.studyYear}'),
                          const SizedBox(height: 20),
                          const _DetailLabel('EXAM CARD'),
                          const SizedBox(height: 5),
                          _DetailValue(registration.examCardStatus),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Applies the shared small-label style to registration field names.
class _DetailLabel extends StatelessWidget {
  const _DetailLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.fieldLabel);
  }
}

/// Applies the shared body style to registration field values.
class _DetailValue extends StatelessWidget {
  const _DetailValue(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.bodyValue);
  }
}

/// Highlights the registration status in a compact colored badge.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
