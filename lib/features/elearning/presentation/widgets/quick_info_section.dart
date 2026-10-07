import 'package:flutter/material.dart';

import '../../../../shared/models/quick_info_item.dart';
import 'quick_info_card.dart';

/// ---------------------------------------------------------------------------
/// Quick Information Section
/// ---------------------------------------------------------------------------
///
/// WHY THIS WIDGET EXISTS
/// ----------------------
///
/// This widget converts a list of [QuickInfoItem] objects into
/// a responsive collection of [QuickInfoCard] widgets.
///
/// The UI only knows how to display data.
/// It does not know where the data comes from.
///
/// Current Source
/// --------------
/// • Local list
///
/// Future Source
/// -------------
/// • ASP.NET Web API
/// • Firebase
/// • SQLite
///
/// By separating the UI from the data source, the application becomes
/// easier to maintain and extend.
/// ---------------------------------------------------------------------------
class QuickInfoSection extends StatelessWidget {
  const QuickInfoSection({super.key, required this.items});

  /// Collection of cards to display.
  final List<QuickInfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : 12),

            //--------------------------------------------------------------
            // Gives every card the same height.
            //
            // WHY?
            // ----
            // QuickInfoCard uses a Spacer() internally.
            // Spacer requires a finite height.
            // SizedBox provides that height and keeps all cards aligned.
            //--------------------------------------------------------------
            child: SizedBox(
              height: 175,

              child: QuickInfoCard(
                icon: item.icon,
                iconColor: item.color,
                title: item.title,
                value: item.value,
                actionText: item.actionText,
                onTap: item.onTap,
              ),
            ),
          ),
        );
      }),
    );
  }
}
