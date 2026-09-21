import 'package:customr/src/features/consultations/data/models/consultation.dart';
import 'package:customr/src/features/consultations/data/pending_share.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _person(String id, String name, {String? time}) => {
  'id': id,
  'label': name,
  'full_name': name,
  'relation': 'self',
  'gender': 'female',
  'birth_date': '1994-05-12',
  'birth_time': time,
  'time_known': time != null,
  'birth_place': 'Mumbai',
};

void main() {
  group('consultation shares', () {
    test('parses shared profiles and matches', () {
      final c = Consultation.fromMap({
        'id': 'c1',
        'shares': [
          {
            'id': 's1',
            'kind': 'birth_profile',
            'birth_profile': _person('p1', 'Asha', time: '07:30'),
          },
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

      expect(c.shares, hasLength(2));
      expect(c.shares.first.person!.birthTime, '07:30');
      expect(c.shares.last.isMatch, isTrue);
      // The share sheet uses these to mark what's already shared.
      expect(c.sharedProfileIds, {'p1'});
      expect(c.sharedMatchIds, {'m1'});
    });

    test('an older consultation without shares is empty, not broken', () {
      final c = Consultation.fromMap({'id': 'c1'});
      expect(c.shares, isEmpty);
      expect(c.sharedProfileIds, isEmpty);
      expect(c.sharedMatchIds, isEmpty);
    });
  });

  group('PendingShare', () {
    test('holds one choice at a time and clears after booking', () {
      final pending = PendingShare()..setProfile('p1', label: 'Asha');
      expect(pending.birthProfileId, 'p1');
      expect(pending.isEmpty, isFalse);

      // Choosing a match replaces the profile choice.
      pending.setMatch('m1', label: 'Rahul & Asha');
      expect(pending.matchId, 'm1');
      expect(pending.birthProfileId, isNull);
      expect(pending.label, 'Rahul & Asha');

      pending.clear();
      expect(pending.isEmpty, isTrue);
      expect(pending.label, '');
    });
  });
}
