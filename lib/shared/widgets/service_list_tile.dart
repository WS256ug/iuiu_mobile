import 'package:flutter/material.dart';

import '../models/service_item.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_icon_badge.dart';

/// Renders a service item inside grouped lists on Home and Profile.
class ServiceListTile extends StatelessWidget {
  const ServiceListTile({
    required this.item,
    required this.onTap,
    this.showDivider = true,
    super.key,
  });

  final ServiceItem item;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,

      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),

            onTap: onTap,

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),

              child: Row(
                children: [
                  AppIconBadge(
                    icon: item.icon,
                    color: item.color,
                    size: 40,
                    iconSize: 24,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: AppTextStyles.cardTitle),

                        const SizedBox(height: 2),

                        Text(item.subtitle, style: AppTextStyles.supporting),
                      ],
                    ),
                  ),

                  if (item.badge != null)
                    Container(
                      margin: const EdgeInsets.only(right: 8),

                      padding: const EdgeInsets.all(6),

                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),

                      child: Text(
                        '${item.badge}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),

          if (showDivider) const Divider(indent: 66, height: 1),
        ],
      ),
    );
  }
}
