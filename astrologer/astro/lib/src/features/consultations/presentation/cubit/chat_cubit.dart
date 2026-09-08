import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/realtime_client.dart';
import '../../data/consultation_api.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/consultation.dart';

class ChatState {
  const ChatState({
    this.loading = true,
    this.consultation,
    this.messages = const [],
    this.otherTyping = false,
    this.error,
  });
  final bool loading;
  final Consultation? consultation;
  final List<ChatMessage> messages;
  final bool otherTyping;
  final String? error;

  ChatState copyWith({
    bool? loading,
    Consultation? consultation,
    List<ChatMessage>? messages,
    bool? otherTyping,
    Object? error = _s,
  }) =>
      ChatState(
        loading: loading ?? this.loading,
        consultation: consultation ?? this.consultation,
        messages: messages ?? this.messages,
        otherTyping: otherTyping ?? this.otherTyping,
        error: error == _s ? this.error : error as String?,
      );
  static const _s = Object();
}

/// REST-first (3 s poll) with `conv:` realtime layered on. Astrologer side.
class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required ConsultationApi api,
    required RealtimeClient realtime,
    required this.consultationId,
  })  : _api = api,
        _realtime = realtime,
        super(const ChatState());

  final ConsultationApi _api;
  final RealtimeClient _realtime;
  final String consultationId;

  Timer? _poll;
  StreamSubscription<Map<String, dynamic>>? _frames;
  final _rng = Random();

  Future<void> init() async {
    try {
      final results = await Future.wait([
        _api.detail(consultationId),
        _api.messages(consultationId),
      ]);
      emit(state.copyWith(
        loading: false,
        consultation: results[0] as Consultation,
        messages: results[1] as List<ChatMessage>,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: '$e'));
    }
    _poll = Timer.periodic(const Duration(seconds: 3), (_) => _tick());
    _frames = _realtime
        .channelFrames('conv:$consultationId')
        .listen(_onFrame, onError: (_) {});
  }

  int get _maxSeq =>
      state.messages.isEmpty ? 0 : state.messages.map((m) => m.seq).reduce(max);

  Future<void> _tick() async {
    try {
      final fresh = await _api.messages(consultationId, after: _maxSeq);
      if (fresh.isNotEmpty) _merge(fresh);
    } catch (_) {}
  }

  void _onFrame(Map<String, dynamic> frame) {
    final type = frame['type'] as String? ?? '';
    final data = (frame['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    switch (type) {
      case 'message.new':
        _merge([ChatMessage.fromJson(data)]);
      case 'typing':
        if (data['role'] != 'astrologer') {
          emit(state.copyWith(otherTyping: data['is_typing'] == true));
        }
      case 'consultation.ended':
        _refreshDetail();
    }
  }

  void _merge(List<ChatMessage> incoming) {
    final byKey = {
      for (final m in state.messages) (m.clientId ?? m.id): m,
    };
    for (final m in incoming) {
      byKey[m.clientId ?? m.id] = m;
      if (m.clientId != null) byKey.remove(m.clientId);
      byKey[m.id] = m;
    }
    final list = byKey.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    emit(state.copyWith(messages: list));
  }

  Future<void> sendText(String body) async {
    body = body.trim();
    if (body.isEmpty) return;
    final clientId =
        '${DateTime.now().microsecondsSinceEpoch}-${_rng.nextInt(9999)}';
    final optimistic = ChatMessage(
      id: clientId,
      seq: _maxSeq + 1,
      senderRole: 'astrologer',
      body: body,
      type: 'text',
      createdAt: DateTime.now(),
      clientId: clientId,
      status: SendStatus.pending,
    );
    emit(state.copyWith(messages: [...state.messages, optimistic]));
    try {
      final saved = await _api.send(consultationId,
          body: body, clientId: clientId);
      _merge([saved]);
    } catch (_) {
      emit(state.copyWith(
        messages: state.messages
            .map((m) => m.clientId == clientId
                ? m.copyWith(status: SendStatus.failed)
                : m)
            .toList(),
      ));
    }
  }

  void onComposerChanged(String value) {
    _api.typing(consultationId, value.isNotEmpty).ignore();
  }

  Future<void> endConsultation() async {
    try {
      await _api.end(consultationId);
      await _refreshDetail();
    } catch (e) {
      emit(state.copyWith(error: '$e'));
    }
  }

  Future<void> _refreshDetail() async {
    try {
      emit(state.copyWith(consultation: await _api.detail(consultationId)));
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    _poll?.cancel();
    await _frames?.cancel();
    return super.close();
  }
}
