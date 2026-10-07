import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared text hierarchy based on the Home screen's visual language.
abstract final class AppTextStyles {
  static const TextStyle screenHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: .2,
  );

  static const TextStyle sectionHeading = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    letterSpacing: .2,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: .2,
  );

  static const TextStyle bodyValue = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle supporting = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
  );
}
