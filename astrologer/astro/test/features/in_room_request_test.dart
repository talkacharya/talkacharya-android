import 'package:astro/src/core/realtime/realtime_event.dart';
import 'package:astro/src/features/consultations/data/models/conversation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a request names the thread it was made in', () {
    final e = RealtimeEvent.fromFrame({
      'type': 'consultation.requested',
      'data': {
        'consultation': 'c9',
        'conversation': 't1',
        'channel': 'voice',
        'question': 'career',
      },
    });
    final r = e as ConsultationRequested;
    expect(r.consultationId, 'c9');
    // What lets the app answer it in the open room instead of a sheet.
    expect(r.conversationId, 't1');
    expect(r.channel, 'voice');
  });

  test('a request from an older server still parses, with no thread', () {
    final r =
        RealtimeEvent.fromFrame({
              'type': 'consultation.requested',
              'data': {'consultation': 'c9'},
            })
            as ConsultationRequested;
    expect(r.conversationId, isEmpty);
  });

  test('the thread says when a customer is asking right now', () {
    final t = Conversation.fromJson({
      'id': 't1',
      'pending_consultation': 'c9',
      'window': {'can_send': false, 'reason': 'closed'},
    });
    expect(t.pendingConsultationId, 'c9');
    // Closed — nobody can type — until the astrologer accepts.
    expect(t.window.canSend, isFalse);
  });
}
