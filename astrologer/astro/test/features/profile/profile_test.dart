import 'package:astro/src/core/network/api_exception.dart';
import 'package:astro/src/features/auth/data/auth_repository.dart';
import 'package:astro/src/features/auth/data/models/auth_user.dart';
import 'package:astro/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:astro/src/features/profile/data/profile_models.dart';
import 'package:astro/src/features/profile/presentation/view/featured_slots_page.dart';
import 'package:astro/src/features/profile/presentation/view/kyc_page.dart';
import 'package:astro/src/features/profile/presentation/view/reviews_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements AuthRepository {}

Review _review(String id, int rating, {String reply = '', String? status}) =>
    Review.fromJson({
      'id': id,
      'rating': rating,
      'text': 'Great',
      'status': status ?? 'published',
      'customer_name': 'Asha',
      'astrologer_reply': reply,
      'helpful_count': 0,
      'created_at': '2026-09-10T10:00:00Z',
    });

void main() {
  group('models', () {
    test('RateBand parses decimal strings and clamps', () {
      final b = RateBand.fromJson({
        'channel': 'chat',
        'currency': 'INR',
        'min_per_minute': '10.00',
        'max_per_minute': '100.00',
        'default_per_minute': '25.00',
      });
      expect(b.min, 10);
      expect(b.suggested, 25);
      expect(b.clamp(500), 100);
      expect(b.clamp(1), 10);
      expect(b.contains(50), isTrue);
    });

    test('WorkingWindow round-trips HH:MM(:SS) and validates order', () {
      final w = WorkingWindow.fromJson({
        'weekday': 2,
        'start_time': '09:30:00',
        'end_time': '18:00',
      });
      expect(w.start, const TimeOfDay(hour: 9, minute: 30));
      expect(w.toJson(), {
        'weekday': 2,
        'start_time': '09:30',
        'end_time': '18:00',
      });
      expect(w.isValid, isTrue);
      expect(
        w.copyWith(end: const TimeOfDay(hour: 9, minute: 0)).isValid,
        isFalse,
      );
    });

    test('AvailabilitySettings and Review parse', () {
      final a = AvailabilitySettings.fromJson({
        'channels_enabled': ['chat', 'voice'],
        'max_concurrent_chats': 3,
      });
      expect(a.channels, ['chat', 'voice']);
      expect(a.maxConcurrent, 3);

      final r = _review('r1', 9, reply: '  ');
      expect(r.rating, 5, reason: 'clamped');
      expect(r.hasReply, isFalse);
      expect(r.withReply('Thanks').hasReply, isTrue);
    });

    test('FeaturedPricing normalises the per-day map', () {
      final p = FeaturedPricing.fromJson({
        'max_days': 14,
        'per_day': {
          'home_hero': {'INR': '500'},
          'search_boost': {'INR': 200},
        },
      });
      expect(p.maxDays, 14);
      expect(p.priceFor('home_hero'), 500);
      expect(p.priceFor('search_boost'), 200);
      expect(p.priceFor('category_top'), isNull);
    });

    test('RefOption prefers the native language name', () {
      expect(
        RefOption.language({
          'code': 'hi',
          'name': 'Hindi',
          'native_name': 'हिन्दी',
        }).name,
        'हिन्दी',
      );
      expect(RefOption.skill({'slug': 'vedic'}).name, 'vedic');
    });
  });

  test('filterReviews', () {
    final all = [
      _review('a', 5),
      _review('b', 2),
      _review('c', 3, reply: 'Sorry'),
      _review('d', 4, status: 'pending_moderation'),
    ];
    List<String> ids(ReviewFilter f) =>
        filterReviews(all, f).map((r) => r.id).toList();
    expect(ids(ReviewFilter.all), ['a', 'b', 'c', 'd']);
    // Only published reviews can be replied to.
    expect(ids(ReviewFilter.unreplied), ['a', 'b']);
    expect(ids(ReviewFilter.low), ['b', 'c']);
    expect(ids(ReviewFilter.top), ['a']);
  });

  group('featured windows', () {
    test('matches the backend day rounding', () {
      final s = DateTime(2026, 9, 20);
      expect(featuredDays(s, s.add(const Duration(days: 3))), 3);
      expect(featuredDays(s, s.add(const Duration(hours: 2))), 1);
    });

    test('a future range covers whole days', () {
      final w = featuredWindow(
        DateTimeRange(start: DateTime(2026, 9, 20), end: DateTime(2026, 9, 22)),
        now: DateTime(2026, 9, 16, 15),
      );
      expect(w.start, DateTime(2026, 9, 20));
      expect(w.end, DateTime(2026, 9, 23));
      expect(featuredDays(w.start, w.end), 3);
    });

    test('a range starting today starts just after now', () {
      final now = DateTime(2026, 9, 16, 15);
      final w = featuredWindow(
        DateTimeRange(start: DateTime(2026, 9, 16), end: DateTime(2026, 9, 16)),
        now: now,
      );
      expect(w.start, now.add(const Duration(minutes: 1)));
      expect(w.end, DateTime(2026, 9, 17));
      expect(featuredDays(w.start, w.end), 1);
    });
  });

  test('KYC patterns', () {
    expect(kPanPattern.hasMatch('ABCDE1234F'), isTrue);
    expect(kPanPattern.hasMatch('ABCD1234F'), isFalse);
    expect(kIfscPattern.hasMatch('HDFC0001234'), isTrue);
    expect(kIfscPattern.hasMatch('HDFC1001234'), isFalse);
  });

  group('ensureOk', () {
    Response<Map<String, dynamic>> res(int code) => Response(
      requestOptions: RequestOptions(path: '/astro/rates'),
      statusCode: code,
      data: {
        'code': 'rate.outside_band',
        'message': 'Allowed range is 10 to 100 INR per minute for chat.',
      },
    );

    test('passes 2xx through', () {
      expect(res(200).ensureOk().statusCode, 200);
    });

    test('throws the backend message on 4xx', () {
      expect(
        () => res(400).ensureOk(),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', 'rate.outside_band')
              .having((e) => e.message, 'message', contains('Allowed range')),
        ),
      );
    });
  });

  group('AuthUserUpdated', () {
    setUpAll(
      () => registerFallbackValue(const AuthUser(id: 'x', phone: '')),
    );

    test('replaces the session user and caches it', () async {
      final repo = _MockRepo();
      when(() => repo.hasSession()).thenAnswer((_) async => true);
      when(() => repo.cachedUser()).thenAnswer((_) async => null);
      const before = AuthUser(id: 'u1', phone: '+91', preferredLanguage: 'en');
      const after = AuthUser(id: 'u1', phone: '+91', preferredLanguage: 'hi');
      when(() => repo.currentUser()).thenAnswer((_) async => before);
      when(() => repo.cacheUser(after)).thenAnswer((_) async {});

      final bloc = AuthBloc(repo)..add(const AuthStarted());
      await bloc.stream.firstWhere((s) => s.user == before);
      bloc.add(const AuthUserUpdated(after));
      await bloc.stream.firstWhere((s) => s.user == after);

      verify(() => repo.cacheUser(after)).called(1);
      await bloc.close();
    });

    test('is ignored when signed out', () async {
      final repo = _MockRepo();
      when(() => repo.hasSession()).thenAnswer((_) async => false);
      final bloc = AuthBloc(repo)..add(const AuthStarted());
      await bloc.stream.firstWhere(
        (s) => s.status == AuthStatus.unauthenticated,
      );
      bloc.add(const AuthUserUpdated(AuthUser(id: 'u1', phone: '+91')));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.user, isNull);
      verifyNever(() => repo.cacheUser(any()));
      await bloc.close();
    });
  });
}
