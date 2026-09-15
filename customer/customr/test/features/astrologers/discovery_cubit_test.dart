import 'package:customr/src/features/astrologers/data/astrologers_api.dart';
import 'package:customr/src/features/astrologers/data/astrologers_repository.dart';
import 'package:customr/src/features/astrologers/data/models/astrologer.dart';
import 'package:customr/src/features/astrologers/presentation/cubit/discovery_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements AstrologersRepository {}

Astrologer _a(String id) => Astrologer(id: id, name: 'A$id');

void main() {
  late _MockRepo repo;

  setUpAll(() => registerFallbackValue(const AstrologerQuery()));

  setUp(() {
    repo = _MockRepo();
    when(
      () => repo.list(
        query: any(named: 'query'),
        cursor: any(named: 'cursor'),
      ),
    ).thenAnswer(
      (_) async => AstrologerPage(items: [_a('1'), _a('2')], nextCursor: 'c2'),
    );
  });

  test('applyQuery loads page 1 and exposes the query', () async {
    final cubit = DiscoveryCubit(repo);
    await cubit.applyQuery(const AstrologerQuery(skill: 'numerology'));

    expect(cubit.state.status, DiscoveryStatus.ready);
    expect(cubit.state.items, hasLength(2));
    expect(cubit.state.query.skill, 'numerology');
    expect(cubit.state.hasMore, isTrue);
  });

  test('applyQuery is a no-op for the same query once ready', () async {
    final cubit = DiscoveryCubit(repo);
    await cubit.applyQuery(const AstrologerQuery(sort: 'rating'));
    await cubit.applyQuery(const AstrologerQuery(sort: 'rating'));

    verify(() => repo.list(query: any(named: 'query'), cursor: null)).called(1);
  });

  test('setChannel re-queries with the channel and resets the list', () async {
    final cubit = DiscoveryCubit(repo);
    await cubit.applyQuery(const AstrologerQuery());
    await cubit.setChannel('voice');

    expect(cubit.state.query.channel, 'voice');
    final captured = verify(
      () => repo.list(query: captureAny(named: 'query'), cursor: null),
    ).captured;
    expect((captured.last as AstrologerQuery).channel, 'voice');
  });

  test('loadMore appends the next page and stops at the end', () async {
    final cubit = DiscoveryCubit(repo);
    await cubit.applyQuery(const AstrologerQuery());

    when(
      () => repo.list(
        query: any(named: 'query'),
        cursor: 'c2',
      ),
    ).thenAnswer((_) async => AstrologerPage(items: [_a('3')]));
    await cubit.loadMore();

    expect(cubit.state.items.map((a) => a.id), ['1', '2', '3']);
    expect(cubit.state.hasMore, isFalse);

    await cubit.loadMore(); // no-op: hasMore is false
    expect(cubit.state.items, hasLength(3));
  });

  test('a failed first load surfaces an error with retry', () async {
    when(
      () => repo.list(
        query: any(named: 'query'),
        cursor: any(named: 'cursor'),
      ),
    ).thenThrow(Exception('down'));
    final cubit = DiscoveryCubit(repo);
    await cubit.applyQuery(const AstrologerQuery());

    expect(cubit.state.status, DiscoveryStatus.error);
    expect(cubit.state.error, contains('down'));
  });

  test(
    're-filtering keeps the old results on screen until the new ones land',
    () async {
      final cubit = DiscoveryCubit(repo);
      await cubit.applyQuery(const AstrologerQuery());
      expect(cubit.state.items, hasLength(2));

      final states = <DiscoveryState>[];
      final sub = cubit.stream.listen(states.add);
      await cubit.setChannel('chat');
      await sub.cancel();

      // The transitional emit still carried the previous 2 items…
      expect(states.first.status, DiscoveryStatus.refiltering);
      expect(states.first.items, hasLength(2));
      // …and it never dropped to zero.
      expect(states.every((s) => s.items.isNotEmpty), isTrue);
    },
  );

  test('duplicate ids across pages are dropped', () async {
    final cubit = DiscoveryCubit(repo);
    await cubit.applyQuery(const AstrologerQuery());

    when(
      () => repo.list(
        query: any(named: 'query'),
        cursor: 'c2',
      ),
    ).thenAnswer(
      (_) async => AstrologerPage(items: [_a('2'), _a('3')]), // '2' repeats
    );
    await cubit.loadMore();

    expect(cubit.state.items.map((a) => a.id), ['1', '2', '3']);
  });

  test('a failed loadMore is retryable and does not wipe the list', () async {
    final cubit = DiscoveryCubit(repo);
    await cubit.applyQuery(const AstrologerQuery());

    when(
      () => repo.list(
        query: any(named: 'query'),
        cursor: 'c2',
      ),
    ).thenThrow(Exception('flaky'));
    await cubit.loadMore();

    expect(cubit.state.items, hasLength(2));
    expect(cubit.state.loadMoreError, isTrue);
    expect(cubit.state.status, DiscoveryStatus.ready);

    when(
      () => repo.list(
        query: any(named: 'query'),
        cursor: 'c2',
      ),
    ).thenAnswer((_) async => AstrologerPage(items: [_a('3')]));
    await cubit.retryLoadMore();

    expect(cubit.state.items.map((a) => a.id), ['1', '2', '3']);
    expect(cubit.state.loadMoreError, isFalse);
  });
}
