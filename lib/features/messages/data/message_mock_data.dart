import '../models/conversation.dart';

/// Replaceable conversation content for the current UI-only phase.
abstract final class MessageMockData {
  static const List<Conversation> conversations = [
    Conversation(
      id: 'conversation-aisha',
      participantId: 'student-aisha-namuli',
      participantName: 'Aisha Namuli',
      participantSubtitle: 'Business Administration · Student',
      lastMessage: 'Thank you. I will check the course unit list.',
      timestamp: '10:12 AM',
      unreadCount: 2,
      isOnline: true,
    ),
    Conversation(
      id: 'conversation-ibrahim',
      participantId: 'student-ibrahim-kato',
      participantName: 'Ibrahim Kato',
      participantSubtitle: 'Computer Science · Student',
      lastMessage: 'Are we meeting at the library today?',
      timestamp: 'Yesterday',
    ),
    Conversation(
      id: 'conversation-wahab',
      participantId: 'staff-wahab-ismael',
      participantName: 'Mr. Wahab Ismael',
      participantSubtitle: 'Faculty of Science and Technology',
      lastMessage: 'The assignment submission is now open.',
      timestamp: 'Mon',
    ),
  ];

  static const List<ChatMessage> aishaMessages = [
    ChatMessage(
      id: 'aisha-message-1',
      text: 'Hello Wasswa, have you completed registration?',
      timestamp: '9:54 AM',
      isMine: false,
    ),
    ChatMessage(
      id: 'aisha-message-2',
      text: 'Hello Aisha. Yes, I completed it this morning.',
      timestamp: '10:02 AM',
      isMine: true,
    ),
    ChatMessage(
      id: 'aisha-message-3',
      text: 'Thank you. I will check the course unit list.',
      timestamp: '10:12 AM',
      isMine: false,
    ),
  ];

  static const List<ChatMessage> defaultMessages = [
    ChatMessage(
      id: 'default-message-1',
      text: 'Hello, I found your contact through the campus directory.',
      timestamp: '10:15 AM',
      isMine: true,
    ),
  ];
}
