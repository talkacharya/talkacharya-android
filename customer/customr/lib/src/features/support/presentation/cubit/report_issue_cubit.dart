import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../consultations/data/models/consultation.dart';
import '../../data/models/dispute.dart';
import '../../data/support_api.dart';
import '../../data/support_repository.dart';

enum ReportIssueStatus { loading, ready, submitting, submitted, failed }

/// "Report a problem" for one session:
///
///   loading → ready ⇄ submitting → submitted
///           ↘ ready (with [ReportIssueState.existing] — already reported)
///           ↘ failed (session couldn't load)
class ReportIssueCubit extends Cubit<ReportIssueState> {
  ReportIssueCubit({
    required SupportRepository repo,
    required String consultationId,
  }) : _repo = repo,
       _consultationId = consultationId,
       super(const ReportIssueState());

  final SupportRepository _repo;
  final String _consultationId;

  static const minDescription = 10;
  static const maxDescription = 2000;

  Future<void> load() async {
    emit(state.copyWith(status: ReportIssueStatus.loading, clearError: true));
    try {
      final results = await Future.wait([
        _repo.consultation(_consultationId),
        _repo.disputeFor(_consultationId),
      ]);
      final existing = results[1] as Dispute?;
      emit(
        state.copyWith(
          status: ReportIssueStatus.ready,
          consultation: results[0] as Consultation,
          existing: existing != null && existing.status.isOpen
              ? existing
              : null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ReportIssueStatus.failed, error: e));
    }
  }

  void selectType(DisputeType type) =>
      emit(state.copyWith(type: type, clearError: true));

  Future<void> submit(String description) async {
    final type = state.type;
    final text = description.trim();
    if (type == null ||
        text.length < minDescription ||
        state.status == ReportIssueStatus.submitting) {
      return;
    }
    emit(
      state.copyWith(status: ReportIssueStatus.submitting, clearError: true),
    );
    try {
      final dispute = await _repo.raise(
        consultationId: _consultationId,
        type: type,
        description: text,
      );
      emit(
        state.copyWith(status: ReportIssueStatus.submitted, submitted: dispute),
      );
    } on DisputeAlreadyOpen {
      final existing = await _repo
          .disputeFor(_consultationId)
          .catchError((Object _) => null);
      emit(state.copyWith(status: ReportIssueStatus.ready, existing: existing));
    } catch (e) {
      emit(state.copyWith(status: ReportIssueStatus.ready, error: e));
    }
  }
}

class ReportIssueState extends Equatable {
  const ReportIssueState({
    this.status = ReportIssueStatus.loading,
    this.consultation,
    this.type,
    this.existing,
    this.submitted,
    this.error,
  });

  final ReportIssueStatus status;
  final Consultation? consultation;
  final DisputeType? type;

  /// A report already in progress for this session — shown instead of the form.
  final Dispute? existing;
  final Dispute? submitted;
  final Object? error;

  ReportIssueState copyWith({
    ReportIssueStatus? status,
    Consultation? consultation,
    DisputeType? type,
    Dispute? existing,
    Dispute? submitted,
    Object? error,
    bool clearError = false,
  }) => ReportIssueState(
    status: status ?? this.status,
    consultation: consultation ?? this.consultation,
    type: type ?? this.type,
    existing: existing ?? this.existing,
    submitted: submitted ?? this.submitted,
    error: clearError ? null : (error ?? this.error),
  );

  @override
  List<Object?> get props => [
    status,
    consultation,
    type,
    existing,
    submitted,
    error,
  ];
}
