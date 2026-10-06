import 'dart:async';

import 'package:astro/src/core/realtime/realtime_client.dart';
import 'package:astro/src/core/realtime/realtime_event.dart';
import 'package:astro/src/features/consultations/data/consultation_api.dart';
import 'package:astro/src/features/consultations/data/models/consultation.dart';
import 'package:astro/src/features/home/presentation/cubit/tool_counts_cubit.dart';
import 'package:astro/src/features/predictions/data/predictions_repository.dart';
import 'package:astro/src/features/workspace/data/workspace_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockConsultations extends Mock implements ConsultationApi {}

class _MockPredictions extends Mock implements PredictionsRepository {}

class _MockRealtime extends Mock implements RealtimeClient {}

class _MockWorkspace extends Mock implements WorkspaceApi {}

/// Secure storage backed by a map.
class _Storage extends Mock implements FlutterSecureStorage {
  _Storage([Map<String, String>? seed]) : values = {...?seed} {
    when(
      () => read(key: any(named: 'key')),
    ).thenAnswer((i) async => values[i.namedArguments[#key] as String]);
    when(
      () => write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((i) async {
      values[i.namedArguments[#key] as String] =
          i.namedArguments[#value] as String;
    });
  }

  final Map<String, String> values;
}

Consultation _missed(String id, DateTime at) => Consultation.fromJson({
  'id': id,
  'channel': 'voice',
  'status': 'expired',
  'customer_name': 'Asha',
  'requested_at': at.toUtc().toIso8601String(),
});

void main() {
  late _MockConsultations consultations;
  late _MockPredictions predictions;
  late _MockWorkspace workspace;
  late StreamController<RealtimeEvent> events;
  final now = DateTime.now();

  setUp(() {
    consultations = _MockConsultations();
    predictions = _MockPredictions();
    workspace = _MockWorkspace();
    when(() => workspace.announcements()).thenAnswer((_) async => []);
    events = StreamController<RealtimeEvent>.broadcast();
    when(() => predictions.queue()).thenAnswer((_) async => []);
    when(
      () => consultations.list(
        channel: any(named: 'channel'),
        status: any(named: 'status'),
      ),
    ).thenAnswer(
      (_) async => [
        _missed('new', now.subtract(const Duration(minutes: 5))),
        _missed('old', now.subtract(const Duration(days: 3))),
      ],
    );
  });

  tearDown(() => events.close());

  ToolCountsCubit build(_Storage storage) {
    final rt = _MockRealtime();
    when(() => rt.events).thenAnswer((_) => events.stream);
    return ToolCountsCubit(
      consultations: consultations,
      predictions: predictions,
      workspace: workspace,
      storage: storage,
      realtime: rt,
    );
  }

  const key = 'ta_astro_calls_seen_at';

  test('counts only the calls missed since the list was last opened', () async {
    final storage = _Storage({
      key: now.subtract(const Duration(hours: 1)).toUtc().toIso8601String(),
    });
    final cubit = build(storage);
    await cubit.load();

    expect(cubit.state.missedCalls, 1);
    verify(
      () => consultations.list(
        channel: 'voice,video',
        status: any(named: 'status', that: contains('expired')),
      ),
    ).called(1);
    await cubit.close();
  });

  test('a first launch starts from zero, not from months of history', () async {
    final storage = _Storage();
    final cubit = build(storage);
    await cubit.load();

    expect(cubit.state.missedCalls, 0);
    expect(storage.values[key], isNotNull);
    await cubit.close();
  });

  test('opening call history clears the badge and remembers when', () async {
    final storage = _Storage({
      key: now.subtract(const Duration(hours: 1)).toUtc().toIso8601String(),
    });
    final cubit = build(storage);
    await cubit.load();
    expect(cubit.state.missedCalls, 1);

    await cubit.markCallsSeen();
    expect(cubit.state.missedCalls, 0);

    await cubit.load();
    expect(cubit.state.missedCalls, 0);
    await cubit.close();
  });

  test('one failing count leaves the other alone', () async {
    when(() => predictions.queue()).thenThrow(Exception('boom'));
    final cubit = build(
      _Storage({
        key: now.subtract(const Duration(hours: 1)).toUtc().toIso8601String(),
      }),
    );
    await cubit.load();

    expect(cubit.state.missedCalls, 1);
    expect(cubit.state.predictions, 0);
    await cubit.close();
  });

  test('a request timing out re-counts missed calls', () async {
    final cubit = build(
      _Storage({
        key: now.subtract(const Duration(hours: 1)).toUtc().toIso8601String(),
      }),
    );
    events.add(const RequestRemoved(consultationId: 'x', reason: 'expired'));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(cubit.state.missedCalls, 1);
    await cubit.close();
  });

  test('notices are unread until the list is opened', () async {
    when(() => workspace.announcements()).thenAnswer(
      (_) async => [
        Announcement.fromJson({
          'id': 'a1',
          'title': 'New payout cycle',
          'published_at': now.toUtc().toIso8601String(),
        }),
      ],
    );
    final cubit = build(_Storage());
    await cubit.load();
    expect(cubit.state.announcements, 1);

    await cubit.markAnnouncementsSeen();
    expect(cubit.state.announcements, 0);

    await cubit.load();
    expect(cubit.state.announcements, 0);
    await cubit.close();
  });
}
