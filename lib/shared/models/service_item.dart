import 'package:flutter/material.dart';

/// Names the screen that should open when a service is selected.
enum ServiceDestination {
  comingSoon,
  campusDirectory,
  elearning,
  lecturerEvaluation,
  library,
  registration,
  timetable,
}

/// Describes one service so the same data can power lists and grids.
/// Stores the text, icon, color, and destination shown by one service card.
class ServiceItem {
  const ServiceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.badge,
    this.destination = ServiceDestination.comingSoon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int? badge;
  final ServiceDestination destination;
}
