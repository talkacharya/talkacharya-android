import 'dart:async';

import 'package:flutter/widgets.dart';

import 'assistant_models.dart';
import 'assistant_store.dart';

/// One assistant room: what is in it, what the composer may do, and sending.
///
/// The app supplies the network calls (its own Dio, errors and auth), the
/// realtime frames for this person and the phone's [AssistantStore]; the
/// controller keeps the list in order, sends optimistically, and catches up —
/// on a frame, every [pollEvery] while open, and when the app comes back to the
/// front — so a dropped socket only ever delays a message, never loses it.
///
/// The phone is the history: the room opens on what is stored, everything the
/// server hands over is stored, and older pages come from the phone first. The
/// server keeps a message only long enough to deliver it.
class AssistantRoomController extends ChangeNotifier {
  AssistantRoomController({
    required this.myRole,
    required Future<AssistantDetail> Function() load,
    required Future<List<AssistantMessage>> Function(String afterId) loadAfter,
    required Future<List<AssistantMessage>> Function(String beforeId)
    loadBefore,
    required Future<AssistantMessage> Function(String body) send,
    Stream<AssistantIncoming>? incoming,
    AssistantStore? store,
    String? threadId,
    this.pollEvery = const Duration(seconds: 20),
  }) : _store = store ?? MemoryAssistantStore(),
       _knownThreadId = threadId,
       _load = load,
       _loadAfter = loadAfter,
       _loadBefore = loadBefore,
       _send = send,
       _incoming = incoming;

  /// `customer` or `astrologer` — which side of the bubbles is "mine".
  final String myRole;
  final Duration pollEvery;

  final Future<AssistantDetail> Function() _load;
  final Future<List<AssistantMessage>> Function(String afterId) _loadAfter;
  final Future<List<AssistantMessage>> Function(String beforeId) _loadBefore;
  final Future<AssistantMessage> Function(String body) _send;
  final Stream<AssistantIncoming>? _incoming;
  final AssistantStore _store;

  /// The thread, when the page knows it before the server says (opened from
  /// a push or the inbox): the stored history shows at once.
  final String? _knownThreadId;

  String? get _threadId => thread?.id ?? _knownThreadId;

  bool loading = true;
  Object? loadError;
  AssistantThread? thread;
  AssistantComposerState composer = AssistantComposerState.open;
  int maxLength = 1000;

  /// Oldest first.
  List<AssistantMessage> messages = const [];
  bool loadingOlder = false;
  bool reachedStart = false;

  /// The last send that failed, for the app to say why.
  Object? sendError;

  StreamSubscription<AssistantIncoming>? _sub;
  Timer? _poll;
  AppLifecycleListener? _lifecycle;
  bool _catchingUp = false;
  bool _disposed = false;
  int _localSeq = 0;

  static const _pageSize = 50;

  Future<void> start() async {
    final id = _knownThreadId;
    if (id != null) {
      try {
        final stored = await _store.latest(id, limit: _pageSize);
        if (stored.isNotEmpty) {
          messages = stored;
          loading = false;
          _notify();
        }
      } catch (_) {}
    }
    await reload();
    _sub = _incoming?.listen(_onIncoming);
    _poll = Timer.periodic(pollEvery, (_) => catchUp());
    _lifecycle = AppLifecycleListener(onResume: catchUp);
  }

  Future<void> reload() async {
    loading = messages.isEmpty;
    loadError = null;
    _notify();
    try {
      final d = await _load();
      thread = d.thread;
      composer = d.composer;
      maxLength = d.maxLength;
      await _keep(d.messages);
      // What the phone has, then whatever the server still holds on top.
      var stored = const <AssistantMessage>[];
      try {
        stored = await _store.latest(d.thread.id, limit: _pageSize);
      } catch (_) {}
      final byId = {
        for (final m in [...stored, ...d.messages]) m.id: m,
        for (final m in messages.where((m) => !m.pending && !m.failed)) m.id: m,
      };
      final confirmed = byId.values.toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      final local = messages.where((m) => m.pending || m.failed);
      messages = [...confirmed, ...local];
      reachedStart = false;
    } catch (e) {
      loadError = e;
    }
    loading = false;
    _notify();
  }

  String? get _lastConfirmedId {
    for (final m in messages.reversed) {
      if (!m.pending && !m.failed) return m.id;
    }
    return null;
  }

  /// Anything new since the last message we have.
  Future<void> catchUp() async {
    if (_catchingUp || _disposed || thread == null) return;
    final after = _lastConfirmedId;
    if (after == null) return reload();
    _catchingUp = true;
    try {
      _merge(await _loadAfter(after));
    } catch (_) {
      // Next tick, or the next frame, tries again.
    }
    _catchingUp = false;
  }

