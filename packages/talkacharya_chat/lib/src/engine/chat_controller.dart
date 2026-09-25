import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/chat_enums.dart';
import '../models/chat_message.dart';
import '../models/chat_pin.dart';
import '../models/chat_presence.dart';
import '../ports/chat_outbox.dart';
import '../ports/chat_ports.dart';
import '../ports/stt_engine.dart';
import '../ports/tts_engine.dart';

part 'chat_session_state.dart';

/// The chat engine for one consultation. Realtime-primary: the `conv:` socket
/// drives updates; a slow poll runs only while the socket is down; REST is the
/// authoritative backfill on reconnect. Optimistic sends reconcile by
/// `clientMessageId`. Shared verbatim between the customer and astrologer apps.
class ChatController extends Cubit<ChatSessionState> {
  ChatController({
    required this.consultationId,
    required ChatTransport transport,
    required ChatRealtime realtime,
    required ChatIdentity identity,
    PickImages? pickImages,
    ChatOutbox? outbox,
    TtsEngine? tts,
    SttEngine? stt,
    ChatSounds sounds = const NoopChatSounds(),
  }) : _t = transport,
       _sounds = sounds,
       _rt = realtime,
       _id = identity,
       _pickImages = pickImages,
       _outbox = outbox ?? const NoopChatOutbox(),
       tts = tts ?? DeviceTtsEngine(),
       stt = stt ?? DeviceSttEngine(),
       super(const ChatSessionState());

  final String consultationId;
  final ChatTransport _t;
  final ChatRealtime _rt;
  final ChatIdentity _id;
  final PickImages? _pickImages;
  final ChatOutbox _outbox;
  final ChatSounds _sounds;
  final TtsEngine tts;
  final SttEngine stt;

  String get _channel => 'conv:$consultationId';
  String get _typingChannel => 'chattyping:$consultationId';
  ChatIdentity get identity => _id;

  /// Whether the composer should show an image-attach button.
  bool get canAttachImages => _pickImages != null;

  final _rng = Random();
  StreamSubscription<Map<String, dynamic>>? _frames;
  StreamSubscription<Map<String, dynamic>>? _typingFrames;
  StreamSubscription<ConnectionStatus>? _conn;
  StreamSubscription<PresenceEvent>? _presence;
  Timer? _poll;
  Timer? _typingStop;
  Timer? _otherTypingClear;
  Timer? _seenDebounce;
  bool _sentTyping = false;
  int _seenTarget = 0;

  // --- lifecycle ---------------------------------------------------------

