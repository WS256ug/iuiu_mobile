import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// ---------------------------------------------------------------------------
/// App Top Bar
/// ---------------------------------------------------------------------------
///
/// A reusable application header used throughout the app.
///
/// Features:
/// • Back button (optional)
/// • Screen title
/// • More options button
/// • IUIU green background
///
/// This widget is intentionally reusable so every screen in the
/// application has a consistent navigation experience.
/// ---------------------------------------------------------------------------
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showMoreButton = false,
    this.alignTitleToLeading = false,
  });

  /// Title displayed in the header.
  final String title;

  /// Whether to display the back arrow.
  final bool showBackButton;

  /// Whether to display the menu icon.
  final bool showMoreButton;

  /// Whether a title without a back button starts in the leading position.
  final bool alignTitleToLeading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: const EdgeInsets.only(left: 12, right: 8, top: 40),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: Row(
        children: [
          //------------------------------------------------------------------
          // Back Button
          //------------------------------------------------------------------
          if (showBackButton)
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            )
          else if (!alignTitleToLeading)
            const SizedBox(width: 48),

          //------------------------------------------------------------------
          // Screen Title
          //------------------------------------------------------------------
          Expanded(
            child: Text(
              title,
              key: ValueKey('app-top-bar-title-$title'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          //------------------------------------------------------------------
          // More Button
          //------------------------------------------------------------------
          if (showMoreButton)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
