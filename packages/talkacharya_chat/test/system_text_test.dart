import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

ChatMessage _line(String event, [Map<String, dynamic> extra = const {}]) =>
    ChatMessage(
      id: 'm1',
      seq: 1,
      senderRole: ParticipantRole.system,
      type: 'system_event',
      meta: {'event': event, ...extra},
    );

void main() {
  test('each step of a session reads as what happened, by channel', () {
    expect(
      defaultSystemText(_line('requested', {'channel': 'voice'})),
      'Voice call requested',
    );
    expect(
      defaultSystemText(_line('started', {'channel': 'chat'})),
      'Chat started',
    );
    expect(
      defaultSystemText(_line('expired', {'channel': 'video'})),
      'Video call request not answered',
    );
  });

  test('the ended line says how long, rounding a started minute up', () {
    expect(
      defaultSystemText(
        _line('ended', {'channel': 'chat', 'billed_seconds': 190}),
      ),
      'Chat ended · 4 min',
    );
    // Lines posted before the server carried the figures still read.
    expect(defaultSystemText(_line('ended')), 'Chat ended');
  });

  test('an unknown event falls back to the body the server sent', () {
    final m = _line('something_new').copyWith(body: 'Something new');
    expect(defaultSystemText(m), 'Something new');
    expect(systemIcon(m), Icons.info_outline_rounded);
  });

  test('bad news looks like it, and a start looks like good news', () {
    expect(systemTone(_line('rejected')), SystemTone.warning);
    expect(systemTone(_line('started')), SystemTone.positive);
    expect(systemTone(_line('requested')), SystemTone.neutral);
  });
}