  Future<void> start() async {
    emit(state.copyWith(loading: true, error: null));
    final pending = await _loadOutbox();
    try {
      final history = await _t.history(limit: 60);
      emit(
        state.copyWith(
          loading: false,
          messages: _sorted([...history, ...pending]),
          hasMoreOlder: history.length >= 60,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(loading: false, error: '$e', messages: _sorted(pending)),
      );
    }
    unawaited(loadPins());
    for (final m in pending) {
      final path = _localPathOf(m);
      if (path.isNotEmpty) {
        unawaited(_dispatchImage(m.clientMessageId, path));
      } else if (m.body.isNotEmpty) {
        unawaited(_dispatch(m.clientMessageId, body: m.body));
      }
    }

    _frames = _rt.frames(_channel).listen(_onFrame, onError: (_) {});
    _typingFrames = _rt
        .frames(_typingChannel)
        .listen(_onTypingFrame, onError: (_) {});
    _conn = _rt.connection.listen(_onConnection);
    _presence = _rt
        .presenceEvents(_channel)
        .listen(_onPresenceEvent, onError: (_) {});
    emit(state.copyWith(connection: _rt.connectionNow));

    unawaited(_refreshPresence());
    if (state.autoTranslate) unawaited(_translatePending());
    _seenTarget = state.lastSeq;
    _flushSeen();
    _syncPoll();
  }

  // --- realtime --------------------------------------------------------

  void _onFrame(Map<String, dynamic> frame) {
    final type = frame['type'] as String? ?? '';
    final data = (frame['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    switch (type) {
      case 'message.new':
        final m = ChatMessage.fromMap(data);
        if (m.senderRole != _id.role &&
            m.senderRole != ParticipantRole.system &&
            !_has(m)) {
          _sounds.incoming();
        }
        _merge(m);
        _bumpSeen();
      case 'message.pinned':
      case 'message.unpinned':
        unawaited(loadPins());
      case 'message.receipt':
        _applyReceipt(data);
      case 'typing':
        _applyTyping(data);
      case 'presence.leave':
      case 'presence.join':
        unawaited(_refreshPresence());
    }
  }

  /// The ephemeral `chattyping:` channel: clients publish a raw
  /// `{user_id, role, is_typing}` map straight to it (no frame envelope).
  void _onTypingFrame(Map<String, dynamic> raw) {
    final data = raw.containsKey('data')
        ? (raw['data'] as Map?)?.cast<String, dynamic>() ?? const {}
        : raw;
    _applyTyping(data);
  }

  void _applyTyping(Map<String, dynamic> data) {
    final role = roleFromString(data['role'] as String?);
    final byId = data['user_id']?.toString();
    if (role == _id.role || byId == _id.userId) return;
    _setOtherTyping(data['is_typing'] == true);
  }

  void _onConnection(ConnectionStatus status) {
    final was = state.connection;
    emit(state.copyWith(connection: status));
    if (status == ConnectionStatus.online && was != ConnectionStatus.online) {
      unawaited(_backfill());
      unawaited(_refreshPresence());
      _retryUnsent();
    }
    _syncPoll();
  }

  void _onPresenceEvent(PresenceEvent e) {
    if (e.userId == _id.userId) return;
    emit(
      state.copyWith(
        presence: state.presence.copyWith(
          otherOnline: e.joined,
          otherLastSeen: e.joined ? null : DateTime.now(),
        ),
      ),
    );
  }

  Future<void> _refreshPresence() async {
    try {
      final p = await _t.presence();
      emit(
        state.copyWith(
          presence: state.presence.copyWith(otherOnline: p.otherOnline),
        ),
      );
    } catch (_) {}
  }

  Future<void> _backfill() async {
    try {
      final fresh = await _t.history(afterSeq: state.lastSeq, limit: 100);
      for (final m in fresh) {
        _merge(m);
      }
      if (fresh.isNotEmpty) _bumpSeen();
    } catch (_) {}
  }

  // --- poll fallback (only while the socket is down) --------------------

  void _syncPoll() {
    final needPoll = state.connection != ConnectionStatus.online;
    if (needPoll && _poll == null) {
      _poll = Timer.periodic(const Duration(seconds: 15), (_) => _backfill());
    } else if (!needPoll) {
      _poll?.cancel();
      _poll = null;
    }
  }

  // --- sending --------------------------------------------------------

  Future<void> sendText(String text) async {
    final body = text.trim();
    if (body.isEmpty) return;
    final cmid = _clientId();
    final quoted = state.replyingTo;
    _merge(
      ChatMessage(
        id: cmid,
        clientMessageId: cmid,
        seq: state.lastSeq + 1,
        senderRole: _id.role,
        body: body,
        sourceLanguage: _id.language.split('-').first,
        // Shown on the optimistic bubble too, so the quote doesn't appear only
        // once the server answers.
        replyTo: quoted == null
            ? null
            : ChatReplyTo(
                seq: quoted.seq,
                senderRole: quoted.senderRole,
                type: quoted.type,
                body: quoted.body,
              ),
        createdAt: DateTime.now(),
        sendStatus: SendStatus.sending,
      ),
    );
    if (quoted != null) emit(state.copyWith(replyingTo: null));
    _persistOutbox();
    _stopTypingNow();
    await _dispatch(cmid, body: body, replyToSeq: quoted?.seq);
  }

  // --- replies + pins -------------------------------------------------

  /// Quote [message] in the composer. Null clears it.
  void replyTo(ChatMessage? message) =>
      emit(state.copyWith(replyingTo: message));

  Future<void> loadPins() async {
    try {
      // Fetch first, *then* read state: `state.copyWith(pins: await …)` would
      // capture the receiver before suspending and emit a snapshot from before
      // the request, throwing away anything sent while it was in flight.
      final pins = await _t.pins();
      emit(state.copyWith(pins: pins));
    } catch (_) {
      // a pin list that won't load is not worth an error in the room
    }
  }

  Future<void> pin(ChatMessage message) async {
    if (message.seq <= 0) return;
    try {
      await _t.pin(message.seq);
      await loadPins();
    } catch (_) {}
  }

  Future<void> unpin(int seq) async {
    try {
      await _t.unpin(seq);
      await loadPins();
    } catch (_) {}
  }

  Future<void> retry(ChatMessage failed) async {
    final localPath = failed.attachments
        .map((a) => a.localPath)
        .firstWhere((p) => p.isNotEmpty, orElse: () => '');
    if (localPath.isNotEmpty) {
      _patch(
        failed.dedupeKey,
        (m) => m.copyWith(sendStatus: SendStatus.sending),
      );
      await _dispatchImage(failed.clientMessageId, localPath);
      return;
    }
    if (failed.body.isEmpty) return;
    _patch(failed.dedupeKey, (m) => m.copyWith(sendStatus: SendStatus.sending));
    await _dispatch(failed.clientMessageId, body: failed.body);
  }

  Future<void> _dispatch(
    String cmid, {
    required String body,
    int? replyToSeq,
  }) async {
    try {
      final server = await _t.send(
        body: body,
        clientMessageId: cmid,
        replyToSeq: replyToSeq,
      );
      _merge(
        server.copyWith(clientMessageId: cmid, sendStatus: SendStatus.sent),
      );
      _sounds.sent();
    } catch (_) {
      _patch('c:$cmid', (m) => m.copyWith(sendStatus: SendStatus.failed));
    }
    _persistOutbox();
  }

  // --- image attachments ---------------------------------------------

  Future<void> attachImages(PickSource source) async {
    final pick = _pickImages;
    if (pick == null) return;
    List<String> paths;
    try {
      paths = await pick(source);
    } catch (_) {
      return;
    }
    for (final path in paths) {
      if (path.isEmpty) continue;
      final cmid = _clientId();
      _merge(
        ChatMessage(
          id: cmid,
          clientMessageId: cmid,
          seq: state.lastSeq + 1,
          senderRole: _id.role,
          type: 'image',
          createdAt: DateTime.now(),
          sendStatus: SendStatus.sending,
          attachments: [ChatAttachment(id: '', kind: 'image', localPath: path)],
        ),
      );
      unawaited(_dispatchImage(cmid, path));
    }
    _persistOutbox();
  }

  Future<void> _dispatchImage(String cmid, String path) async {
    try {
      final uploaded = await _t.uploadAttachment(path);
      final server = await _t.send(
        attachmentIds: [uploaded.id],
        clientMessageId: cmid,
      );
      _merge(
        server.copyWith(clientMessageId: cmid, sendStatus: SendStatus.sent),
      );
    } catch (_) {
      _patch('c:$cmid', (m) => m.copyWith(sendStatus: SendStatus.failed));
    }
    _persistOutbox();
  }

  Future<void> reportMessage(int seq, String reason) async {
    try {
      await _t.reportMessage(seq, reason);
    } catch (_) {}
  }

  void _retryUnsent() {
    for (final m in state.messages) {
      if (m.sendStatus != SendStatus.failed &&
          m.sendStatus != SendStatus.sending) {
        continue;
      }
      final localPath = m.attachments
          .map((a) => a.localPath)
          .firstWhere((p) => p.isNotEmpty, orElse: () => '');
      if (localPath.isNotEmpty) {
        unawaited(_dispatchImage(m.clientMessageId, localPath));
      } else if (m.body.isNotEmpty) {
        unawaited(_dispatch(m.clientMessageId, body: m.body));
      }
    }
  }

  // --- older-message pagination --------------------------------------

  Future<void> loadOlder() async {
    if (state.loadingOlder || !state.hasMoreOlder) return;
    final oldest = state.firstSeq;
    if (oldest <= 1) {
      emit(state.copyWith(hasMoreOlder: false));
      return;
    }
    emit(state.copyWith(loadingOlder: true));
    try {
      final page = await _t.history(beforeSeq: oldest, limit: 40);
      for (final m in page) {
        _merge(m);
      }
      emit(
        state.copyWith(loadingOlder: false, hasMoreOlder: page.length >= 40),
      );
    } catch (_) {
      emit(state.copyWith(loadingOlder: false));
    }
  }

  // --- typing --------------------------------------------------------

  void onComposerChanged(String value) {
    if (!_sentTyping && value.isNotEmpty) {
      _sentTyping = true;
      _emitTyping(true);
    }
    _typingStop?.cancel();
    _typingStop = Timer(const Duration(seconds: 3), _stopTypingNow);
  }

  void _stopTypingNow() {
    _typingStop?.cancel();
    if (_sentTyping) {
      _sentTyping = false;
      _emitTyping(false);
    }
  }

  void _emitTyping(bool isTyping) {
    // Prefer a direct publish to the ephemeral channel; fall back to the HTTP
    // relay when the socket is down.
    if (state.connection == ConnectionStatus.online) {
      unawaited(
        _rt.publish(_typingChannel, {
          'user_id': _id.userId,
          'role': _id.role.name,
          'is_typing': isTyping,
        }),
      );
    } else {
      unawaited(_t.sendTyping(isTyping));
    }
  }

  void _setOtherTyping(bool typing) {
    _otherTypingClear?.cancel();
    emit(state.copyWith(otherTyping: typing));
    if (typing) {
      _otherTypingClear = Timer(
        const Duration(seconds: 6),
        () => emit(state.copyWith(otherTyping: false)),
      );
    }
  }

  // --- receipts (driven by the list as messages become visible) --------

  void markSeen(int seq) {
    if (seq <= _seenTarget) return;
    _seenTarget = seq;
    _seenDebounce?.cancel();
    _seenDebounce = Timer(const Duration(milliseconds: 500), _flushSeen);
  }

  void _bumpSeen() => markSeen(state.lastSeq);

  void _flushSeen() {
    final target = _seenTarget;
    if (target <= 0) return;
    final incoming = state.messages.where(
      (m) =>
          m.senderRole != _id.role &&
          !m.isSystem &&
          m.seq > 0 &&
          m.seq <= target,
    );
    if (incoming.isEmpty) return;
    unawaited(_t.markDelivered(target));
    unawaited(_t.markRead(target));
  }

  void _applyReceipt(Map<String, dynamic> data) {
    final by = roleFromString(data['by'] as String?);
    if (by == _id.role) return; // it's the other side acknowledging my messages
    final upTo = (data['up_to_seq'] as num?)?.toInt() ?? (1 << 30);
    final read = data['state'] == 'read';
    emit(
      state.copyWith(
        messages: [
          for (final m in state.messages)
            (m.senderRole == _id.role && m.seq > 0 && m.seq <= upTo)
                ? m.copyWith(
                    deliveredAt: m.deliveredAt ?? DateTime.now(),
                    readAt: read ? (m.readAt ?? DateTime.now()) : m.readAt,
                  )
                : m,
        ],
      ),
    );
  }

  // --- translation --------------------------------------------------

  Future<void> setAutoTranslate(bool on) async {
    emit(state.copyWith(autoTranslate: on));
    if (on) await _translatePending();
  }

  Future<void> translateOne(int seq) async {
    final m = state.messages.firstWhere(
      (x) => x.seq == seq,
      orElse: () => const ChatMessage(id: ''),
    );
    if (m.id.isEmpty || m.hasTranslationFor(_id.language)) return;
    await _fetchTranslation(m);
  }

  Future<void> _translatePending() async {
    final lang = _id.language.split('-').first;
    final todo = state.messages.where(
      (m) =>
          m.senderRole != _id.role &&
          !m.isSystem &&
          m.body.isNotEmpty &&
          m.sourceLanguage.isNotEmpty &&
          m.sourceLanguage != lang &&
          !m.hasTranslationFor(lang),
    );
    for (final m in todo.take(20)) {
      await _fetchTranslation(m);
    }
  }

  Future<void> _fetchTranslation(ChatMessage m) async {
    try {
      final text = await _t.translate(m.seq, _id.language);
      if (text == null) return;
      _patch(m.dedupeKey, (x) {
        final lang = _id.language.split('-').first;
        return x.copyWith(translations: {...x.translations, lang: text});
      });
    } catch (_) {}
  }

  // --- TTS / dictation ---------------------------------------------

  Future<void> speak(ChatMessage m) => tts.speak(
    m.bodyFor(_id.language, preferTranslation: state.autoTranslate),
    language: _id.language,
  );

  Future<void> stopSpeaking() => tts.stop();

  Future<void> beginDictation(void Function(String) onText) async {
    if (!_id.canDictate) return;
    await stt.start(
      language: _id.language,
      onResult: (transcript, _) => onText(transcript),
    );
  }

  Future<void> endDictation() => stt.stop();

  // --- message list helpers -------------------------------------------

  bool _has(ChatMessage m) => state.messages.any(
    (x) =>
        (m.id.isNotEmpty && x.id == m.id) ||
        (m.clientMessageId.isNotEmpty &&
            x.clientMessageId == m.clientMessageId),
  );

  void _merge(ChatMessage incoming) {
    final list = [...state.messages];
    int i = -1;
    if (incoming.clientMessageId.isNotEmpty) {
      i = list.indexWhere((x) => x.clientMessageId == incoming.clientMessageId);
    }
    if (i < 0 && incoming.id.isNotEmpty) {
      i = list.indexWhere((x) => x.id == incoming.id);
    }
    if (i >= 0) {
      final prev = list[i];
      list[i] = incoming.copyWith(
        sendStatus: incoming.sendStatus == SendStatus.sending
            ? prev.sendStatus
            : SendStatus.sent,
        // keep any translation we already fetched
        translations: {...prev.translations, ...incoming.translations},
        deliveredAt: incoming.deliveredAt ?? prev.deliveredAt,
        readAt: incoming.readAt ?? prev.readAt,
      );
    } else {
      list.add(incoming);
    }
    emit(state.copyWith(messages: _sorted(list)));
    if (state.autoTranslate && incoming.senderRole != _id.role) {
      unawaited(_fetchTranslation(incoming));
    }
  }

  void _patch(String dedupeKey, ChatMessage Function(ChatMessage) f) {
    emit(
      state.copyWith(
        messages: [
          for (final m in state.messages) m.dedupeKey == dedupeKey ? f(m) : m,
        ],
      ),
    );
  }

  List<ChatMessage> _sorted(List<ChatMessage> l) {
    final copy = [...l]
      ..sort((a, b) {
        if (a.seq != 0 && b.seq != 0) return a.seq.compareTo(b.seq);
        final at = a.createdAt ?? DateTime(2000);
        final bt = b.createdAt ?? DateTime(2000);
        return at.compareTo(bt);
      });
    return copy;
  }

  String _clientId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${_rng.nextInt(1 << 32)}';

  // --- outbox (survives a full app-kill mid-send) --------------------

  String _localPathOf(ChatMessage m) => m.attachments
      .map((a) => a.localPath)
      .firstWhere((p) => p.isNotEmpty, orElse: () => '');

  Future<List<ChatMessage>> _loadOutbox() async {
    try {
      return await _outbox.load(consultationId);
    } catch (_) {
      return const [];
    }
  }

  void _persistOutbox() {
    final unsent = state.messages
        .where(
          (m) =>
              m.clientMessageId.isNotEmpty &&
              (m.sendStatus == SendStatus.sending ||
                  m.sendStatus == SendStatus.failed),
        )
        .toList();
    unawaited(_outbox.save(consultationId, unsent));
  }

  @override
  Future<void> close() async {
    await _frames?.cancel();
    await _typingFrames?.cancel();
    await _conn?.cancel();
    await _presence?.cancel();
    _poll?.cancel();
    _typingStop?.cancel();
    _otherTypingClear?.cancel();
    _seenDebounce?.cancel();
    _stopTypingNow();
    tts.dispose();
    stt.dispose();
    return super.close();
  }
}
