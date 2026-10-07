import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/app_formatters.dart';

/// Provides a local avatar fallback until a real student photo is available.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.name,
    this.size = 82,
    this.square = false,
    super.key,
  });

  final String name;
  final double size;
  final bool square;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF5B46), Color(0xFFE91528)],
        ),
        borderRadius: BorderRadius.circular(square ? 18 : size / 2),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
      ),
      child: Text(
        AppFormatters.initials(name),
        style: TextStyle(
          color: Colors.white,
          fontSize: size * .29,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
