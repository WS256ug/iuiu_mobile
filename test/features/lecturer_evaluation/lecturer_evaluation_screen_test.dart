import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iuiu_mobile/core/navigation/app_shell.dart';
import 'package:iuiu_mobile/features/lecturer_evaluation/models/lecturer_evaluation.dart';
import 'package:iuiu_mobile/features/lecturer_evaluation/presentation/lecturer_evaluation_screen.dart';

void main() {
  testWidgets('opens from Services and displays the reference information', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const MaterialApp(home: AppShell()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('bottom-nav-1')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Lecturer Evaluation'));
    await tester.tap(find.text('Lecturer Evaluation'));
    await tester.pumpAndSettle();

    expect(find.text('MY LECTURER EVALUATION'), findsOneWidget);
    expect(find.text('2025/2026'), findsOneWidget);
    expect(find.text('Semester 2'), findsOneWidget);
    expect(find.textContaining('totally confidential'), findsOneWidget);
    expect(
      find.text('BIT 3202 - Business Intelligence and Data Warehousing'),
      findsOneWidget,
    );
    expect(find.text('BY: Mr.Wahab Ismael'), findsOneWidget);
    expect(find.text('Excellent'), findsOneWidget);
    expect(find.byIcon(Icons.format_list_bulleted), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('lecturer-evaluation-bit-3202-2025-2026-2')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Evaluation Details'), findsWidgets);
    expect(find.text('Your Average Score: 5.00'), findsOneWidget);
    expect(find.text('Always punctual for lectures'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('evaluation-question-punctual')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();
    expect(find.text('Your Average Score: 4.85'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('submit-evaluation')),
      400,
    );
    await tester.enterText(
      find.byKey(const ValueKey('evaluation-suggestion')),
      'Keep sharing practical examples.',
    );
    await tester.tap(find.byKey(const ValueKey('submit-evaluation')));
    await tester.pump();
    expect(
      find.text('Submit evaluation will be available soon.'),
      findsOneWidget,
    );

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('remains overflow-free on small phones and tablets', (
    tester,
  ) async {
    for (final size in const [Size(320, 700), Size(800, 1000)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(size),
          home: MediaQuery(
            data: MediaQueryData(
              size: size,
              textScaler: const TextScaler.linear(1.3),
            ),
            child: const LecturerEvaluationScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('IQR 1101 - Quran Recitation'),
        300,
      );
      expect(find.text('BY: -'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('lecturer-evaluation-iqr-1101-2025-2026-2')),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('submit-evaluation')),
        400,
      );
      expect(find.byKey(const ValueKey('submit-evaluation')), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('year and semester selectors filter lecturers', (tester) async {
    const periods = [
      EvaluationPeriod(
        id: '2025-2026-2',
        academicYear: '2025/2026',
        semester: 2,
      ),
      EvaluationPeriod(
        id: '2025-2026-1',
        academicYear: '2025/2026',
        semester: 1,
      ),
      EvaluationPeriod(
        id: '2024-2025-2',
        academicYear: '2024/2025',
        semester: 2,
      ),
    ];
    const evaluations = [
      LecturerEvaluation(
        id: 'current',
        courseCode: 'CUR 200',
        courseTitle: 'Current Semester Course',
        lecturer: 'Current Lecturer',
        periodId: '2025-2026-2',
      ),
      LecturerEvaluation(
        id: 'first-semester',
        courseCode: 'CUR 100',
        courseTitle: 'First Semester Course',
        lecturer: 'First Semester Lecturer',
        periodId: '2025-2026-1',
      ),
      LecturerEvaluation(
        id: 'previous-year',
        courseCode: 'OLD 200',
        courseTitle: 'Previous Year Course',
        lecturer: 'Previous Lecturer',
        periodId: '2024-2025-2',
      ),
    ];

    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      const MaterialApp(
        home: LecturerEvaluationScreen(
          periods: periods,
          evaluations: evaluations,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Current Semester Course'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('evaluation-semester-selector')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Semester 1').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('First Semester Course'), findsOneWidget);
    expect(find.textContaining('Current Semester Course'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('evaluation-year-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2024/2025').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Previous Year Course'), findsOneWidget);
    expect(find.textContaining('First Semester Course'), findsNothing);

    await tester.binding.setSurfaceSize(null);
  });
}
