import 'package:flutter/material.dart';

import '../../features/elearning/presentation/elearning_screen.dart';
import '../../features/campus_directory/presentation/campus_directory_screen.dart';
import '../../features/lecturer_evaluation/presentation/lecturer_evaluation_screen.dart';
import '../../features/library/presentation/library_screens.dart';
import '../../features/registration/presentation/my_registration_screen.dart';
import '../../features/timetable/presentation/timetable_screen.dart';
import '../../shared/models/service_item.dart';
import '../utils/context_extensions.dart';

/// Opens implemented service pages and keeps placeholders consistent.
void openService(BuildContext context, ServiceItem item) {
  switch (item.destination) {
    case ServiceDestination.campusDirectory:
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const CampusDirectoryScreen()),
      );
      return;
    case ServiceDestination.elearning:
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              const Scaffold(body: SafeArea(child: ELearningScreen())),
        ),
      );
      return;
    case ServiceDestination.registration:
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const MyRegistrationScreen()),
      );
      return;
    case ServiceDestination.timetable:
      openTimetablePicker(context);
      return;
    case ServiceDestination.lecturerEvaluation:
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const LecturerEvaluationScreen(),
        ),
      );
      return;
    case ServiceDestination.library:
      openLibraryPicker(context);
      return;
    case ServiceDestination.comingSoon:
      context.showComingSoon(item.title);
      return;
  }
}
