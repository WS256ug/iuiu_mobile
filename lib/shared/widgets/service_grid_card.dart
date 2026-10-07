import 'package:flutter/material.dart';

import '../models/service_item.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import 'app_icon_badge.dart';

/// Displays one service as a compact card in the Services grid.
class ServiceGridCard extends StatelessWidget {
  const ServiceGridCard({required this.item, required this.onTap, super.key});

  final ServiceItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppIconBadge(
                    icon: item.icon,
                    color: item.color,
                    size: 42,
                    iconSize: 27,
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, size: 23),
                ],
              ),
              const Spacer(),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
