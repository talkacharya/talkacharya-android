import 'package:customr/src/core/network/api_exception.dart';
import 'package:customr/src/core/util/async_value.dart';
import 'package:customr/src/features/birthprofiles/data/models/birth_profile.dart';
import 'package:customr/src/features/matchmaking/data/matchmaking_repository.dart';
import 'package:customr/src/features/matchmaking/data/models/match_result.dart';
import 'package:customr/src/features/matchmaking/presentation/cubit/matchmaking_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements MatchmakingRepository {}

const _boy = BirthProfile(
  id: 'b1',
  fullName: 'Rahul Sharma',
  gender: 'male',
  birthDate: '1992-03-01',
);
const _girl = BirthProfile(
  id: 'g1',
  fullName: 'Priya',
  gender: 'female',
  birthDate: '1994-07-15',
);

Map<String, dynamic> _resultJson() => {
  'id': 'm-1',
  'created_at': '2026-09-13T10:00:00Z',
  'total_points': '24.50',
  'max_points': '36.00',
  'verdict': 'Good',
  'verdict_key': 'good',
  'boy': {'id': 'b1', 'name': 'Rahul Sharma', 'gender': 'male'},
  'girl': {'id': 'g1', 'name': 'Priya', 'gender': 'female'},
  'payload': {
    'boy_info': {'rasi': 'Leo', 'nakshatra': 'Magha', 'gana': 'Rakshasa'},
    'girl_info': {'rasi': 'Aries', 'nakshatra': 'Ashwini', 'gana': 'Deva'},
    'koota': [
      {
        'key': 'nadi',
        'name': 'Nadi',
        'obtained_points': 0,
        'maximum_points': 8,
      },
      {
        'key': 'gana',
        'name': 'Gana',
        'obtained_points': 6,
        'maximum_points': 6,
      },
    ],
    'doshas': {'nadi': true, 'bhakoot': false, 'gana': false},
    'manglik': {
      'status': 'mismatch',
      'boy': {'is_manglik': true, 'is_cancelled': false},
      'girl': {'is_manglik': false},
    },
  },
};

void main() {
  group('MatchResult.fromJson', () {
    test('parses score, kootas, doshas and manglik', () {
      final m = MatchResult.fromJson(_resultJson());
      expect(m.total, 24.5);
      expect(m.pointsLabel, '24.5');
      expect(m.ratio, closeTo(24.5 / 36, 1e-9));
      expect(m.boy.initials, 'RS');
      expect(m.kootas.first.isZero, isTrue);
      expect(m.doshas['nadi'], isTrue);
      expect(m.manglik!.compatible, isFalse);
      expect(m.manglik!.boy.isManglik, isTrue);
      expect(m.boyInfo.rasi, 'Leo');
      expect(m.hasDetail, isTrue);
    });

    test('history summaries (no payload) derive the verdict from points', () {
      final m = MatchResult.fromJson({
        'id': 'm-2',
        'total_points': '10.00',
        'max_points': '36.00',
        'boy': {'name': 'A'},
        'girl': {'name': 'B'},
      });
      expect(m.verdictKey, 'not_recommended');
      expect(m.hasDetail, isFalse);
      expect(m.manglik, isNull);
    });

    test('older payloads derive doshas from zero-point kootas', () {
      final json = _resultJson();
      (json['payload'] as Map).remove('doshas');
      final m = MatchResult.fromJson(json);
      expect(m.doshas, {'nadi': true, 'gana': false});
    });
  });

  group('MatchmakingCubit', () {
    late _MockRepo repo;

    setUp(() {
      repo = _MockRepo();
      when(() => repo.history()).thenAnswer((_) async => const []);
    });

    test('suggestFrom pre-fills the slot matching the profile gender', () {
      final cubit = MatchmakingCubit(repo)..suggestFrom(_girl);
      expect(cubit.state.girl, _girl);
      expect(cubit.state.boy, isNull);
    });

    test('picking the same person for both slots clears the other slot', () {
      final cubit = MatchmakingCubit(repo)
        ..setBoy(_boy)
        ..setGirl(_boy);
      expect(cubit.state.girl, _boy);
      expect(cubit.state.boy, isNull);
      expect(cubit.state.canRun, isFalse);
    });

    test('swap exchanges the two people', () {
      final cubit = MatchmakingCubit(repo)
        ..setBoy(_boy)
        ..setGirl(_girl)
        ..swap();
      expect(cubit.state.boy, _girl);
      expect(cubit.state.girl, _boy);
    });

    test('run returns the result and refreshes history', () async {
      final result = MatchResult.fromJson(_resultJson());
      when(
        () => repo.run(boyProfileId: 'b1', girlProfileId: 'g1'),
      ).thenAnswer((_) async => result);
      when(() => repo.history()).thenAnswer((_) async => [result]);
      final cubit = MatchmakingCubit(repo)
        ..setBoy(_boy)
        ..setGirl(_girl);

      expect(await cubit.run(), result);
      expect(cubit.state.running, isFalse);
      expect(cubit.state.history.value, [result]);
    });

    test('run failure surfaces a friendly error and returns null', () async {
      when(() => repo.run(boyProfileId: 'b1', girlProfileId: 'g1')).thenThrow(
        ApiException(
          message: 'Choose two different people to match.',
          statusCode: 400,
        ),
      );
      final cubit = MatchmakingCubit(repo)
        ..setBoy(_boy)
        ..setGirl(_girl);
      expect(await cubit.run(), isNull);
      expect(cubit.state.error, 'Choose two different people to match.');
      expect(cubit.state.running, isFalse);
    });

    test('MatchResultCubit uses a detailed seed without fetching', () async {
      final seed = MatchResult.fromJson(_resultJson());
      final cubit = MatchResultCubit(repo: repo, id: 'm-1', seed: seed);
      await cubit.load();
      expect(cubit.state.status, AsyncStatus.data);
      verifyNever(() => repo.detail(any()));
    });
  });
}
