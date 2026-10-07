import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/utils/context_extensions.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../../../shared/widgets/profile_avatar.dart';
import '../data/library_mock_data.dart';
import '../models/library_models.dart';

Future<void> openLibraryPicker(BuildContext context) async {
  final destination = await showModalBottomSheet<LibraryDestination>(
    context: context,
    showDragHandle: true,
    builder: (_) => const _LibraryDestinationSheet(),
  );
  if (destination == null || !context.mounted) return;
  final screen = switch (destination) {
    LibraryDestination.profile => const LibraryProfileScreen(),
    LibraryDestination.digitalLibrary => const DigitalLibraryScreen(),
    LibraryDestination.catalog => const CatalogSearchScreen(),
  };
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
}

/// Presents digital categories, profile statistics, and library shortcuts.
class DigitalLibraryScreen extends StatelessWidget {
  const DigitalLibraryScreen({
    this.categories = LibraryMockData.categories,
    super.key,
  });

  final List<LibraryCategory> categories;

  IconData _iconFor(String id) => switch (id) {
    'law-library' => Icons.gavel_outlined,
    'dissertations' => Icons.history_edu_outlined,
    'medical-library' => Icons.medical_services_outlined,
    'all' => Icons.library_books_outlined,
    _ => Icons.local_library_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppTopBar(title: 'Digital Library', showBackButton: true),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 760 ? 2 : 1;
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _DigitalLibraryHero(
                          onSearch: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const CatalogSearchScreen(),
                            ),
                          ),
                          onRequest: () =>
                              context.showComingSoon('E-book requests'),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppConstants.pagePadding,
                          14,
                          AppConstants.pagePadding,
                          28,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 112,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final category = categories[index];
                            return _CategoryCard(
                              category: category,
                              icon: _iconFor(category.id),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => LibraryResourcesScreen(
                                    category: category,
                                  ),
                                ),
                              ),
                            );
                          }, childCount: categories.length),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Introduces the digital library and its main search/request actions.
class _DigitalLibraryHero extends StatelessWidget {
  const _DigitalLibraryHero({required this.onSearch, required this.onRequest});

  final VoidCallback onSearch;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              const Text(
                'IUIU MOBILE DIGITAL LIBRARY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .3,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Convenient reading · Global access',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        _LibraryStat(
                          icon: Icons.account_balance_outlined,
                          value: '3',
                          label: 'Libraries',
                        ),
                        _LibraryStat(
                          icon: Icons.groups_outlined,
                          value: '10,000',
                          label: 'Users',
                        ),
                        _LibraryStat(
                          icon: Icons.menu_book_outlined,
                          value: '100,000+',
                          label: 'E-Books',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            key: const ValueKey('search-library-button'),
                            onPressed: onSearch,
                            icon: const Icon(Icons.search, size: 18),
                            label: const Text('Search Library'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            key: const ValueKey('request-ebook-button'),
                            onPressed: onRequest,
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 18,
                            ),
                            label: const Text('Request E-Book'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays one compact library number with a descriptive label.
class _LibraryStat extends StatelessWidget {
  const _LibraryStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 26),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          Text(label, style: AppTextStyles.supporting),
        ],
      ),
    );
  }
}

/// Opens one digital-library category and explains what it contains.
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.icon,
    required this.onTap,
  });

  final LibraryCategory category;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      child: InkWell(
        key: ValueKey('library-category-${category.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name.toUpperCase(),
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.supporting,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.orange),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lists and filters downloadable resources inside a selected category.
class LibraryResourcesScreen extends StatefulWidget {
  const LibraryResourcesScreen({
    required this.category,
    this.resources = LibraryMockData.resources,
    super.key,
  });

  final LibraryCategory category;
  final List<DigitalLibraryResource> resources;

  @override
  State<LibraryResourcesScreen> createState() => _LibraryResourcesScreenState();
}

/// Remembers resource search text while the category is open.
class _LibraryResourcesScreenState extends State<LibraryResourcesScreen> {
  String _query = '';

  List<DigitalLibraryResource> get _filtered {
    final query = _query.trim().toLowerCase();
    return widget.resources.where((resource) {
      final belongs =
          widget.category.id == 'all' ||
          resource.categoryId == widget.category.id;
      final matches =
          query.isEmpty ||
          resource.title.toLowerCase().contains(query) ||
          resource.categoryName.toLowerCase().contains(query);
      return belongs && matches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final resources = _filtered;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppTopBar(title: 'Library Resources', showBackButton: true),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
              child: Column(
                children: [
                  Text(
                    'DIGITAL LIBRARY RESOURCES\n${widget.category.name.toUpperCase()}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.screenHeading,
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    key: const ValueKey('resource-search-field'),
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'Search resources...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: resources.isEmpty
                  ? const _EmptyLibrarySearch()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 760 ? 2 : 1;
                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 148,
                              ),
                          itemCount: resources.length,
                          itemBuilder: (context, index) => _ResourceCard(
                            resource: resources[index],
                            onDownload: () =>
                                context.showComingSoon('Resource download'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays one digital resource and its represented download action.
class _ResourceCard extends StatelessWidget {
  const _ResourceCard({required this.resource, required this.onDownload});

  final DigitalLibraryResource resource;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('library-resource-${resource.id}'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.book_outlined,
                color: AppColors.orange,
                size: 19,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  resource.title.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                key: ValueKey('download-${resource.id}'),
                onPressed: onDownload,
                tooltip: 'Download resource',
                color: AppColors.primary,
                icon: const Icon(Icons.download_for_offline_outlined),
              ),
            ],
          ),
          Container(height: 2, color: AppColors.primary),
          const SizedBox(height: 10),
          Text(
            'Category: ${resource.categoryName}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Uploaded: ${resource.uploadedOn}',
                  style: AppTextStyles.supporting,
                ),
              ),
              Text(resource.sizeLabel, style: AppTextStyles.supporting),
            ],
          ),
        ],
      ),
    );
  }
}

