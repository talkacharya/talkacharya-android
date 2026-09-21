import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../core/realtime/realtime_client.dart';
import 'live_api.dart';

/// [LiveHostBackend] for one stream, over the app's Dio client.
class DioLiveHostBackend implements LiveHostBackend {
  const DioLiveHostBackend(this._api, this.streamId);

  final LiveApi _api;
  final String streamId;

  @override
  Future<LiveJoin> start() => _api.start(streamId);

  @override
  Future<void> end() => _api.end(streamId);

  @override
  Future<List<LiveChatMessage>> chatHistory() => _api.chat(streamId);

  @override
  Future<void> sendChat(String text, {String? imagePath}) =>
      _api.sendChat(streamId, text, imagePath: imagePath);

  @override
  Future<void> removeViewer(String userId, {String reason = ''}) =>
      _api.removeViewer(streamId, userId, reason: reason);

  @override
  Future<void> setSlowMode(int seconds) => _api.setSlowMode(streamId, seconds);

  @override
  Future<void> pinMessage(
    String messageId, {
    bool pin = true,
    bool hide = false,
  }) => _api.pinMessage(streamId, messageId, pin: pin, hide: hide);
}

/// [LiveSignaling] over the app's Centrifugo client — chat, viewer counts and
/// gifts on `live:{id}`.
class RealtimeLiveSignaling implements LiveSignaling {
  const RealtimeLiveSignaling(this._rt);

  final RealtimeClient _rt;

  @override
  Stream<Map<String, dynamic>> frames(String channel) =>
      _rt.channelFrames(channel);
}
