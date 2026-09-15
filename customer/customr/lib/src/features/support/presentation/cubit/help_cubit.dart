import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/async_value.dart';
import '../../../consultations/data/models/consultation.dart';
import '../../data/models/dispute.dart';
import '../../data/support_repository.dart';

/// The Help hub: the customer's reports + recent sessions they could report.
/// Each slice loads and fails on its own (the contact + FAQ sections are static).
class HelpCubit extends Cubit<HelpState> {
  HelpCubit(this._repo) : super(const HelpState());

  final SupportRepository _repo;

  Future<void> load() => Future.wait([_loadDisputes(), _loadSessions()]);

  Future<void> _loadDisputes() async {
    emit(state.copyWith(disputes: AsyncValue.loading(state.disputes.value)));
    try {
      final list = await _repo.disputes();
      emit(state.copyWith(disputes: AsyncValue.data(list)));
    } catch (e) {
      emit(
        state.copyWith(disputes: AsyncValue.error('$e', state.disputes.value)),
      );
    }
  }

  Future<void> _loadSessions() async {
    emit(state.copyWith(sessions: AsyncValue.loading(state.sessions.value)));
    try {
      final list = await _repo.reportableSessions();
      emit(state.copyWith(sessions: AsyncValue.data(list)));
    } catch (e) {
      emit(
        state.copyWith(sessions: AsyncValue.error('$e', state.sessions.value)),
      );
    }
  }
}

class HelpState extends Equatable {
  const HelpState({
    this.disputes = const AsyncValue.idle(),
    this.sessions = const AsyncValue.idle(),
  });

  final AsyncValue<List<Dispute>> disputes;
  final AsyncValue<List<Consultation>> sessions;

  /// Session id → its newest report, so a session row can say "Reported".
  Map<String, Dispute> get disputeBySession => {
    for (final d in (disputes.value ?? const <Dispute>[]).reversed)
      d.consultation.id: d,
  };

  HelpState copyWith({
    AsyncValue<List<Dispute>>? disputes,
    AsyncValue<List<Consultation>>? sessions,
  }) => HelpState(
    disputes: disputes ?? this.disputes,
    sessions: sessions ?? this.sessions,
  );

  @override
  List<Object?> get props => [disputes, sessions];
}
