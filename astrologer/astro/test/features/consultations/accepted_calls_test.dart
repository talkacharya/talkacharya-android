import 'package:astro/src/features/consultations/data/accepted_calls.dart';
import 'package:astro/src/features/consultations/data/models/consultation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final call = Consultation.fromJson({
    'id': 'c1',
    'channel': 'voice',
    'status': 'accepted',
  });

  test('the room opens on the thread Accept named, by either id', () {
    AcceptedCalls.put(call, conversationId: 't1', join: {'role': 'astrologer'});
    expect(AcceptedCalls.threadFor('c1'), 't1');
    expect(AcceptedCalls.consultationFor('c1')?.id, 'c1');
    expect(AcceptedCalls.consultationFor('t1')?.id, 'c1');
  });

  test('the join details are used once; a rejoin asks the server', () {
    AcceptedCalls.put(call, conversationId: 't1', join: {'role': 'astrologer'});
    expect(AcceptedCalls.takeJoin('c1'), {'role': 'astrologer'});
    expect(AcceptedCalls.takeJoin('c1'), isNull);
    // the thread is still known for the room
    expect(AcceptedCalls.threadFor('c1'), 't1');
  });

  test('nothing for a consultation that was not just accepted', () {
    expect(AcceptedCalls.threadFor('other'), isNull);
    expect(AcceptedCalls.takeJoin('other'), isNull);
  });
}
