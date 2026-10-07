import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/service_item.dart';

/// ---------------------------------------------------------------------------
/// E-Learning Service Tile
/// ---------------------------------------------------------------------------
///
/// Displays one service available in the E-Learning module.
///
/// Features
/// --------
/// • Service icon
/// • Title
/// • Description
/// • Optional notification badge
/// • Arrow indicator
/// • Material ripple effect
/// ---------------------------------------------------------------------------
class ELearningServiceTile extends StatelessWidget {
  const ELearningServiceTile({
    super.key,
    required this.item,
    required this.onTap,
    this.showDivider = true,
  });

  /// Service to display.
  final ServiceItem item;

  /// Executes when the tile is tapped.
  final VoidCallback onTap;

  /// Determines whether to display the bottom divider.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,

      child: InkWell(
        onTap: onTap,

        child: Column(
          children: [
            //--------------------------------------------------------------
            // Tile Content
            //--------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //----------------------------------------------------------
                  // Service Icon
                  //----------------------------------------------------------
                  Container(
                    width: 52,
                    height: 52,

                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: item.color.withOpacity(.12),
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: Icon(item.icon, color: item.color, size: 28),
                  ),

                  const SizedBox(width: 16),

                  //----------------------------------------------------------
                  // Service Details
                  //----------------------------------------------------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            //------------------------------------------------
                            // Notification Badge
                            //------------------------------------------------
                            if (item.badge != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),

                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Text(
                                  "${item.badge}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 5),

                        Text(
                          item.subtitle,

                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  //----------------------------------------------------------
                  // Arrow
                  //----------------------------------------------------------
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            //--------------------------------------------------------------
            // Divider
            //--------------------------------------------------------------
            if (showDivider)
              const Divider(height: 1, indent: 86, endIndent: 18),
          ],
        ),
      ),
    );
  }
}
