import 'package:customr/src/features/astrologers/data/models/astrologer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Astrologer astrologer({
    List<String>? open,
    Map<String, String> nextOnline = const {},
    bool online = true,
    bool busy = false,
  }) => Astrologer.fromJson({
    'id': 'a1',
    'is_available_flag': online,
    'is_busy': busy,
    'queue_waiting': busy ? 2 : 0,
    'rates': [
      {'channel': 'chat', 'currency': 'INR', 'per_minute_amount': '20.00'},
      {'channel': 'voice', 'currency': 'INR', 'per_minute_amount': '35.00'},
    ],
    'channels_open': open,
    'next_online': nextOnline,
  });

  String later(Duration d) => DateTime.now().add(d).toUtc().toIso8601String();

  test('a server that does not say treats nothing as switched off', () {
    final a = astrologer();
    expect(a.stateOf('chat'), ChannelState.open);
    expect(a.stateOf('voice'), ChannelState.open);
    expect(a.openChannels, ['chat', 'voice']);
    expect(a.isReachable, isTrue);
  });

  test('a channel with no price is not offered at all', () {
    final a = astrologer(open: ['chat', 'voice', 'video']);
    expect(a.stateOf('video'), ChannelState.noRate);
    expect(a.takes('video'), isFalse);
    expect(a.openChannels, ['chat', 'voice']);
  });

  test('a channel switched off is off, and the others still lead', () {
    final a = astrologer(open: ['voice']);
    expect(a.stateOf('chat'), ChannelState.off);
    expect(a.openChannels, ['voice']);
    expect(a.isReachable, isTrue);
  });

  test('a channel off until a time says when, not just that it is off', () {
    final a = astrologer(
      open: ['voice'],
      nextOnline: {'chat': later(const Duration(hours: 2))},
    );
    expect(a.stateOf('chat'), ChannelState.backLater);
    expect(a.soonestBack, isNotNull);
    expect(a.openChannels, ['voice']);
  });

  test('a next-online time that has passed no longer closes the channel', () {
    final a = astrologer(
      open: ['chat', 'voice'],
      nextOnline: {'chat': later(const Duration(minutes: -5))},
    );
    expect(a.stateOf('chat'), ChannelState.open);
    expect(a.soonestBack, isNull);
  });

  test('online with everything off is not someone you can start with', () {
    final a = astrologer(
      open: [],
      nextOnline: {
        'chat': later(const Duration(hours: 3)),
        'voice': later(const Duration(hours: 1)),
      },
    );
    expect(a.isAvailable, isTrue);
    expect(a.isReachable, isFalse);
    // The sooner of the two is what a customer is told.
    expect(
      a.soonestBack!.difference(DateTime.now()).inMinutes,
      inInclusiveRange(55, 61),
    );
  });

  test('offline is never reachable, whatever is switched on', () {
    expect(astrologer(online: false).isReachable, isFalse);
  });

  test('with someone: not startable now, but worth queueing for', () {
    final a = astrologer(busy: true);
    expect(a.isReachable, isFalse);
    expect(a.isQueueable, isTrue);
    expect(a.queueWaiting, 2);
  });

  test('busy with everything switched off offers no queue either', () {
    final a = astrologer(busy: true, open: []);
    expect(a.isQueueable, isFalse);
  });

  test('offline and busy is just offline', () {
    expect(astrologer(online: false, busy: true).isQueueable, isFalse);
  });
}
