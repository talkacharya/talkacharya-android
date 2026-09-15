import '../../consultations/data/consultation_repository.dart';
import '../../consultations/data/models/consultation.dart';
import 'models/dispute.dart';
import 'support_api.dart';

class SupportRepository {
  SupportRepository({
    required SupportApi api,
    required ConsultationRepository consultations,
  }) : _api = api,
       _consultations = consultations;

  final SupportApi _api;
  final ConsultationRepository _consultations;

  Future<List<Dispute>> disputes() => _api.disputes();

  Future<Dispute> dispute(String id) => _api.dispute(id);

  /// The newest report for one session, or `null` if it was never reported.
  Future<Dispute?> disputeFor(String consultationId) async {
    final list = await _api.disputes(consultationId: consultationId);
    return list.isEmpty ? null : list.first;
  }

  Future<Dispute> raise({
    required String consultationId,
    required DisputeType type,
    required String description,
  }) => _api.raise(
    consultationId: consultationId,
    type: type,
    description: description.trim(),
  );

  /// Sessions that can be reported: ended ones that actually ran, newest first.
  Future<List<Consultation>> reportableSessions({int limit = 5}) async {
    final list = await _consultations.list(status: 'ended');
    final ran = list.where((c) => c.billedSeconds > 0).toList()
      ..sort(
        (a, b) =>
            (b.endedAt ?? DateTime(0)).compareTo(a.endedAt ?? DateTime(0)),
      );
    return ran.take(limit).toList();
  }

  Future<Consultation> consultation(String id) => _consultations.detail(id);
}
