import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../../../shared/widgets/profile_avatar.dart';
import '../data/message_mock_data.dart';
import '../models/conversation.dart';
import 'chat_screen.dart';

/// Lists local student and staff conversations.
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({
    this.conversations = MessageMockData.conversations,
    super.key,
  });

  final List<Conversation> conversations;

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

/// Holds the search query and opens the selected local conversation.
class _MessagesScreenState extends State<MessagesScreen> {
  String _query = '';

  List<Conversation> get _filteredConversations {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.conversations;
    return widget.conversations.where((conversation) {
      return conversation.participantName.toLowerCase().contains(query) ||
          conversation.lastMessage.toLowerCase().contains(query);
    }).toList();
  }

  /// Navigates from a summary row to the full chat for that participant.
  void _openConversation(Conversation conversation) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatScreen(
          participantId: conversation.participantId,
          participantName: conversation.participantName,
          participantSubtitle: conversation.participantSubtitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conversations = _filteredConversations;
    return Material(
      color: AppColors.pageBackground,
      child: Column(
        children: [
          const AppTopBar(title: 'Messages', alignTitleToLeading: true),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: TextField(
              key: const ValueKey('message-search-field'),
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
              ),
            ),
          ),
          Expanded(
            child: conversations.isEmpty
                ? const _NoConversations()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppConstants.pagePadding,
                      4,
                      AppConstants.pagePadding,
                      24,
                    ),
                    itemCount: conversations.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      return _ConversationTile(
                        conversation: conversation,
                        onTap: () => _openConversation(conversation),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Displays one conversation preview with participant, time, and unread count.
class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      child: InkWell(
        key: ValueKey('conversation-${conversation.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ProfileAvatar(name: conversation.participantName, size: 52),
                  if (conversation.isOnline)
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.participantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      conversation.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    conversation.timestamp,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (conversation.unreadCount > 0)
                    Container(
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${conversation.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Explains that the search has no matching conversations.
class _NoConversations extends StatelessWidget {
  const _NoConversations();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mark_chat_unread_outlined,
              size: 58,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'No conversations found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 7),
            Text(
              'Try another name or message.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
