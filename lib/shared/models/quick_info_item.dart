import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// Quick Information Item Model
/// ---------------------------------------------------------------------------
///
/// WHY THIS MODEL EXISTS
/// ---------------------
///
/// This model represents one Quick Information card.
///
/// Instead of hardcoding cards inside the UI,
/// we store all the information needed to build a card
/// inside this model.
///
/// Benefits:
/// • Keeps widgets clean.
/// • Makes the UI data-driven.
/// • Easy to replace local data with an ASP.NET API later.
/// ---------------------------------------------------------------------------
/// Stores everything needed to draw and activate one quick-information card.
class QuickInfoItem {
  /// Card title.
  final String title;

  /// Main value shown on the card.
  final String value;

  /// Small action text displayed at the bottom.
  final String actionText;

  /// Icon displayed at the top.
  final IconData icon;

  /// Accent color for the icon and value.
  final Color color;

  /// Action performed when the card is tapped.
  final VoidCallback onTap;

  const QuickInfoItem({
    required this.title,
    required this.value,
    required this.actionText,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
