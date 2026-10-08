import 'package:astro/src/core/deeplink/deep_link_parser.dart';
import 'package:astro/src/features/reports/data/reports_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> row({
    bool canRespond = true,
    Map<String, dynamic>? mine,
    Map<String, dynamic>? outcome,
    String status = 'open',
  }) => {
    'id': 'r1',
    'type': 'quality',
    'description': 'The reading was rushed.',
    'status': status,
    'created_at': '2026-10-08T05:00:00Z',
    'response_due_at': '2026-10-10T05:00:00Z',
    'can_respond': canRespond,
    'my_response': mine,
    'consultation': {
      'id': 'c1',
      'channel': 'voice',
      'customer_name': 'Asha',
      'started_at': '2026-10-07T12:00:00Z',
      'billed_seconds': 245,
      'gross_amount': '122.50',
      'currency': 'INR',
    },
    'outcome': outcome,
  };

  test('an open report waiting for the astrologer', () {
    final r = SessionReport.fromJson(row());
    expect(r.canRespond, isTrue);
    expect(r.decided, isFalse);
    expect(r.myResponse, isNull);
    expect(r.customerName, 'Asha');
    expect(r.channel, 'voice');
    expect(r.billedSeconds, 245);
    expect(r.grossAmount, 122.5);
    expect(r.responseDueAt, isNotNull);
  });

  test('a reply once sent is carried with when it was sent', () {
    final r = SessionReport.fromJson(
      row(
        canRespond: false,
        mine: {'text': 'They left early.', 'at': '2026-10-08T06:00:00Z'},
      ),
    );
    expect(r.myResponse, 'They left early.');
    expect(r.myResponseAt, isNotNull);
    expect(r.canRespond, isFalse);
  });

  test('a decision that cost the astrologer says how much', () {
    final r = SessionReport.fromJson(
      row(
        canRespond: false,
        status: 'resolved',
        outcome: {
          'kind': 'penalty',
          'deducted_amount': '85.75',
          'currency': 'INR',
          'note': 'Astrologer at fault.',
          'decided_at': '2026-10-09T05:00:00Z',
        },
      ),
    );
    expect(r.decided, isTrue);
    expect(r.outcome!.kind, 'penalty');
    expect(r.outcome!.deductedAmount, 85.75);
    expect(r.outcome!.note, 'Astrologer at fault.');
  });

  test('a decision that cost nothing carries no amount', () {
    final r = SessionReport.fromJson(
      row(
        canRespond: false,
        status: 'rejected',
        outcome: {'kind': 'none', 'deducted_amount': null, 'note': ''},
      ),
    );
    expect(r.outcome!.kind, 'none');
    expect(r.outcome!.deductedAmount, isNull);
  });

  test('a push about a report opens that report', () {
    expect(locationForRaw('talkacharya://disputes/abc-1'), '/reports/abc-1');
    expect(locationForRaw('talkacharya://disputes'), '/reports');
  });
}
