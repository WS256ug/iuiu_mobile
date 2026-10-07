import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/models/service_item.dart';

/// Provides the shared service content shown across the application.
abstract final class ServiceData {
  static const ServiceItem elearning = ServiceItem(
    title: 'E-Learning Centre',
    subtitle: 'E-Content, Chats, Coursework',
    icon: Icons.school,
    color: AppColors.orange,
    destination: ServiceDestination.elearning,
  );

  static const ServiceItem registration = ServiceItem(
    title: 'My Registration',
    subtitle: 'Registration information centre',
    icon: Icons.assignment_outlined,
    color: Color(0xFF10A149),
    destination: ServiceDestination.registration,
  );

  static const ServiceItem evaluation = ServiceItem(
    title: 'Lecturer Evaluation',
    subtitle: 'Semesterly Lecturer Evaluation',
    icon: Icons.star,
    color: AppColors.purple,
    destination: ServiceDestination.lecturerEvaluation,
  );

  static const ServiceItem announcements = ServiceItem(
    title: 'Announcements',
    subtitle: 'Announcements on the portal',
    icon: Icons.notifications,
    color: AppColors.yellow,
  );

  static const ServiceItem directory = ServiceItem(
    title: 'Campus Directory',
    subtitle: 'Contacts staff and students',
    icon: Icons.groups,
    color: AppColors.blue,
    destination: ServiceDestination.campusDirectory,
  );

  static const ServiceItem passouts = ServiceItem(
    title: 'My Passouts',
    subtitle: 'Passout for ladies',
    icon: Icons.badge,
    color: AppColors.primary,
  );

  static const ServiceItem timetables = ServiceItem(
    title: 'My Timetables',
    subtitle: 'My learning timetables',
    icon: Icons.calendar_month,
    color: AppColors.purple,
    destination: ServiceDestination.timetable,
  );

  static const ServiceItem library = ServiceItem(
    title: 'Library Centre',
    subtitle: 'My Library profile and catalog',
    icon: Icons.local_library,
    color: Color(0xFF1B9D53),
    destination: ServiceDestination.library,
  );

  static const ServiceItem complaints = ServiceItem(
    title: 'My Complaints',
    subtitle: 'Track your complaint tickets',
    icon: Icons.contact_support,
    color: AppColors.red,
  );

  static const List<ServiceItem> academic = [
    elearning,
    registration,
    evaluation,
    announcements,
  ];

  static const List<ServiceItem> campus = [
    directory,
    passouts,
    timetables,
    library,
  ];

  static const List<ServiceItem> homeServices = [
    elearning,
    registration,
    evaluation,
    announcements,
    directory,
  ];
}
