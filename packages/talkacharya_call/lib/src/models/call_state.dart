import 'package:equatable/equatable.dart';

enum CallPhase {
  /// Not started yet.
  idle,

  /// Asking for the microphone.
  preparing,

  /// Microphone permission refused — the screen offers settings / retry.
  permissionDenied,

  /// Fetching join info + opening signaling.
  joining,

  /// Waiting for the other phone to show up on the call.
  waitingPeer,

  /// Both sides present; ICE / DTLS handshake in progress.
  connecting,

  /// Audio flowing.
  connected,

  /// Was connected, lost the path — trying to recover (ICE restart).
  reconnecting,

  /// Finished (see [CallEndReason]).
  ended,

  /// Could not start (see [CallState.error]).
  failed;

  bool get isLive =>
      this == waitingPeer ||
      this == connecting ||
      this == connected ||
      this == reconnecting;
}

enum CallEndReason { none, localHangUp, remoteHangUp, consultationEnded, error }

/// What the network side reports to the backend (drives billing).
enum CallNetState { connected, reconnecting, disconnected }

class CallState extends Equatable {
  const CallState({
    this.phase = CallPhase.idle,
    this.muted = false,
    this.speakerOn = false,
    this.quality = 0,
    this.relayed = false,
    this.connectedAt,
    this.endReason = CallEndReason.none,
    this.error,
    this.peerName = '',
    this.permanentlyDenied = false,
  });

  final CallPhase phase;
  final bool muted;
  final bool speakerOn;

  /// 0 = unknown, 1 = poor, 2 = fair, 3 = good.
  final int quality;

  /// Audio goes through our TURN relay (vs. phone-to-phone).
  final bool relayed;

  /// First time audio connected (drives the on-screen timer).
  final DateTime? connectedAt;
  final CallEndReason endReason;
  final String? error;
  final String peerName;

  /// Microphone permission is blocked in system settings.
  final bool permanentlyDenied;

  CallState copyWith({
    CallPhase? phase,
    bool? muted,
    bool? speakerOn,
    int? quality,
    bool? relayed,
    DateTime? connectedAt,
    CallEndReason? endReason,
    String? error,
    bool clearError = false,
    String? peerName,
    bool? permanentlyDenied,
  }) => CallState(
    phase: phase ?? this.phase,
    muted: muted ?? this.muted,
    speakerOn: speakerOn ?? this.speakerOn,
    quality: quality ?? this.quality,
    relayed: relayed ?? this.relayed,
    connectedAt: connectedAt ?? this.connectedAt,
    endReason: endReason ?? this.endReason,
    error: clearError ? null : (error ?? this.error),
    peerName: peerName ?? this.peerName,
    permanentlyDenied: permanentlyDenied ?? this.permanentlyDenied,
  );

  @override
  List<Object?> get props => [
    phase,
    muted,
    speakerOn,
    quality,
    relayed,
    connectedAt,
    endReason,
    error,
    peerName,
    permanentlyDenied,
  ];
}
