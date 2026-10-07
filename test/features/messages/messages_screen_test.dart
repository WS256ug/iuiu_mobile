import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iuiu_mobile/features/messages/presentation/chat_screen.dart';
import 'package:iuiu_mobile/features/messages/presentation/messages_screen.dart';

void main() {
  testWidgets('filters conversations and opens a chat', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: MessagesScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Aisha Namuli'), findsOneWidget);
    expect(find.text('Ibrahim Kato'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('message-search-field')),
      'Aisha',
    );
    await tester.pump();
    expect(find.text('Aisha Namuli'), findsOneWidget);
    expect(find.text('Ibrahim Kato'), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('conversation-conversation-aisha')),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Hello Wasswa, have you completed registration?'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey('message-composer')),
      'Yes, the list is correct.',
    );
    await tester.tap(find.byKey(const ValueKey('send-message-button')));
    await tester.pumpAndSettle();
    expect(find.text('Yes, the list is correct.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('attaches and sends media with an optional caption', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(
        home: ChatScreen(
          participantId: 'student-aisha-namuli',
          participantName: 'Aisha Namuli',
          participantSubtitle: 'Business Administration · Student',
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('attach-media-button')));
    await tester.pumpAndSettle();
    expect(find.text('Attach media'), findsOneWidget);
    expect(find.text('Photos'), findsOneWidget);
    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Document'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('attach-photo-option')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('pending-chat-attachment')),
      findsOneWidget,
    );
    expect(find.text('Campus photo.jpg'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('message-composer')),
      'The campus today',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('send-message-button')),
    );
    await tester.tap(find.byKey(const ValueKey('send-message-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('pending-chat-attachment')), findsNothing);
    expect(find.byKey(const ValueKey('sent-image-attachment')), findsOneWidget);
    expect(find.text('The campus today'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
