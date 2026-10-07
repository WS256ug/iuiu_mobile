import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/context_extensions.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../data/lecturer_evaluation_mock_data.dart';
import '../models/lecturer_evaluation.dart';

/// Displays and locally edits one lecturer evaluation questionnaire.
class LecturerEvaluationDetailsScreen extends StatefulWidget {
  const LecturerEvaluationDetailsScreen({
    required this.evaluation,
    this.questions = LecturerEvaluationMockData.questions,
    super.key,
  });

  final LecturerEvaluation evaluation;
  final List<EvaluationQuestion> questions;

  @override
  State<LecturerEvaluationDetailsScreen> createState() =>
      _LecturerEvaluationDetailsScreenState();
}

/// Stores local scores and the optional suggestion while the form is open.
class _LecturerEvaluationDetailsScreenState
    extends State<LecturerEvaluationDetailsScreen> {
  late final Map<String, int> _scores = {
    for (final question in widget.questions) question.id: question.currentScore,
  };
  final TextEditingController _suggestionController = TextEditingController();

  double get _averageScore {
    if (_scores.isEmpty) return 0;
    final total = _scores.values.fold<int>(0, (sum, score) => sum + score);
    return total / _scores.length;
  }

  @override
  void dispose() {
    _suggestionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final evaluation = widget.evaluation;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Column(
        children: [
          const AppTopBar(title: 'Evaluation Details', showBackButton: true),
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
                    Text(
                      '${evaluation.courseCode} - ${evaluation.courseTitle}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.screenHeading.copyWith(height: 1.3),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Evaluation Details',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.supporting,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your Average Score: ${_averageScore.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...widget.questions.map(
                      (question) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _QuestionCard(
                          question: question,
                          score: _scores[question.id]!,
                          onTap: () => _showScorePicker(question),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      key: const ValueKey('evaluation-suggestion'),
                      controller: _suggestionController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Suggestion for Improvement',
                        hintText: 'Enter an optional suggestion',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        key: const ValueKey('submit-evaluation'),
                        onPressed: () =>
                            context.showComingSoon('Submit evaluation'),
                        child: const Text(
                          'SUBMIT EVALUATION',
                          style: AppTextStyles.fieldLabel,
                        ),
                      ),
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

  /// Opens a bottom sheet where the student selects a score from one to five.
  Future<void> _showScorePicker(EvaluationQuestion question) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question.prompt, style: AppTextStyles.cardTitle),
                const SizedBox(height: 6),
                const Text(
                  'Select a score from 1 to 5',
                  style: AppTextStyles.supporting,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(5, (index) {
                    final score = index + 1;
                    return ChoiceChip(
                      label: Text('$score'),
                      selected: _scores[question.id] == score,
                      onSelected: (_) {
                        setState(() => _scores[question.id] = score);
                        Navigator.pop(sheetContext);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Displays one evaluation statement and its current score.
class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.score,
    required this.onTap,
  });

  final EvaluationQuestion question;
  final int score;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: ValueKey('evaluation-question-${question.id}'),
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.question_mark,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(question.prompt, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 7),
                    Text(
                      'Current Score: $score',
                      style: AppTextStyles.fieldLabel.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
