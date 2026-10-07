import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

/// ---------------------------------------------------------------------------
/// Quick Information Card
/// ---------------------------------------------------------------------------
///
/// Displays a compact dashboard card inside the E-Learning module.
///
/// Card Contents
/// -------------
/// • Icon
/// • Title
/// • Main statistic
/// • Action text
///
/// WHY THIS WIDGET EXISTS
/// ----------------------
///
/// Rather than designing multiple dashboard cards individually,
/// this reusable widget can display any quick information by simply
/// changing the supplied data.
///
/// This keeps the UI consistent and prepares it for future API data.
/// ---------------------------------------------------------------------------
class QuickInfoCard extends StatelessWidget {
  const QuickInfoCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.actionText,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(AppConstants.cardRadius),

      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              //------------------------------------------------------------
              // Icon
              //------------------------------------------------------------
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Icon(icon, color: iconColor, size: 24),
              ),

              const SizedBox(height: 12),

              //------------------------------------------------------------
              // Card Title
              //------------------------------------------------------------
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              //------------------------------------------------------------
              // Pushes the remaining content to the bottom.
              //
              // Because the parent SizedBox supplies a fixed height,
              // Spacer() works correctly and keeps all cards aligned.
              //------------------------------------------------------------
              const Spacer(),

              //------------------------------------------------------------
              // Statistic
              //------------------------------------------------------------
              Text(
                value,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              //------------------------------------------------------------
              // Action
              //------------------------------------------------------------
              Row(
                children: [
                  Text(
                    actionText,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(width: 4),

                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
