import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../../../shared/widgets/profile_avatar.dart';
import '../data/message_mock_data.dart';
import '../models/conversation.dart';

/// Displays a local one-to-one conversation with mock media attachment support.
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    required this.participantId,
    required this.participantName,
    required this.participantSubtitle,
    this.initialMessages,
    super.key,
  });

  final String participantId;
  final String participantName;
  final String participantSubtitle;
  final List<ChatMessage>? initialMessages;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

/// Keeps local messages, drafted text, scrolling, and attachments in sync.
class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late final List<ChatMessage> _messages;
  ChatAttachment? _pendingAttachment;

  @override
  void initState() {
    super.initState();
    _messages = List.of(
      widget.initialMessages ??
          (widget.participantId == 'student-aisha-namuli'
              ? MessageMockData.aishaMessages
              : MessageMockData.defaultMessages),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Adds the typed message to local mock history and clears the composer.
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty && _pendingAttachment == null) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: 'local-${_messages.length}',
          text: text,
          timestamp: 'Now',
          isMine: true,
          attachment: _pendingAttachment,
        ),
      );
      _messageController.clear();
      _pendingAttachment = null;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  /// Lets the user choose a represented attachment type for the draft.
  Future<void> _openAttachmentPicker() async {
    final attachment = await showModalBottomSheet<ChatAttachment>(
      context: context,
      showDragHandle: true,
      builder: (context) => const _AttachmentPickerSheet(),
    );
    if (attachment == null || !mounted) return;
    setState(() => _pendingAttachment = attachment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AppTopBar(title: widget.participantName, showBackButton: true),
            _ParticipantHeader(
              name: widget.participantName,
              subtitle: widget.participantSubtitle,
            ),
            Expanded(
              child: ListView.separated(
                key: const ValueKey('chat-message-list'),
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.pagePadding,
                  18,
                  AppConstants.pagePadding,
                  24,
                ),
                itemCount: _messages.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    _MessageBubble(message: _messages[index]),
              ),
            ),
            _MessageComposer(
              controller: _messageController,
              pendingAttachment: _pendingAttachment,
              onAttach: _openAttachmentPicker,
              onRemoveAttachment: () =>
                  setState(() => _pendingAttachment = null),
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows who the conversation is with and their current presence label.
class _ParticipantHeader extends StatelessWidget {
  const _ParticipantHeader({required this.name, required this.subtitle});

  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      color: Colors.white,
      child: Row(
        children: [
          ProfileAvatar(name: name, size: 42),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws one chat message on the correct side for sender or recipient.
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .76,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 7),
          decoration: BoxDecoration(
            color: message.isMine ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(message.isMine ? 16 : 4),
              bottomRight: Radius.circular(message.isMine ? 4 : 16),
            ),
            boxShadow: message.isMine
                ? null
                : const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: message.isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (message.attachment != null) ...[
                _MessageAttachment(
                  attachment: message.attachment!,
                  isMine: message.isMine,
                ),
                if (message.text.isNotEmpty) const SizedBox(height: 8),
              ],
              if (message.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMine
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  message.timestamp,
                  style: TextStyle(
                    color: message.isMine
                        ? Colors.white.withValues(alpha: .75)
                        : AppColors.textSecondary,
                    fontSize: 9,
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

/// Combines attachment, text-entry, and send controls at the bottom.
class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.controller,
    required this.pendingAttachment,
    required this.onAttach,
    required this.onRemoveAttachment,
    required this.onSend,
  });

  final TextEditingController controller;
  final ChatAttachment? pendingAttachment;
  final VoidCallback onAttach;
  final VoidCallback onRemoveAttachment;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pendingAttachment != null) ...[
              _PendingAttachment(
                attachment: pendingAttachment!,
                onRemove: onRemoveAttachment,
              ),
              const SizedBox(height: 8),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  key: const ValueKey('attach-media-button'),
                  onPressed: onAttach,
                  tooltip: 'Attach media',
                  color: AppColors.primary,
                  icon: const Icon(Icons.attach_file_rounded),
                ),
                Expanded(
                  child: TextField(
                    key: const ValueKey('message-composer'),
                    controller: controller,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: 'Write a message...',
                      hintStyle: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: AppColors.pageBackground,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  key: const ValueKey('send-message-button'),
                  onPressed: onSend,
                  tooltip: 'Send message',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(46, 46),
                  ),
                  icon: const Icon(Icons.send_rounded, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Previews an attachment before it is included in a sent message.
class _PendingAttachment extends StatelessWidget {
  const _PendingAttachment({required this.attachment, required this.onRemove});

  final ChatAttachment attachment;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('pending-chat-attachment'),
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          _AttachmentThumbnail(attachment: attachment, size: 44),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (attachment.sizeLabel != null)
                  Text(
                    attachment.sizeLabel!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            key: const ValueKey('remove-chat-attachment'),
            onPressed: onRemove,
            tooltip: 'Remove attachment',
            icon: const Icon(Icons.close_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}

/// Displays an attachment that already belongs to a chat message.
class _MessageAttachment extends StatelessWidget {
  const _MessageAttachment({required this.attachment, required this.isMine});

  final ChatAttachment attachment;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    if (attachment.type == ChatAttachmentType.image &&
        attachment.assetPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Image.asset(
          attachment.assetPath!,
          key: const ValueKey('sent-image-attachment'),
          width: 220,
          height: 138,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      key: const ValueKey('sent-document-attachment'),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMine
            ? Colors.white.withValues(alpha: .16)
            : AppColors.pageBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.description_outlined,
            color: isMine ? Colors.white : AppColors.primary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isMine ? Colors.white : AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (attachment.sizeLabel != null)
                  Text(
                    attachment.sizeLabel!,
                    style: TextStyle(
                      color: isMine
                          ? Colors.white.withValues(alpha: .75)
                          : AppColors.textSecondary,
                      fontSize: 9,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Chooses a simple image or document preview based on attachment type.
class _AttachmentThumbnail extends StatelessWidget {
  const _AttachmentThumbnail({required this.attachment, required this.size});

  final ChatAttachment attachment;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (attachment.type == ChatAttachmentType.image &&
        attachment.assetPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          attachment.assetPath!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.description_outlined, color: AppColors.primary),
    );
  }
}

/// Presents the available mock attachment choices in a bottom sheet.
class _AttachmentPickerSheet extends StatelessWidget {
  const _AttachmentPickerSheet();

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
              'Attach media',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _AttachmentOption(
                    key: const ValueKey('attach-photo-option'),
                    icon: Icons.photo_outlined,
                    label: 'Photos',
                    attachment: const ChatAttachment(
                      type: ChatAttachmentType.image,
                      name: 'Campus photo.jpg',
                      assetPath: 'assets/images/iuiu_campus.jpg',
                      sizeLabel: '1.8 MB',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _AttachmentOption(
                    key: const ValueKey('attach-camera-option'),
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    attachment: const ChatAttachment(
                      type: ChatAttachmentType.image,
                      name: 'Camera photo.jpg',
                      assetPath: 'assets/images/iuiu_campus.jpg',
                      sizeLabel: '2.1 MB',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _AttachmentOption(
                    key: const ValueKey('attach-document-option'),
                    icon: Icons.description_outlined,
                    label: 'Document',
                    attachment: const ChatAttachment(
                      type: ChatAttachmentType.document,
                      name: 'Course unit list.pdf',
                      sizeLabel: '640 KB',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws one selectable attachment choice with an icon and explanation.
class _AttachmentOption extends StatelessWidget {
  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.attachment,
    super.key,
  });

  final IconData icon;
  final String label;
  final ChatAttachment attachment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(attachment),
      borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.pageBackground,
          borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 27),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
