import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

void main() {
  test('Prediction.fromMap parses a customer payload', () {
    final p = Prediction.fromMap({
      'id': 'abc',
      'area': 'marriage_love',
      'period': 'year',
      'status': 'drafting',
      'birth_profile': 'bp-1',
      'profile_label': 'Me',
      'language': 'hi',
      'title': 'Shaadi',
      'body': 'one two three',
      'astrologer_name': 'Guru',
      'price_paid': '199.00',
      'currency': 'INR',
      'created_at': '2026-09-09T10:00:00Z',
      'due_at': '2026-09-12T10:00:00Z',
    });

    expect(p.id, 'abc');
    expect(p.area, PredictionArea.marriageLove);
    expect(p.period, PredictionPeriod.year);
    expect(p.status, PredictionStatus.drafting);
    expect(p.status.isOpen, isTrue);
    expect(p.status.isDelivered, isFalse);
    expect(p.bodyWordCount, 3);
    expect(p.dueAt, isNotNull);
    expect(p.factorBrief, isNull); // customer view never carries it
  });

  test('Prediction area/period round-trip through wire', () {
    for (final a in PredictionArea.values) {
      expect(PredictionArea.fromWire(a.wire), a);
    }
    for (final p in PredictionPeriod.values) {
      expect(PredictionPeriod.fromWire(p.wire), p);
    }
  });

  test('PredictionCatalog.fromMap reads packs, balance and subscription', () {
    final cat = PredictionCatalog.fromMap({
      'currency': 'INR',
      'credit_balance': 2,
      'packs': [
        {'pack': 1, 'credits': 1, 'price': '199'},
        {'pack': 3, 'credits': 3, 'price': '499'},
      ],
      'subscription': {
        'price': '299',
        'area': 'general',
        'period': 'year',
        'status': 'active',
        'renews_on': '2026-10-01',
      },
      'min_words': 120,
      'areas': [
        {'value': 'career', 'label': 'Career'},
      ],
      'periods': [
        {'value': 'month', 'label': 'The month ahead'},
      ],
    });

    expect(cat.hasCredits, isTrue);
    expect(cat.packs.length, 2);
    expect(cat.packs.first.credits, 1);
    expect(cat.subscribed, isTrue);
    expect(cat.subscriptionRenewsOn, '2026-10-01');
    expect(cat.areas.single.label, 'Career');
  });

  test('astrologer payload carries the brief', () {
    final p = Prediction.fromMap({
      'id': 'x',
      'area': 'career',
      'period': 'month',
      'status': 'drafting',
      'factor_brief': {
        'factors': {
          'lagna': {'sign': 'Leo', 'lord': 'Sun'},
        },
      },
    });
    expect(p.factorBrief, isNotNull);
    expect(
      (p.factorBrief!['factors'] as Map)['lagna'],
      containsPair('sign', 'Leo'),
    );
  });

  test('labels cover every enum value', () {
    for (final a in PredictionArea.values) {
      expect(PredictionLabels.areaTitle(a), isNotEmpty);
      expect(PredictionLabels.areaBlurb(a), isNotEmpty);
    }
    for (final s in PredictionStatus.values) {
      expect(PredictionLabels.statusLabel(s), isNotEmpty);
      expect(
        PredictionLabels.statusRole(s),
        anyOf('pending', 'done', 'warn'),
      );
    }
  });
}
