import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/models/service_item.dart';

/// ---------------------------------------------------------------------------
/// E-Learning Service Data
/// ---------------------------------------------------------------------------
///
/// Stores all services displayed on the E-Learning Centre screen.
///
/// Separating the data from the UI makes the application easier to
/// maintain and allows the services to be replaced with data from
/// an API in the future.
/// ---------------------------------------------------------------------------
class ELearningServiceData {
  const ELearningServiceData._();

  /// List of all E-Learning services.
  static const List<ServiceItem> services = [
    //-----------------------------------------------------------------------
    // Digital Classes
    //-----------------------------------------------------------------------
    ServiceItem(
      title: 'Digital Classes',
      subtitle: 'Attend your online classes',
      icon: Icons.computer_rounded,
      color: AppColors.primary,
      badge: 2,
    ),

    //-----------------------------------------------------------------------
    // Results Centre
    //-----------------------------------------------------------------------
    ServiceItem(
      title: 'Results Centre',
      subtitle: 'View semester examination results',
      icon: Icons.assessment_rounded,
      color: Colors.indigo,
    ),

    //-----------------------------------------------------------------------
    // Lecturer Evaluation
    //-----------------------------------------------------------------------
    ServiceItem(
      title: 'Lecturer Evaluation',
      subtitle: 'Evaluate your lecturers',
      icon: Icons.star_rate_rounded,
      color: Colors.amber,
      destination: ServiceDestination.lecturerEvaluation,
    ),

    //-----------------------------------------------------------------------
    // General Announcements
    //-----------------------------------------------------------------------
    ServiceItem(
      title: 'General Announcements',
      subtitle: 'Latest academic announcements',
      icon: Icons.campaign_rounded,
      color: Colors.red,
      badge: 3,
    ),

    //-----------------------------------------------------------------------
    // E-Resources Centre
    //-----------------------------------------------------------------------
    ServiceItem(
      title: 'E-Resources Centre',
      subtitle: 'Books, journals and publications',
      icon: Icons.menu_book_rounded,
      color: Colors.teal,
    ),

    //-----------------------------------------------------------------------
    // Digital Library
    //-----------------------------------------------------------------------
    ServiceItem(
      title: 'Digital Library',
      subtitle: 'Browse digital learning materials',
      icon: Icons.local_library_rounded,
      color: Colors.deepPurple,
    ),

    //-----------------------------------------------------------------------
    // IUIU Repository
    //-----------------------------------------------------------------------
    ServiceItem(
      title: 'IUIU Repository',
      subtitle: 'Research papers and dissertations',
      icon: Icons.cloud_download_rounded,
      color: Colors.blueGrey,
    ),
  ];
}
