import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Adds small UI helpers to BuildContext for use across screens.
extension AppContextExtensions on BuildContext {
  /// Shows consistent feedback for demo actions that are not connected yet.
  void showComingSoon(String feature) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$feature will be available soon.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primaryDark,
        ),
      );
  }
}