/// Lets the student search the local library catalogue by book details.
class CatalogSearchScreen extends StatefulWidget {
  const CatalogSearchScreen({this.books = LibraryMockData.catalog, super.key});

  final List<CatalogBook> books;

  @override
  State<CatalogSearchScreen> createState() => _CatalogSearchScreenState();
}

/// Stores the catalogue query and derives matching books from mock data.
class _CatalogSearchScreenState extends State<CatalogSearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final books = widget.books.where((book) {
      return query.isEmpty ||
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query) ||
          book.callNumber.toLowerCase().contains(query);
    }).toList();
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppTopBar(title: 'Search Catalog', showBackButton: true),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                key: const ValueKey('catalog-search-field'),
                autofocus: false,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: 'Search title, author, or call number',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                ),
              ),
            ),
            Expanded(
              child: books.isEmpty
                  ? const _EmptyLibrarySearch()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                      itemCount: books.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) =>
                          _CatalogBookCard(book: books[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows one book's title, author, call number, library, and availability.
class _CatalogBookCard extends StatelessWidget {
  const _CatalogBookCard({required this.book});

  final CatalogBook book;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.menu_book, color: AppColors.primary),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 3),
                Text(book.author, style: AppTextStyles.supporting),
                const SizedBox(height: 6),
                Text(
                  '${book.callNumber} · ${book.library}',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: (book.isAvailable ? AppColors.primary : AppColors.orange)
                  .withValues(alpha: .1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              book.isAvailable ? 'Available' : 'On loan',
              style: TextStyle(
                color: book.isAvailable
                    ? AppColors.primaryDark
                    : AppColors.orange,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays library membership, fine balance, and borrowed-book history.
class LibraryProfileScreen extends StatelessWidget {
  const LibraryProfileScreen({
    this.profile = LibraryMockData.profile,
    super.key,
  });

  final LibraryProfile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppTopBar(title: 'Library Profile', showBackButton: true),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppConstants.cardRadius,
                      ),
                    ),
                    child: Column(
                      children: [
                        ProfileAvatar(name: profile.memberName, size: 82),
                        const SizedBox(height: 12),
                        Text(
                          profile.memberName.toUpperCase(),
                          style: AppTextStyles.screenHeading,
                        ),
                        const SizedBox(height: 4),
                        Text(profile.memberId, style: AppTextStyles.supporting),
                        const SizedBox(height: 16),
                        _ProfileInfo(
                          label: 'Membership',
                          value: profile.status,
                        ),
                        _ProfileInfo(
                          label: 'Home Library',
                          value: profile.homeLibrary,
                        ),
                        _ProfileInfo(
                          label: 'Outstanding Fine',
                          value:
                              'UGX ${AppFormatters.wholeNumber(profile.outstandingFine)}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'BORROWED BOOKS',
                    style: AppTextStyles.sectionHeading,
                  ),
                  const SizedBox(height: 8),
                  ...profile.borrowedBooks.map(
                    (book) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppConstants.smallRadius,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.book_outlined,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: AppTextStyles.cardTitle,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Borrowed ${book.borrowedOn} · Due ${book.dueOn}',
                                    style: AppTextStyles.supporting,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows one labelled value inside the library member summary.
class _ProfileInfo extends StatelessWidget {
  const _ProfileInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label:', style: AppTextStyles.fieldLabel),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// Explains that the current catalogue or resource search has no matches.
class _EmptyLibrarySearch extends StatelessWidget {
  const _EmptyLibrarySearch();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 50, color: AppColors.primary),
            SizedBox(height: 10),
            Text(
              'No library results',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 4),
            Text(
              'Try a different title, author, or category.',
              textAlign: TextAlign.center,
              style: AppTextStyles.supporting,
            ),
          ],
        ),
      ),
    );
  }
}

/// Presents the available library destinations in a bottom sheet.
class _LibraryDestinationSheet extends StatelessWidget {
  const _LibraryDestinationSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Library Centre',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose a library service.',
              style: AppTextStyles.supporting,
            ),
            const SizedBox(height: 16),
            _LibraryOption(
              key: const ValueKey('library-profile-option'),
              destination: LibraryDestination.profile,
              icon: Icons.person_outline,
              title: 'View Profile',
              subtitle: 'Membership, borrowed books, and fines',
            ),
            const SizedBox(height: 10),
            _LibraryOption(
              key: const ValueKey('digital-library-option'),
              destination: LibraryDestination.digitalLibrary,
              icon: Icons.devices_outlined,
              title: 'Digital Library',
              subtitle: 'Browse downloadable digital resources',
            ),
            const SizedBox(height: 10),
            _LibraryOption(
              key: const ValueKey('search-catalog-option'),
              destination: LibraryDestination.catalog,
              icon: Icons.manage_search_outlined,
              title: 'Search Catalog',
              subtitle: 'Find books by title, author, or call number',
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws one selectable library destination with an icon and description.
class _LibraryOption extends StatelessWidget {
  const _LibraryOption({
    required this.destination,
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final LibraryDestination destination;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.pageBackground,
      borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(destination),
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 3),
                    Text(subtitle, style: AppTextStyles.supporting),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