  Future<void> loadOlder() async {
    if (loadingOlder || reachedStart || messages.isEmpty) return;
    final first = messages.firstWhere(
      (m) => !m.pending && !m.failed,
      orElse: () => messages.first,
    );
    loadingOlder = true;
    _notify();
    final id = _threadId;
    try {
      // The phone first; the server only for what it still has and we don't.
      var older = id == null
          ? const <AssistantMessage>[]
          : await _store.before(id, first.createdAt, limit: _pageSize);
      if (older.length < _pageSize) {
        final fromServer = await _loadBefore(first.id);
        await _keep(fromServer);
        final have = {for (final m in older) m.id};
        older = [...fromServer.where((m) => !have.contains(m.id)), ...older]
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        reachedStart =
            fromServer.length < _pageSize && older.length < _pageSize;
      }
      final known = {for (final m in messages) m.id};
      messages = [...older.where((m) => !known.contains(m.id)), ...messages];
      if (older.isEmpty) reachedStart = true;
    } catch (_) {}
    loadingOlder = false;
    _notify();
  }

  void _onIncoming(AssistantIncoming e) {
    if (e.threadId != thread?.id) return;
    final m = e.message;
    // Our own message coming back on our channel: the send's own reply
    // places it, unless it already has.
    if (m.senderRole == myRole &&
        messages.any((x) => x.pending && x.body == m.body)) {
      return;
    }
    _merge([m]);
    // A reply from the astrologer reopens a composer that was waiting on one.
    if (m.senderRole != myRole &&
        composer == AssistantComposerState.waitForReply) {
      composer = AssistantComposerState.open;
      _notify();
    }
  }

  void _merge(List<AssistantMessage> incoming) {
    if (incoming.isEmpty) return;
    final known = {for (final m in messages) m.id};
    final fresh = incoming.where((m) => !known.contains(m.id)).toList();
    if (fresh.isEmpty) return;
    unawaited(_keep(fresh));
    final confirmed = messages.where((m) => !m.pending && !m.failed);
    final local = messages.where((m) => m.pending || m.failed);
    messages = [...confirmed, ...fresh, ...local]
      ..sort((a, b) {
        // Local ones stay at the bottom until the server confirms them.
        final la = a.pending || a.failed, lb = b.pending || b.failed;
        if (la != lb) return la ? 1 : -1;
        return a.createdAt.compareTo(b.createdAt);
      });
    if (fresh.any((m) => m.senderRole != myRole) &&
        composer == AssistantComposerState.waitForReply) {
      composer = AssistantComposerState.open;
    }
    _notify();
  }

  bool get canSend => composer == AssistantComposerState.open;

  Future<void> sendText(String text) async {
    final body = text.trim();
    if (body.isEmpty || !canSend) return;
    final local = AssistantMessage(
      id: 'local-${_localSeq++}',
      senderRole: myRole,
      body: body,
      createdAt: DateTime.now(),
      pending: true,
    );
    messages = [...messages, local];
    sendError = null;
    _notify();
    await _deliver(local);
  }

  Future<void> retry(AssistantMessage failed) async {
    if (!failed.failed) return;
    messages = [
      for (final m in messages)
        m.id == failed.id ? m.copyWith(pending: true, failed: false) : m,
    ];
    sendError = null;
    _notify();
    await _deliver(failed.copyWith(pending: true, failed: false));
  }

  /// Drops a message that would not send.
  void discard(AssistantMessage failed) {
    messages = messages.where((m) => m.id != failed.id).toList();
    _notify();
  }

  Future<void> _deliver(AssistantMessage local) async {
    try {
      final sent = await _send(local.body);
      unawaited(_keep([sent]));
      final already = messages.any((m) => m.id == sent.id);
      messages = [
        for (final m in messages)
          if (m.id == local.id) ...[if (!already) sent] else m,
      ];
    } catch (e) {
      sendError = e;
      messages = [
        for (final m in messages)
          m.id == local.id ? m.copyWith(pending: false, failed: true) : m,
      ];
      // The reason may be the composer closing (a wait, a block): ask again.
      unawaited(_refreshComposer());
    }
    _notify();
  }

  Future<void> _refreshComposer() async {
    try {
      final d = await _load();
      composer = d.composer;
      _notify();
    } catch (_) {}
  }

  Future<void> _keep(List<AssistantMessage> rows) async {
    final id = _threadId;
    if (id == null || rows.isEmpty) return;
    try {
      await _store.save(id, rows);
    } catch (_) {
      // Shown regardless; the next catch-up stores it again.
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _sub?.cancel();
    _poll?.cancel();
    _lifecycle?.dispose();
    super.dispose();
  }
}
