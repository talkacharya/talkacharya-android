import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../../../core/l10n/l10n.dart';

/// The host's view of calls during the stream: the call on air (or coming on),
/// with Mute (public calls) and End, and how many wait — tap for the line.
/// The next caller comes on by itself when a call ends.
class HostCallPanel extends StatelessWidget {
  const HostCallPanel({required this.state, required this.cubit, super.key});

  final LiveState state;
  final LiveHostCubit cubit;

  LiveCallRequest? get _current {
    for (final r in state.callLine) {
      if (r.status == LiveCallStatus.connecting ||
          r.status == LiveCallStatus.active) {
        return r;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final current = _current;
    final waiting = state.callsWaiting;
    if (current == null && waiting == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (current != null)
            _CurrentCall(call: current, cubit: cubit, busy: state.callBusy),
          if (waiting > 0)
            Padding(
              padding: EdgeInsets.only(top: current != null ? 6 : 0),
              child: ActionChip(
                avatar: const Icon(
                  Icons.people_alt_rounded,
                  size: 16,
                  color: Colors.white,
                ),
                label: Text(l.hostCallWaiting(waiting)),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                side: const BorderSide(color: Colors.white24),
                onPressed: () => showHostCallLine(context, cubit),
              ),
            ),
        ],
      ),
    );
  }
}

class _CurrentCall extends StatelessWidget {
  const _CurrentCall({
    required this.call,
    required this.cubit,
    required this.busy,
  });

  final LiveCallRequest call;
  final LiveHostCubit cubit;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final private = call.mode == LiveCallMode.private;
    final connecting = call.status == LiveCallStatus.connecting;
    final name = call.customerName.isEmpty ? '—' : call.customerName;
    final title = connecting
        ? l.hostCallConnecting(name)
        : private
        ? l.hostCallPrivate(name)
        : l.hostCallPublic(name);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: private
              ? const [Color(0xDDF07B16), Color(0xDDFFB02E)]
              : const [Color(0xDD4F3BCB), Color(0xDD7C5CFF)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            private ? Icons.lock_rounded : Icons.graphic_eq_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (!connecting)
                  Text(
                    private ? l.hostCallPrivateHint : l.hostCallPublicHint,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
              ],
            ),
          ),
          if (!connecting && !private)
            IconButton(
              tooltip: call.muted ? l.hostCallUnmute : l.hostCallMute,
              onPressed: busy
                  ? null
                  : () => cubit.muteCaller(call.id, muted: !call.muted),
              icon: Icon(
                call.muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                color: Colors.white,
              ),
            ),
          TextButton(
            onPressed: busy ? null : () => cubit.endCall(call.id),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFE5484D),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
            child: Text(
              connecting ? l.hostCallSkip : l.hostCallEnd,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

/// Everyone waiting, in order; the host can take someone off the line.
Future<void> showHostCallLine(BuildContext context, LiveHostCubit cubit) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => StreamBuilder<LiveState>(
      stream: cubit.stream,
      initialData: cubit.state,
      builder: (context, snap) {
        final l = context.l10n;
        final waiting = [
          for (final r in snap.data?.callLine ?? const <LiveCallRequest>[])
            if (r.status == LiveCallStatus.waiting) r,
        ];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.hostCallLineTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                if (waiting.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      l.hostCallLineEmpty,
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  for (final (i, r) in waiting.indexed)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(child: Text('${i + 1}')),
                      title: Text(r.customerName),
                      subtitle: Text(
                        r.mode == LiveCallMode.private
                            ? l.hostCallModePrivate
                            : l.hostCallModePublic,
                      ),
                      trailing: TextButton(
                        onPressed: () => unawaited(cubit.endCall(r.id)),
                        child: Text(l.hostCallRemove),
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
