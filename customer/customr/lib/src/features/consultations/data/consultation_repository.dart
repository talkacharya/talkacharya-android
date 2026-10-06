import 'dart:async';

import 'consultation_api.dart';
import 'models/consultation.dart';
import 'models/conversation.dart';

/// Consultation lifecycle (request / detail / list / cancel / end / review).
/// The live chat stream is owned by `talkacharya_chat`'s `ChatController` via
/// `DioChatTransport` — not this repo.
class ConsultationRepository {
  ConsultationRepository(this._api);

  final ConsultationApi _api;
  final _conversationCache = <String, Conversation>{};
  final _detailCache = <String, Consultation>{};

  void _cacheConversation(Conversation c) {
    _conversationCache[c.id] = c;
    if (c.lastConsultationId != null) {
      _conversationCache[c.lastConsultationId!] = c;
    }
    if (c.pendingConsultationId != null) {
      _conversationCache[c.pendingConsultationId!] = c;
    }
  }

  void _cacheConsultation(Consultation c) {
    _detailCache[c.id] = c;
  }

  Future<Consultation> request({
    required String astrologerId,
    required String channel,
    String? birthProfileId,
    String? matchId,
    String question = '',
  }) async {
    final c = await _api.request(
      astrologerId: astrologerId,
      channel: channel,
      birthProfileId: birthProfileId,
      matchId: matchId,
      question: question,
    );
    _cacheConsultation(c);
    return c;
  }

  Future<Conversation> setPreferences(
    String threadId, {
    bool? muted,
    bool? archived,
    bool? blocked,
  }) async {
    final updated = await _api.setPreferences(
      threadId,
      muted: muted,
      archived: archived,
      blocked: blocked,
    );
    _cacheConversation(updated);
    return updated;
  }

  /// Another session inside an existing thread, straight from the room.
  Future<Consultation> consultAgain(
    String threadId, {
    String channel = 'chat',
  }) async {
    final c = await _api.consultAgain(threadId, channel: channel);
    _cacheConsultation(c);
    return c;
  }

  /// Share a birth profile or a match with the astrologer mid-session.
  Future<Consultation> share(
    String id, {
    String? birthProfileId,
    String? matchId,
  }) async {
    final c = await _api.share(id, birthProfileId: birthProfileId, matchId: matchId);
    _cacheConsultation(c);
    return c;
  }

  Future<Consultation> detail(String id) async {
    final cached = _detailCache[id];
    if (cached != null) {
      unawaited(_api.detail(id).then((fresh) {
        _cacheConsultation(fresh);
      }).catchError((_) {}));
      return cached;
    }
    final fresh = await _api.detail(id);
    _cacheConsultation(fresh);
    return fresh;
  }

  Future<List<Consultation>> list({String? status}) =>
      _api.list(status: status);

  /// The chats list — one thread per astrologer, not one per consultation.
  Future<List<Conversation>> conversations() async {
    final list = await _api.conversations();
    for (final c in list) {
      _cacheConversation(c);
    }
    return list;
  }

  Future<Conversation> conversation(String id) async {
    final cached = _conversationCache[id];
    if (cached != null) {
      unawaited(_api.conversation(id).then((fresh) {
        _cacheConversation(fresh);
      }).catchError((_) {}));
      return cached;
    }
    final fresh = await _api.conversation(id);
    _cacheConversation(fresh);
    return fresh;
  }

  Future<List<int>> transcript(String threadId, {String? consultationId}) =>
      _api.transcript(threadId, consultationId: consultationId);

  Future<Consultation> upgradeChannel(String id, String channel) async {
    final c = await _api.upgradeChannel(id, channel);
    _cacheConsultation(c);
    return c;
  }

  Future<Consultation> cancel(String id) async {
    final c = await _api.cancel(id);
    _cacheConsultation(c);
    return c;
  }

  Future<Consultation> end(String id) async {
    final c = await _api.end(id);
    _cacheConsultation(c);
    return c;
  }

  Future<void> review(String id, {required int rating, String text = ''}) =>
      _api.review(id, rating: rating, text: text);
}
