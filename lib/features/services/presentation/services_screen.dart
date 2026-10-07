import 'package:flutter/material.dart';
import '../data/service_data.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/service_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/context_extensions.dart';
import '../../../shared/models/service_item.dart';
import '../../../shared/widgets/search_header.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/service_grid_card.dart';

/// Shows all student services and allows them to be filtered by name.
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

/// Remembers the search text and rebuilds the matching service groups.
class _ServicesScreenState extends State<ServicesScreen> {
  String _query = '';

  /// Returns only services whose title or description matches the search text.
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
    final academic = _filter(ServiceData.academic);
    final campus = _filter(ServiceData.campus);
    final support = _filter(const [ServiceData.complaints]);
    final hasResults =
        academic.isNotEmpty || campus.isNotEmpty || support.isNotEmpty;

    return Column(
      children: [
        SearchHeader(
          title: 'Services',
          hintText: 'Search services...',
          onChanged: (value) => setState(() => _query = value),
          onFilter: () => context.showComingSoon('Service filters'),
          showBackButton: false,
          showMoreButton: false,
          alignTitleToLeading: true,
        ),

        // Shows service categories or a friendly empty-search state.
        Expanded(
          child: hasResults
              ? ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.pagePadding,
                    4,
                    AppConstants.pagePadding,
                    24,
                  ),
                  children: [
                    if (academic.isNotEmpty)
                      _ServiceSection(
                        title: 'Academic & Learning',
                        items: academic,
                      ),
                    if (campus.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      _ServiceSection(
                        title: 'Campus & Student Life',
                        items: campus,
                      ),
                    ],
                    if (support.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      _ServiceSection(
                        title: 'Support & Feedback',
                        items: support,
                      ),
                    ],
                  ],
                )
              : const _NoServicesFound(),
        ),
      ],
    );
  }
}

/// Renders one named service category as a two-column grid.
/// Gives a category heading to a responsive grid of service cards.
class _ServiceSection extends StatelessWidget {
  const _ServiceSection({required this.title, required this.items});

  final String title;
  final List<ServiceItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.08,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return ServiceGridCard(
              item: item,
              onTap: () => openService(context, item),
            );
          },
        ),
      ],
    );
  }
}

/// Explains when a search does not match any service.
/// Explains that the current search did not match any service.
class _NoServicesFound extends StatelessWidget {
  const _NoServicesFound();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 52, color: AppColors.textSecondary),
            SizedBox(height: 12),
            Text(
              'No services found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 5),
            Text(
              'Try a different search word.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
