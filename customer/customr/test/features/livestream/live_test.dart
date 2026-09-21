import 'package:customr/src/features/livestream/data/livestream_api.dart';
import 'package:customr/src/features/livestream/data/models/live_stream_summary.dart';
import 'package:customr/src/features/livestream/presentation/cubit/live_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements LivestreamApi {}

LiveStreamSummary _stream(String id, String status) =>
    LiveStreamSummary(id: id, hostName: 'Acharya $id', status: status);

void main() {
  late _MockApi api;

  setUp(() => api = _MockApi());

  test('the tab splits what is on air from what is scheduled', () async {
    when(() => api.list()).thenAnswer(
      (_) async => [
        _stream('1', 'live'),
        _stream('2', 'scheduled'),
        _stream('3', 'live'),
        _stream('4', 'ended'),
      ],
    );
    final cubit = LiveListCubit(api);

    await cubit.load();

    expect(cubit.state.status, LiveListStatus.ready);
    expect(cubit.state.live.map((s) => s.id), ['1', '3']);
    expect(cubit.state.upcoming.map((s) => s.id), ['2']);
    await cubit.close();
  });

  test('a failed first load surfaces, so the tab is not silently empty', () async {
    when(() => api.list()).thenThrow(StateError('offline'));
    final cubit = LiveListCubit(api);

    await cubit.load();

    expect(cubit.state.status, LiveListStatus.failed);
    expect(cubit.state.isEmpty, isTrue);
    await cubit.close();
  });

  test('a failed background refresh keeps the list on screen', () async {
    when(() => api.list()).thenAnswer((_) async => [_stream('1', 'live')]);
    final cubit = LiveListCubit(api);
    await cubit.load();

    when(() => api.list()).thenThrow(StateError('flaky network'));
    await cubit.load(silent: true);

    expect(cubit.state.status, LiveListStatus.ready);
    expect(cubit.state.live, hasLength(1));
    await cubit.close();
  });

  test('watching refreshes on its own, and unwatching stops it', () async {
    when(() => api.list()).thenAnswer((_) async => [_stream('1', 'live')]);
    final cubit = LiveListCubit(
      api,
      refreshEvery: const Duration(milliseconds: 20),
    );

    cubit.watch();
    await Future<void>.delayed(const Duration(milliseconds: 70));
    final polls = verify(() => api.list()).callCount;
    expect(polls, greaterThan(1));

    cubit.unwatch();
    await Future<void>.delayed(const Duration(milliseconds: 60));
    verifyNever(() => api.list());
    await cubit.close();
  });

  group('the stream payload', () {
    test('reads the fields the room and the card need', () {
      final s = LiveStreamSummary.fromJson(const {
        'public_id': 'abc',
        'host': 'h1',
        'host_name': 'Acharya Priya',
        'title': 'Evening Q&A',
        'status': 'live',
        'viewer_count': 42,
        'is_gifting_enabled': false,
        'gift_currency': 'USD',
        'slow_mode_seconds': 15,
      });

      expect(s.id, 'abc');
      expect(s.hostName, 'Acharya Priya');
      expect(s.isLive, isTrue);
      expect(s.viewerCount, 42);
      expect(s.giftingEnabled, isFalse);
      expect(s.giftCurrency, 'USD');
      expect(s.slowModeSeconds, 15);
    });

    test('gifting defaults to on when the backend omits the flag', () {
      final s = LiveStreamSummary.fromJson(const {'public_id': 'x'});
      expect(s.giftingEnabled, isTrue);
      expect(s.status, 'live');
    });
  });
}
