/// Summary information displayed in the Messages conversation list.
/// Summarizes one conversation in the Messages list.
class Conversation {
  const Conversation({
    required this.id,
    required this.participantId,
    required this.participantName,
    required this.participantSubtitle,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  final String id;
  final String participantId;
  final String participantName;
  final String participantSubtitle;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final bool isOnline;
}

/// Identifies whether an attachment is displayed as an image or document.
enum ChatAttachmentType { image, document }

/// Media attached to a local chat message.
/// Stores the local preview information for a message attachment.
class ChatAttachment {
  const ChatAttachment({
    required this.type,
    required this.name,
    this.assetPath,
    this.sizeLabel,
  });

  final ChatAttachmentType type;
  final String name;
  final String? assetPath;
  final String? sizeLabel;
}

/// One locally displayed message in a conversation.
/// Stores one incoming or outgoing message and its optional attachment.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isMine,
    this.attachment,
  });

  final String id;
  final String text;
  final String timestamp;
  final bool isMine;
  final ChatAttachment? attachment;
}
