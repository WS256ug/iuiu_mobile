import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/models/quick_info_item.dart';

/// Builds the small E-Learning summary cards from supplied UI actions.
class QuickInfoData {
  /// Returns local summary values while keeping navigation outside the data.
  static List<QuickInfoItem> items({
    required VoidCallback onClassTap,
    required VoidCallback onChatTap,
  }) {
    return [
      QuickInfoItem(
        title: "Class Info",
        value: "7 Classes",
        actionText: "Open Classes",
        icon: Icons.menu_book_rounded,
        color: AppColors.primary,
        onTap: onClassTap,
      ),
      QuickInfoItem(
        title: "Chat Info",
        value: "5 Messages",
        actionText: "Open Chats",
        icon: Icons.chat_bubble_outline_rounded,
        color: Colors.orange,
        onTap: onChatTap,
      ),
    ];
  }
}
