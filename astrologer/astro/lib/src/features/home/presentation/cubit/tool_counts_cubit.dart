import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../call_history/presentation/view/call_history_page.dart';
import '../../../consultations/data/consultation_api.dart';
import '../../../predictions/data/predictions_repository.dart';
import '../../../workspace/data/workspace_api.dart';

class ToolCountsState extends Equatable {
  const ToolCountsState({
    this.missedCalls = 0,
    this.predictions = 0,
    this.announcements = 0,
  });

  /// Calls that got away since Call history was last opened.
  final int missedCalls;

  /// Predictions waiting in the work queue.
  final int predictions;

  /// Notices published since the list was last read.
  final int announcements;

  ToolCountsState copyWith({
    int? missedCalls,
    int? predictions,
    int? announcements,
  }) => ToolCountsState(
    missedCalls: missedCalls ?? this.missedCalls,
    predictions: predictions ?? this.predictions,
    announcements: announcements ?? this.announcements,
  );

  @override
  List<Object?> get props => [missedCalls, predictions, announcements];
}

/// Badge counts for the Home tools that no other app-level cubit already
/// holds. (Requests, chats, notifications and the waitlist read theirs from
/// their own cubits.) Each count loads on its own; one that fails stays as it
/// was rather than taking the other down.
class ToolCountsCubit extends Cubit<ToolCountsState> {
  ToolCountsCubit({
    required ConsultationApi consultations,
    required PredictionsRepository predictions,
    required WorkspaceApi workspace,
    required FlutterSecureStorage storage,
    required RealtimeClient realtime,
  }) : _consultations = consultations,
       _predictions = predictions,
       _workspace = workspace,
       _storage = storage,
       super(const ToolCountsState()) {
    _sub = realtime.events.listen((e) {
      // A request timing out, or one being declined, may be a new missed call.
      if (e is RequestRemoved || e is ConsultationEvent) _loadMissedCalls();
    });
  }

  final ConsultationApi _consultations;
  final PredictionsRepository _predictions;
  final WorkspaceApi _workspace;
  final FlutterSecureStorage _storage;
  StreamSubscription<RealtimeEvent>? _sub;

  static const _seenKey = 'ta_astro_calls_seen_at';
  static const _noticesKey = 'ta_astro_notices_seen_at';

  Future<void> load() => Future.wait([
    _loadMissedCalls(),
    _loadPredictions(),
    _loadAnnouncements(),
  ]);

  /// Unlike missed calls, a first launch counts every notice on show: they
  /// are few, current, and written to be read.
  Future<void> _loadAnnouncements() async {
    try {
      final seen = DateTime.tryParse(
        await _storage.read(key: _noticesKey) ?? '',
      );
      final notices = await _workspace.announcements();
      final fresh = notices.where((n) {
        final at = n.publishedAt;
        return seen == null || (at != null && at.isAfter(seen));
      }).length;
      if (!isClosed) emit(state.copyWith(announcements: fresh));
    } catch (_) {}
  }

  /// Announcements were opened: everything published so far has been read.
  Future<void> markAnnouncementsSeen() async {
    emit(state.copyWith(announcements: 0));
    try {
      await _storage.write(
        key: _noticesKey,
        value: DateTime.now().toUtc().toIso8601String(),
      );
    } catch (_) {}
  }

  Future<void> _loadMissedCalls() async {
    try {
      final seen = await _seenAt();
      final calls = await _consultations.list(
        channel: 'voice,video',
        status: kMissedCallStatuses.join(','),
      );
      final fresh = calls.where((c) {
        final at = c.requestedAt;
        return at != null && at.isAfter(seen);
      }).length;
      if (!isClosed) emit(state.copyWith(missedCalls: fresh));
    } catch (_) {}
  }

  Future<void> _loadPredictions() async {
    try {
      final queue = await _predictions.queue();
      if (!isClosed) emit(state.copyWith(predictions: queue.length));
    } catch (_) {}
  }

  /// Call history was opened: everything missed so far has been seen.
  Future<void> markCallsSeen() async {
    emit(state.copyWith(missedCalls: 0));
    try {
      await _storage.write(
        key: _seenKey,
        value: DateTime.now().toUtc().toIso8601String(),
      );
    } catch (_) {}
  }

  /// When Call history was last opened. The first time ever, that is "now":
  /// a fresh install must not greet the astrologer with months of old misses.
  Future<DateTime> _seenAt() async {
    final stored = DateTime.tryParse(await _storage.read(key: _seenKey) ?? '');
    if (stored != null) return stored;
    final now = DateTime.now().toUtc();
    await _storage.write(key: _seenKey, value: now.toIso8601String());
    return now;
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
