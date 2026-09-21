import 'dart:async';

import 'package:livekit_client/livekit_client.dart' as lk;

import 'live_room.dart';

/// [LiveRoomEngine] on the LiveKit SDK, talking to **our own** media server
/// (`deploy/media`) — no vendor, no per-minute fees.
///
/// The host publishes one camera + microphone track; LiveKit fans it out to every
/// viewer. Simulcast means each viewer is sent the layer their connection can carry
/// instead of dropping out, and adaptive stream pauses video that is off-screen.
class LiveKitRoomEngine implements LiveRoomEngine {
  LiveKitRoomEngine();

  lk.Room? _room;
  lk.EventsListener<lk.RoomEvent>? _events;
  bool _front = true;

  final _remoteVideo = StreamController<LiveVideoTrack?>.broadcast();
  final _localVideo = StreamController<LiveVideoTrack?>.broadcast();
  final _connection = StreamController<LiveConnection>.broadcast();
  final _remoteEnabled = StreamController<bool>.broadcast();

  @override
  Stream<LiveVideoTrack?> get remoteVideo => _remoteVideo.stream;

  @override
  Stream<LiveVideoTrack?> get localVideo => _localVideo.stream;

  @override
  Stream<LiveConnection> get connectionStates => _connection.stream;

  @override
  Stream<bool> get remoteVideoEnabled => _remoteEnabled.stream;

  @override
  Future<void> connect({
    required String url,
    required String token,
    bool publish = false,
  }) async {
    if (_room != null) return;
    _connection.add(LiveConnection.connecting);

    final room = lk.Room(
      roomOptions: const lk.RoomOptions(
        // send each viewer a layer their connection can actually carry, and stop
        // sending video nobody is looking at
        adaptiveStream: true,
        dynacast: true,
        defaultCameraCaptureOptions: lk.CameraCaptureOptions(
          params: lk.VideoParametersPresets.h540_169,
        ),
        defaultVideoPublishOptions: lk.VideoPublishOptions(simulcast: true),
      ),
    );
    _room = room;
    _events = room.createListener();
    _wire(_events!);

    await room.connect(url, token);
    _connection.add(LiveConnection.connected);

    if (publish) {
      await room.localParticipant?.setMicrophoneEnabled(true);
      await room.localParticipant?.setCameraEnabled(true);
      _localVideo.add(_localTrack());
    } else {
      // a viewer's phone should play the stream out loud, not through the earpiece
      try {
        await lk.Hardware.instance.setSpeakerphoneOn(true);
      } catch (_) {}
      _emitExistingRemoteVideo(room);
    }
  }

  void _wire(lk.EventsListener<lk.RoomEvent> events) {
    events
      ..on<lk.TrackSubscribedEvent>((e) {
        if (e.track is lk.VideoTrack) {
          _remoteVideo.add(e.track);
          _remoteEnabled.add(!e.publication.muted);
        }
      })
      ..on<lk.TrackUnsubscribedEvent>((e) {
        if (e.track is lk.VideoTrack) _remoteVideo.add(null);
      })
      ..on<lk.TrackMutedEvent>((e) {
        if (e.publication.kind == lk.TrackType.VIDEO &&
            e.participant is lk.RemoteParticipant) {
          _remoteEnabled.add(false);
        }
      })
      ..on<lk.TrackUnmutedEvent>((e) {
        if (e.publication.kind == lk.TrackType.VIDEO &&
            e.participant is lk.RemoteParticipant) {
          _remoteEnabled.add(true);
        }
      })
      ..on<lk.LocalTrackPublishedEvent>((_) => _localVideo.add(_localTrack()))
      ..on<lk.RoomReconnectingEvent>(
        (_) => _connection.add(LiveConnection.reconnecting),
      )
      ..on<lk.RoomReconnectedEvent>(
        (_) => _connection.add(LiveConnection.connected),
      )
      ..on<lk.RoomDisconnectedEvent>(
        (_) => _connection.add(LiveConnection.disconnected),
      );
  }

  /// A viewer who joins after the host started publishing gets no
  /// `TrackSubscribed` event for tracks already there — read them once.
  void _emitExistingRemoteVideo(lk.Room room) {
    for (final participant in room.remoteParticipants.values) {
      for (final pub in participant.videoTrackPublications) {
        final track = pub.track;
        if (track != null) {
          _remoteVideo.add(track);
          _remoteEnabled.add(!pub.muted);
          return;
        }
      }
    }
  }

  lk.LocalVideoTrack? _localTrack() {
    for (final pub
        in _room?.localParticipant?.videoTrackPublications ??
            const <lk.LocalTrackPublication<lk.LocalVideoTrack>>[]) {
      final track = pub.track;
      if (track != null) return track;
    }
    return null;
  }

  @override
  Future<void> setCameraEnabled(bool enabled) async {
    await _room?.localParticipant?.setCameraEnabled(enabled);
    _localVideo.add(enabled ? _localTrack() : null);
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async {
    await _room?.localParticipant?.setMicrophoneEnabled(enabled);
  }

  @override
  Future<bool> switchCamera() async {
    final track = _localTrack();
    if (track == null) return _front;
    try {
      await track.setCameraPosition(
        _front ? lk.CameraPosition.back : lk.CameraPosition.front,
      );
      _front = !_front;
      _localVideo.add(track);
    } catch (_) {}
    return _front;
  }

  @override
  Future<void> disconnect() async {
    final room = _room;
    _room = null;
    await _events?.dispose();
    _events = null;
    if (room != null) {
      try {
        await room.disconnect();
      } catch (_) {}
      await room.dispose();
    }
    _remoteVideo.add(null);
    _localVideo.add(null);
    _connection.add(LiveConnection.disconnected);
    await _remoteVideo.close();
    await _localVideo.close();
    await _remoteEnabled.close();
    await _connection.close();
  }
}
