import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../../../shared/widgets/profile_avatar.dart';
import '../../messages/presentation/chat_screen.dart';
import '../data/directory_mock_data.dart';
import '../models/directory_person.dart';

/// Searches local student and staff contacts for the selected campus.
class CampusDirectoryScreen extends StatefulWidget {
  const CampusDirectoryScreen({
    this.people = DirectoryMockData.people,
    this.campusName = 'Kampala Campus',
    super.key,
  });

  final List<DirectoryPerson> people;
  final String campusName;

  @override
  State<CampusDirectoryScreen> createState() => _CampusDirectoryScreenState();
}

/// Holds search and filter choices while the directory screen is open.
class _CampusDirectoryScreenState extends State<CampusDirectoryScreen> {
  final _searchController = TextEditingController();
  DirectoryPersonType _selectedType = DirectoryPersonType.student;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DirectoryPerson> get _filteredPeople {
    final query = _query.trim().toLowerCase();
    return widget.people.where((person) {
      if (person.type != _selectedType) return false;
      if (query.isEmpty) return true;
      return person.name.toLowerCase().contains(query) ||
          person.identifier.toLowerCase().contains(query) ||
          person.email.toLowerCase().contains(query);
    }).toList();
  }

  /// Opens a local conversation addressed to the selected person.
  void _openMessage(DirectoryPerson person) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatScreen(
          participantId: person.id,
          participantName: person.name,
          participantSubtitle:
              person.subtitle ??
              '${person.type == DirectoryPersonType.student ? 'Student' : 'Staff'} · ${person.campus}',
        ),
      ),
    );
  }

  /// Confirms a call request before showing placeholder feedback.
  Future<void> _confirmCall(DirectoryPerson person) async {
    final shouldCall = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Initiate call?'),
        content: Text('Call ${person.name} on ${person.phoneNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('CANCEL'),
          ),
          FilledButton.icon(
            key: const ValueKey('confirm-directory-call'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.call_outlined, size: 18),
            label: const Text('CALL'),
          ),
        ],
      ),
    );

    if (shouldCall != true || !mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Calling ${person.phoneNumber}…')));
  }

  @override
  Widget build(BuildContext context) {
    final people = _filteredPeople;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppTopBar(title: 'Campus Directory', showBackButton: true),
            _DirectoryControls(
              campusName: widget.campusName,
              selectedType: _selectedType,
              searchController: _searchController,
              onTypeChanged: (value) => setState(() => _selectedType = value),
              onSearchChanged: (value) => setState(() => _query = value),
              onClear: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
            Expanded(
              child: people.isEmpty
                  ? const _NoDirectoryResults()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 760 ? 2 : 1;
                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            AppConstants.pagePadding,
                            14,
                            AppConstants.pagePadding,
                            28,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 250,
                              ),
                          itemCount: people.length,
                          itemBuilder: (context, index) {
                            final person = people[index];
                            return _DirectoryContactCard(
                              person: person,
                              onCall: () => _confirmCall(person),
                              onMessage: () => _openMessage(person),
                            );
                          },
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

/// Groups the campus, person-type, and text filters above the directory.
class _DirectoryControls extends StatelessWidget {
  const _DirectoryControls({
    required this.campusName,
    required this.selectedType,
    required this.searchController,
    required this.onTypeChanged,
    required this.onSearchChanged,
    required this.onClear,
  });

  final String campusName;
  final DirectoryPersonType selectedType;
  final TextEditingController searchController;
  final ValueChanged<DirectoryPersonType> onTypeChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${campusName.toUpperCase()} DIRECTORY',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .4,
                ),
              ),
              const SizedBox(height: 14),
              SegmentedButton<DirectoryPersonType>(
                key: const ValueKey('directory-type-selector'),
                segments: const [
                  ButtonSegment(
                    value: DirectoryPersonType.student,
                    label: Text('Students'),
                    icon: Icon(Icons.school_outlined),
                  ),
                  ButtonSegment(
                    value: DirectoryPersonType.staff,
                    label: Text('Staff'),
                    icon: Icon(Icons.badge_outlined),
                  ),
                ],
                selected: {selectedType},
                onSelectionChanged: (selection) =>
                    onTypeChanged(selection.first),
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? AppColors.primaryDark
                        : Colors.white,
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  side: const WidgetStatePropertyAll(
                    BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                key: const ValueKey('directory-search-field'),
                controller: searchController,
                onChanged: onSearchChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search by name, ID, or email',
                  hintStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                  ),
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          key: const ValueKey('clear-directory-search'),
                          onPressed: onClear,
                          icon: const Icon(Icons.close_rounded),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Presents one person's identity, contact details, and available actions.
class _DirectoryContactCard extends StatelessWidget {
  const _DirectoryContactCard({
    required this.person,
    required this.onCall,
    required this.onMessage,
  });

  final DirectoryPerson person;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('directory-person-${person.id}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ProfileAvatar(name: person.name, size: 58, square: true),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (person.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        person.subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.supporting,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _ContactDetail(
            icon: Icons.badge_outlined,
            label: person.identifierLabel,
            value: person.identifier,
          ),
          const SizedBox(height: 8),
          _ContactDetail(
            icon: Icons.phone_outlined,
            label: 'Phone No.',
            value: person.phoneNumber,
          ),
          const SizedBox(height: 8),
          _ContactDetail(
            icon: Icons.email_outlined,
            label: 'Email',
            value: person.email,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: ValueKey('call-${person.id}'),
                  onPressed: onCall,
                  icon: const Icon(Icons.call_outlined, size: 18),
                  label: const Text('Call'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  key: ValueKey('message-${person.id}'),
                  onPressed: onMessage,
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Message'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Pairs a small icon with one readable contact value.
class _ContactDetail extends StatelessWidget {
  const _ContactDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 17),
        const SizedBox(width: 8),
        Text('$label ', style: AppTextStyles.fieldLabel),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

/// Explains that no person matched the chosen directory filters.
class _NoDirectoryResults extends StatelessWidget {
  const _NoDirectoryResults();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_search, size: 52, color: AppColors.primary),
            SizedBox(height: 12),
            Text(
              'No directory results',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 5),
            Text(
              'Try another name, ID, or email address.',
              textAlign: TextAlign.center,
              style: AppTextStyles.supporting,
            ),
          ],
        ),
      ),
    );
  }
}
