import 'package:customr/src/features/astrologers/data/models/astrologer.dart';
import 'package:customr/src/features/follows/data/follows_api.dart';
import 'package:customr/src/features/follows/data/follows_repository.dart';
import 'package:customr/src/features/follows/presentation/cubit/follow_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements FollowsRepository {}

void main() {
  late _MockRepo repo;

  setUpAll(() => registerFallbackValue(FollowSource.profile));
  setUp(() => repo = _MockRepo());

  test('toggle is optimistic, then settles on the server answer', () async {
    when(
      () => repo.setFollowing('a1', follow: true, source: FollowSource.card),
    ).thenAnswer(
      (_) async => const FollowStatus(following: true, followersCount: 11),
    );
    final cubit = FollowCubit(repo)
      ..seed(const [Astrologer(id: 'a1', followersCount: 9)]);

    final seen = <FollowState>[];
    final sub = cubit.stream.listen(seen.add);
    final result = await cubit.toggle('a1', source: FollowSource.card);
    await sub.cancel();

    expect(result, isTrue);
    // optimistic step: following, count +1, pending
    expect(
      seen.first.of('a1'),
      const FollowEntry(following: true, followersCount: 10),
    );
    expect(seen.first.isPending('a1'), isTrue);
    // settled on the server's count
    expect(
      cubit.state.of('a1'),
      const FollowEntry(following: true, followersCount: 11),
    );
    expect(cubit.state.isPending('a1'), isFalse);
  });

  test('a failed toggle rolls back to the previous state', () async {
    when(
      () => repo.setFollowing(
        any(),
        follow: any(named: 'follow'),
        source: any(named: 'source'),
      ),
    ).thenThrow(Exception('offline'));
    final cubit = FollowCubit(repo);

    final result = await cubit.toggle(
      'a1',
      fallback: const FollowEntry(following: true, followersCount: 4),
    );

    expect(result, isNull);
    expect(
      cubit.state.of('a1'),
      const FollowEntry(following: true, followersCount: 4),
    );
    expect(cubit.state.pending, isEmpty);
    verify(
      () =>
          repo.setFollowing('a1', follow: false, source: FollowSource.profile),
    ).called(1);
  });

  test(
    'seed never overwrites an in-flight toggle; load fills unknown ids',
    () async {
      when(
        () => repo.setFollowing(
          any(),
          follow: any(named: 'follow'),
          source: any(named: 'source'),
        ),
      ).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return const FollowStatus(following: true, followersCount: 1);
      });
      when(() => repo.status('a2')).thenAnswer(
        (_) async => const FollowStatus(following: true, followersCount: 7),
      );
      final cubit = FollowCubit(repo);

      final pending = cubit.toggle('a1');
      cubit.seed(const [Astrologer(id: 'a1')]); // stale list data — ignored
      expect(cubit.state.of('a1')?.following, isTrue);
      await pending;

      await cubit.load('a2');
      expect(
        cubit.state.of('a2'),
        const FollowEntry(following: true, followersCount: 7),
      );
    },
  );

  test('a second tap while pending is ignored', () async {
    when(
      () => repo.setFollowing(
        any(),
        follow: any(named: 'follow'),
        source: any(named: 'source'),
      ),
    ).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      return const FollowStatus(following: true, followersCount: 1);
    });
    final cubit = FollowCubit(repo);
    final first = cubit.toggle('a1');
    expect(await cubit.toggle('a1'), isNull);
    expect(await first, isTrue);
    verify(
      () => repo.setFollowing(
        any(),
        follow: any(named: 'follow'),
        source: any(named: 'source'),
      ),
    ).called(1);
  });
}
