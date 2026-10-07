import 'package:flutter/material.dart';
import '../data/elearning_service_data.dart';
import '../data/quick_info_data.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/service_navigation.dart';
import '../../../core/utils/context_extensions.dart';
import '../../../shared/models/service_item.dart';
import '../../../shared/widgets/search_header.dart';
import '../../../shared/widgets/section_header.dart';
import 'widgets/elearning_service_tile.dart';
import 'widgets/quick_info_section.dart';

/// Displays all E-Learning services and quick information.
class ELearningScreen extends StatefulWidget {
  const ELearningScreen({super.key});

  @override
  State<ELearningScreen> createState() => _ELearningScreenState();
}

/// Stores the search query and derives the matching E-Learning services.
class _ELearningScreenState extends State<ELearningScreen> {
  String _query = '';

  /// Returns only services matching the search text.
  List<ServiceItem> _filter(List<ServiceItem> items) {
    if (_query.trim().isEmpty) return items;

    final query = _query.toLowerCase().trim();

    return items.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.subtitle.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final services = _filter(ELearningServiceData.services);

    return Column(
      children: [
        //------------------------------------------------------------------
        // Fixed Header
        //------------------------------------------------------------------
        SearchHeader(
          title: 'E-Learning Centre',
          showBackButton: true,
          hintText: 'Search learning services...',
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
          onFilter: () => context.showComingSoon('Service filters'),
        ),

        //------------------------------------------------------------------
        // Scrollable Content
        //------------------------------------------------------------------
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.pagePadding,
                  24,
                  AppConstants.pagePadding,
                  24,
                ),
                sliver: SliverList.list(
                  children: [
                    SectionHeader(
                      title: 'Quick Information',
                      actionLabel: 'View All',
                      onAction: () =>
                          context.showComingSoon('Quick Information'),
                    ),

                    const SizedBox(height: 12),

                    QuickInfoSection(
                      items: QuickInfoData.items(
                        onClassTap: () {
                          // Navigate to Digital Classes
                        },
                        onChatTap: () {
                          // Navigate to Chat
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    SectionHeader(
                      title: 'Services',
                      actionLabel: 'View All',
                      onAction: () => context.showComingSoon('All Services'),
                    ),

                    const SizedBox(height: 12),

                    services.isNotEmpty
                        ? _ServiceList(items: services)
                        : const _NoServicesFound(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Displays all E-Learning services.
class _ServiceList extends StatelessWidget {
  const _ServiceList({required this.items});

  final List<ServiceItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];

          return ELearningServiceTile(
            item: item,
            showDivider: index != items.length - 1,
            onTap: () => openService(context, item),
          );
        }),
      ),
    );
  }
}

/// Displayed when no service matches the search.
class _NoServicesFound extends StatelessWidget {
  const _NoServicesFound();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off, size: 52, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No learning services found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              'Try a different search keyword.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
