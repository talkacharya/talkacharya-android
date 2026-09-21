import 'package:astro/src/features/consultations/data/models/consultation.dart';
import 'package:astro/src/features/consultations/data/models/consultation_share.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _person(String id, String name, {String? time}) => {
  'id': id,
  'label': name,
  'full_name': name,
  'relation': 'self',
  'gender': 'male',
  'birth_date': '1994-05-12',
  'birth_time': time,
  'time_known': time != null,
  'birth_place': 'Mumbai',
};

void main() {
  group('shares on a consultation', () {
    test('a shared birth profile is parsed with its details', () {
      final c = Consultation.fromJson({
        'id': 'c1',
        'shares': [
          {
            'id': 's1',
            'kind': 'birth_profile',
            'shared_at': '2026-09-20T10:00:00Z',
            'birth_profile': _person('p1', 'Asha', time: '07:30'),
          },
        ],
      });

      final p = c.shares.single.person!;
      expect(p.name, 'Asha');
      expect(p.birthTime, '07:30');
      expect(p.timeKnown, isTrue);
      expect(p.birthPlace, 'Mumbai');
      expect(c.hasSharedDetails, isTrue);
      expect(c.sharedPeople.map((x) => x.id), ['p1']);
    });

    test('an unknown birth time is flagged', () {
      final c = Consultation.fromJson({
        'id': 'c1',
        'shares': [
          {
            'id': 's1',
            'kind': 'birth_profile',
            'birth_profile': _person('p1', 'Asha'),
          },
        ],
      });
      expect(c.shares.single.person!.timeKnown, isFalse);
    });

    test('a shared match exposes both people and the score', () {
      final c = Consultation.fromJson({
        'id': 'c1',
        'shares': [
          {
            'id': 's2',
            'kind': 'match',
            'match': {
              'id': 'm1',
              'total_points': '26.50',
              'max_points': '36',
              'verdict': 'Good match',
              'boy': _person('b1', 'Rahul'),
              'girl': _person('g1', 'Asha'),
            },
          },
        ],
      });

      final m = c.sharedMatches.single;
      expect(m.pointsLabel, '26.5');
      expect(m.maxLabel, '36');
      expect(m.ratio, closeTo(0.736, 0.001));
      // Both charts are openable from a shared match.
      expect(c.sharedPeople.map((p) => p.id), ['b1', 'g1']);
    });

    test('no shares means nothing to open', () {
      final c = Consultation.fromJson({'id': 'c1'});
      expect(c.shares, isEmpty);
      expect(c.hasSharedDetails, isFalse);
      expect(c.sharedPeople, isEmpty);
    });
  });

  group('MatchReport', () {
    test('parses the koota table, doshas and verdict text', () {
      final r = MatchReport.fromJson({
        'id': 'm1',
        'total_points': '26.50',
        'max_points': '36',
        'verdict': 'Good match',
        'boy': _person('b1', 'Rahul'),
        'girl': _person('g1', 'Asha'),
        'payload': {
          'message': {'description': 'A workable match.'},
          'koota': [
            {
              'key': 'nadi',
              'name': 'Nadi',
              'obtained_points': 0,
              'maximum_points': 8,
            },
            {
              'key': 'bhakoot',
              'name': 'Bhakoot',
              'obtained_points': 7,
              'maximum_points': 7,
            },
          ],
          'doshas': {'nadi': true, 'bhakoot': false, 'gana': false},
        },
      });

      expect(r.summary.verdict, 'Good match');
      expect(r.description, 'A workable match.');
      expect(r.kootas.first.isZero, isTrue);
      expect(r.kootas.last.ratio, 1);
      expect(r.doshas['nadi'], isTrue);
      expect(r.doshas['gana'], isFalse);
    });
  });
}
