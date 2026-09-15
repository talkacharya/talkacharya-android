import 'dart:async';

import 'package:customr/src/core/util/async_value.dart';
import 'package:customr/src/features/home/data/horoscope_sign_store.dart';
import 'package:customr/src/features/home/data/models/zodiac.dart';
import 'package:customr/src/features/horoscope/data/horoscope_repository.dart';
import 'package:customr/src/features/horoscope/data/models/sign_horoscope.dart';
import 'package:customr/src/features/horoscope/presentation/cubit/horoscope_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements HoroscopeRepository {}

class _MockSignStore extends Mock implements HoroscopeSignStore {}

Map<String, dynamic> _engineJson({
  String headline = 'A good day with the wind at your back.',
}) => {
  'kind': 'horoscope_daily',
  'generated_at': '2026-09-13T06:00:00Z',
  'payload': {
    'period': 'daily',
    'date': '2026-09-13',
    'range': {'start': '2026-09-13', 'end': '2026-09-13'},
    'headline': headline,
    'band': 'Good',
    'prediction': {
      'general': '$headline The Moon in your 11th house brings gains.',
      'love': 'Love text',
      'career': 'Career text',
      'money': 'Money text',
      'health': 'Health text',
      'luck': 'Good',
    },
    'scores': {'overall': 4, 'love': 5, 'career': 2, 'money': 3, 'health': 4},
    'areas': [
      {
        'key': 'love',
        'score': 5,
        'tone': 'supportive',
        'text': 'Love text',
        'driver': {'planet': 'Venus', 'house': 5},
      },
      {
        'key': 'career',
        'score': 2,
        'tone': 'challenging',
        'text': 'Career text',
      },
    ],
    'lucky': {
      'colour_label': 'Yellow',
      'colour_hex': '#EAB308',
      'number': 3,
      'planet': 'Jupiter',
    },
    'tip': {'planet': 'Saturn', 'text': 'Be patient.'},
    'moon': {'sign_label': 'Gemini', 'nakshatra_label': 'Ardra', 'house': 11},
    'transits': [
      {'planet': 'Moon', 'house': 11, 'sign': 'Gemini', 'favourable': true},
    ],
    'favourable_days': ['2026-09-14', 'bad-date'],
  },
};

void main() {
  group('SignHoroscope.fromJson', () {
    test('parses the in-house gochar payload', () {
      final h = SignHoroscope.fromJson(
        ZodiacSign.leo,
        HoroscopeSpan.today,
        _engineJson(),
      );
      expect(h.overall, 4);
      expect(h.areas.map((a) => a.key), ['love', 'career']);
      expect(h.areas.first.driverPlanet, 'Venus');
      // headline is split out of `general`, not shown twice
      expect(h.general, 'The Moon in your 11th house brings gains.');
      expect(h.lucky!.number, 3);
      expect(h.tipPlanet, 'Saturn');
      expect(h.moonHouse, 11);
      expect(h.transits.single.favourable, isTrue);
      expect(h.favourableDays, [DateTime(2026, 9, 14)]);
      expect(h.isEditorial, isFalse);
    });

    test('legacy provider payload degrades to text-only areas', () {
      final h = SignHoroscope.fromJson(ZodiacSign.aries, HoroscopeSpan.today, {
        'payload': {
          'prediction': {
            'general': 'A steady day.',
            'love': 'Talk openly.',
            'luck': 'Good',
          },
        },
      });
      expect(h.general, 'A steady day.');
      expect(h.areas.single.key, 'love');
      expect(h.areas.single.score, 3);
      expect(h.band, 'Good');
      expect(h.lucky, isNull);
    });

    test('editorial text wins over computed text', () {
      final json = _engineJson()
        ..['editorial'] = {
          'prediction': 'Astrologer says hello.',
          'love': 'Editorial love',
        };
      final h = SignHoroscope.fromJson(
        ZodiacSign.leo,
        HoroscopeSpan.today,
        json,
      );
      expect(h.isEditorial, isTrue);
      expect(h.general, 'Astrologer says hello.');
      expect(h.areas.first.text, 'Editorial love');
      expect(
        h.areas[1].text,
        'Career text',
      ); // no editorial override for career
    });
  });

  group('HoroscopeCubit', () {
    late _MockRepo repo;
    late _MockSignStore store;

    SignHoroscope reading(ZodiacSign s, HoroscopeSpan span) =>
        SignHoroscope.fromJson(s, span, _engineJson());

    setUpAll(() {
      registerFallbackValue(ZodiacSign.aries);
      registerFallbackValue(HoroscopeSpan.today);
    });

    setUp(() {
      repo = _MockRepo();
      store = _MockSignStore();
      when(() => store.set(any())).thenAnswer((_) async {});
      when(() => repo.cached(any(), any())).thenReturn(null);
      when(
        () => repo.fetch(any(), any(), force: any(named: 'force')),
      ).thenAnswer(
        (i) async => reading(
          i.positionalArguments[0] as ZodiacSign,
          i.positionalArguments[1] as HoroscopeSpan,
        ),
      );
    });

    test('load fetches the initial sign + span', () async {
      final cubit = HoroscopeCubit(
        repo: repo,
        signStore: store,
        initialSign: ZodiacSign.leo,
      );
      await cubit.load();
      expect(cubit.state.reading.status, AsyncStatus.data);
      expect(cubit.state.reading.value!.sign, ZodiacSign.leo);
    });

    test('selecting a sign persists it and reloads', () async {
      final cubit = HoroscopeCubit(
        repo: repo,
        signStore: store,
        initialSign: ZodiacSign.leo,
      );
      await cubit.selectSign(ZodiacSign.pisces);
      verify(() => store.set(ZodiacSign.pisces)).called(1);
      expect(cubit.state.reading.value!.sign, ZodiacSign.pisces);
    });

    test(
      'a slow response for an old span never overwrites the new one',
      () async {
        final slow = Completer<SignHoroscope>();
        when(
          () => repo.fetch(
            ZodiacSign.leo,
            HoroscopeSpan.today,
            force: any(named: 'force'),
          ),
        ).thenAnswer((_) => slow.future);
        final cubit = HoroscopeCubit(
          repo: repo,
          signStore: store,
          initialSign: ZodiacSign.leo,
        );

        final first = cubit.load();
        await cubit.selectSpan(HoroscopeSpan.week);
        slow.complete(reading(ZodiacSign.leo, HoroscopeSpan.today));
        await first;

        expect(cubit.state.span, HoroscopeSpan.week);
        expect(cubit.state.reading.value!.span, HoroscopeSpan.week);
      },
    );

    test('cached readings skip the loading state', () async {
      when(
        () => repo.cached(ZodiacSign.leo, HoroscopeSpan.today),
      ).thenReturn(reading(ZodiacSign.leo, HoroscopeSpan.today));
      final cubit = HoroscopeCubit(
        repo: repo,
        signStore: store,
        initialSign: ZodiacSign.leo,
      );
      final states = <AsyncStatus>[];
      final sub = cubit.stream.listen((s) => states.add(s.reading.status));
      await cubit.load();
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      expect(states, [AsyncStatus.data]);
      verifyNever(() => repo.fetch(any(), any(), force: any(named: 'force')));
    });
  });
}
