import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../../core/util/async_value.dart';
import '../../data/waitlist_api.dart';

class WaitlistState extends Equatable {
  const WaitlistState({
    this.entries = const AsyncValue.idle(),
    this.busy = const {},
  });

  final AsyncValue<List<WaitlistEntry>> entries;

  /// Ids with an invite or a removal in flight.
  final Set<String> busy;

  /// People in line — the badge on the Home tile.
  int get count => entries.value?.length ?? 0;

  WaitlistState copyWith({
    AsyncValue<List<WaitlistEntry>>? entries,
    Set<String>? busy,
  }) =>
      WaitlistState(entries: entries ?? this.entries, busy: busy ?? this.busy);

  @override
  List<Object?> get props => [entries, busy];
}

/// The astrologer's waitlist. App-level, so the Home tile can show how many
/// are waiting; a `queue.updated` frame — or a session starting or ending,
/// which moves the line — reloads it.
class WaitlistCubit extends Cubit<WaitlistState> {
  WaitlistCubit({required WaitlistApi api, required RealtimeClient realtime})
    : _api = api,
      super(const WaitlistState()) {
    _sub = realtime.events.listen((e) {
      if (e is QueueUpdated || e is ConsultationEvent) load();
    });
  }

  final WaitlistApi _api;
  StreamSubscription<RealtimeEvent>? _sub;

  Future<void> load() async {
    emit(state.copyWith(entries: AsyncValue.loading(state.entries.value)));
    AsyncValue<List<WaitlistEntry>> next;
    try {
      next = AsyncValue.data(await _api.list());
    } catch (e) {
      next = AsyncValue.error(friendlyError(e), state.entries.value);
    }
    if (!isClosed) emit(state.copyWith(entries: next));
  }

  /// Returns an error message, or null once the customer has been told.
  Future<String?> invite(String id) => _act(id, () async {
    final updated = await _api.invite(id);
    final list = state.entries.value ?? const <WaitlistEntry>[];
    emit(
      state.copyWith(
        entries: AsyncValue.data([
          for (final e in list) e.id == id ? updated : e,
        ]),
      ),
    );
  });

  /// Returns an error message, or null once they are off the list.
  Future<String?> remove(String id) => _act(id, () async {
    await _api.remove(id);
    final list = state.entries.value ?? const <WaitlistEntry>[];
    emit(
      state.copyWith(
        entries: AsyncValue.data([
          for (final e in list)
            if (e.id != id) e,
        ]),
      ),
    );
  });

  Future<String?> _act(String id, Future<void> Function() run) async {
    if (state.busy.contains(id)) return null;
    emit(state.copyWith(busy: {...state.busy, id}));
    String? error;
    try {
      await run();
    } catch (e) {
      error = friendlyError(e);
    }
    if (!isClosed) {
      emit(state.copyWith(busy: {...state.busy}..remove(id)));
    }
    return error;
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
