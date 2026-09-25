import 'consultation_api.dart';
import 'models/consultation.dart';
import 'models/conversation.dart';

/// Consultation lifecycle (request / detail / list / cancel / end / review).
/// The live chat stream is owned by `talkacharya_chat`'s `ChatController` via
/// `DioChatTransport` — not this repo.
class ConsultationRepository {
  ConsultationRepository(this._api);

  final ConsultationApi _api;

  Future<Consultation> request({
    required String astrologerId,
    required String channel,
    String? birthProfileId,
    String? matchId,
    String question = '',
  }) => _api.request(
    astrologerId: astrologerId,
    channel: channel,
    birthProfileId: birthProfileId,
    matchId: matchId,
    question: question,
  );

  /// Share a birth profile or a match with the astrologer mid-session.
  Future<Consultation> share(
    String id, {
    String? birthProfileId,
    String? matchId,
  }) => _api.share(id, birthProfileId: birthProfileId, matchId: matchId);

  Future<Consultation> detail(String id) => _api.detail(id);
  Future<List<Consultation>> list({String? status}) =>
      _api.list(status: status);

  /// The chats list — one thread per astrologer, not one per consultation.
  Future<List<Conversation>> conversations() => _api.conversations();
  Future<Conversation> conversation(String id) => _api.conversation(id);
  Future<Consultation> cancel(String id) => _api.cancel(id);
  Future<Consultation> end(String id) => _api.end(id);
  Future<void> review(String id, {required int rating, String text = ''}) =>
      _api.review(id, rating: rating, text: text);
}
