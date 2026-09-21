import 'dart:async';

import 'package:astro/src/core/l10n/l10n.dart';
import 'package:astro/src/core/realtime/realtime_client.dart';
import 'package:astro/src/core/theme/astro_palette.dart';
import 'package:astro/src/features/consultations/data/consultation_api.dart';
import 'package:astro/src/features/consultations/data/models/consultation.dart';
import 'package:astro/src/features/consultations/presentation/cubit/chat_cubit.dart';
import 'package:astro/src/features/consultations/presentation/view/consultation_room_page.dart';
import 'package:astro/src/features/notifications/presentation/view/notifications_page.dart';
import 'package:astro/src/features/onboarding/presentation/widgets/onboarding_steps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ConsultationApi {}

class _MockRealtime extends Mock implements RealtimeClient {}

Consultation _c({String status = 'active'}) => Consultation.fromJson({
  'id': 'c1',
  'status': status,
  'customer_name': 'Asha',
  'started_at': '2026-09-16T10:00:00Z',
});

void main() {
  test('notificationStyle infers the kind from the deeplink', () {
    expect(
      notificationStyle('talkacharya://requests/abc').hue,
      AstroPalette.career,
    );
    expect(
      notificationStyle('talkacharya://earnings/payouts/1').hue,
      AstroPalette.money,
    );
    expect(notificationStyle('/profile/reviews').hue, AstroPalette.fire);
    expect(notificationStyle('').icon, Icons.notifications_rounded);
  });

  group('OnboardingStep', () {
    test('isDone follows the remaining gaps', () {
      const gaps = ['skills', 'kyc:photo'];
      expect(OnboardingStep.profile.isDone(gaps), isTrue);
      expect(OnboardingStep.expertise.isDone(gaps), isFalse);
      expect(OnboardingStep.identity.isDone(gaps), isFalse);
      expect(OnboardingStep.bank.isDone(gaps), isTrue);
      expect(OnboardingStep.review.isDone(const []), isFalse);
    });

    test('firstOpen picks the first unfinished step, else review', () {
      expect(
        OnboardingStep.firstOpen(const ['bank_account', 'kyc:pan']),
        OnboardingStep.identity,
      );
      expect(OnboardingStep.firstOpen(const []), OnboardingStep.review);
    });

    test('forGap maps each gap to its step', () {
      expect(OnboardingStep.forGap('languages'), OnboardingStep.expertise);
      expect(OnboardingStep.forGap('kyc:photo'), OnboardingStep.identity);
      expect(OnboardingStep.forGap('unknown'), OnboardingStep.review);
    });

    test('gapLabel localises known gaps', () {
      final l = lookupAppLocalizations(const Locale('en'));
      expect(gapLabel(l, 'bank_account'), 'Bank account');
      expect(gapLabel(l, 'kyc:pan'), 'PAN card');
      expect(gapLabel(l, 'mystery'), 'mystery');
    });
  });

  test('formatElapsed', () {
    expect(formatElapsed(0), '00:00');
    expect(formatElapsed(75), '01:15');
    expect(formatElapsed(3725), '1:02:05');
  });

  group('ChatCubit', () {
    late _MockApi api;
    late _MockRealtime rt;
    late StreamController<Map<String, dynamic>> frames;

    setUp(() {
      api = _MockApi();
      rt = _MockRealtime();
      frames = StreamController.broadcast();
      when(() => rt.channelFrames('conv:c1')).thenAnswer((_) => frames.stream);
      when(() => api.detail('c1')).thenAnswer((_) async => _c());
    });

    tearDown(() => frames.close());

    ChatCubit build() =>
        ChatCubit(api: api, realtime: rt, consultationId: 'c1');

    test('parses started_at and tracks the customer runway', () async {
      final cubit = build();
      await cubit.init();
      expect(
        cubit.state.consultation?.startedAt,
        DateTime.utc(2026, 9, 16, 10),
      );

      frames.add({'type': 'billing.low_balance', 'data': {}});
      frames.add({
        'type': 'billing.tick',
        'data': {'runway_seconds': 120},
      });
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.clientRunwaySeconds, 120);
      expect(cubit.state.clientLowBalance, isTrue);

      // A recharge pushes the runway back up and clears the warning.
      frames.add({
        'type': 'billing.tick',
        'data': {'runway_seconds': 900},
      });
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.clientLowBalance, isFalse);
      await cubit.close();
    });

    test('endConsultation reports success and failure', () async {
      final cubit = build();
      await cubit.init();
      when(() => api.end('c1')).thenAnswer((_) async => _c(status: 'ended'));
      when(() => api.detail('c1')).thenAnswer((_) async => _c(status: 'ended'));
      expect(await cubit.endConsultation(), isTrue);
      expect(cubit.state.consultation?.isEnded, isTrue);

      when(() => api.end('c1')).thenThrow(Exception('409'));
      expect(await cubit.endConsultation(), isFalse);
      await cubit.close();
    });

    test('init can be retried after a failure', () async {
      when(() => api.detail('c1')).thenThrow(Exception('offline'));
      final cubit = build();
      await cubit.init();
      expect(cubit.state.consultation, isNull);
      expect(cubit.state.loading, isFalse);

      when(() => api.detail('c1')).thenAnswer((_) async => _c());
      await cubit.init();
      expect(cubit.state.consultation?.id, 'c1');
      await cubit.close();
    });
  });
}
