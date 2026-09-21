import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../core/realtime/realtime_client.dart';
import 'livestream_api.dart';

/// [LiveViewerBackend] for one stream, over the app's Dio client.
class DioLiveViewerBackend implements LiveViewerBackend {
  const DioLiveViewerBackend(this._api, this.streamId);

  final LivestreamApi _api;
  final String streamId;

  @override
  Future<LiveJoin> join() => _api.join(streamId);

  @override
  Future<int> heartbeat() => _api.heartbeat(streamId);

  @override
  Future<void> leave() => _api.leave(streamId);

  @override
  Future<List<LiveChatMessage>> chatHistory() => _api.chat(streamId);

  @override
  Future<void> sendChat(String text, {String? imagePath}) =>
      _api.sendChat(streamId, text, imagePath: imagePath);
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
