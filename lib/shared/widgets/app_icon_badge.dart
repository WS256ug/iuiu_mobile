import 'package:flutter/material.dart';

/// Places a colored icon on a soft background for repeated service artwork.
class AppIconBadge extends StatelessWidget {
  const AppIconBadge({
    required this.icon,
    required this.color,
    this.size = 48,
    this.iconSize = 28,
    super.key,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(size * .32),
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}
