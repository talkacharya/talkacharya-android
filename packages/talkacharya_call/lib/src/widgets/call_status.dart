import '../models/call_state.dart';
import 'call_screen.dart';

/// `mm:ss`, or `h:mm:ss` past the hour.
String formatCallClock(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}

/// The one-line call status: the running clock once connected, otherwise what
/// the call is doing.
String callStatusText(
  CallState s,
  CallStrings strings, {
  DateTime? now,
}) => switch (s.phase) {
  CallPhase.idle || CallPhase.preparing || CallPhase.joining => strings.calling,
  CallPhase.waitingPeer => strings.ringing,
  CallPhase.connecting => strings.connecting,
  CallPhase.connected =>
    s.connectedAt == null
        ? strings.connecting
        : formatCallClock((now ?? DateTime.now()).difference(s.connectedAt!)),
  CallPhase.reconnecting => strings.reconnecting,
  CallPhase.ended => strings.callEnded,
  CallPhase.failed => strings.failedTitle,
  CallPhase.permissionDenied => strings.micTitle,
};
