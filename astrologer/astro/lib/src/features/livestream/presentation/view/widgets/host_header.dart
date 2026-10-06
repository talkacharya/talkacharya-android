import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../../../core/l10n/l10n.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';
class HostHeader extends StatelessWidget {
  const HostHeader({
    required this.state,
    required this.title,
    required this.onEnd,
    super.key,
  });

  final LiveState state;
  final String title;
  final Future<void> Function() onEnd;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final live = state.phase == LivePhase.live;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC000000), Color(0x00000000)],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: live ? const Color(0xFFE5484D) : const Color(0xFFFFC53D),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              live ? 'LIVE' : 'CONNECTING',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
              ),
            ),
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (state.startedAt != null) Elapsed(since: state.startedAt!),
              ],
            ),
          ),
          const Icon(Icons.visibility_rounded, size: 16, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            '${state.viewerCount}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          // Paying intent, sitting in the audience. Worth more than the view
          // count and the host could not see it at all.
          if (state.waitingCount > 0) ...[
            const SizedBox(width: 10),
            WaitingPill(count: state.waitingCount),
          ],
          const SizedBox(width: 6),
          TextButton(
            onPressed: onEnd,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF8A8A),
            ),
            child: Text(l.hostEnd),
          ),
        ],
      ),
    );
  }
}

/// How long we have been on air — the one number a host keeps glancing at.
class Elapsed extends StatefulWidget {
  const Elapsed({required this.since, super.key});
  final DateTime since;

  @override
  State<Elapsed> createState() => _ElapsedState();
}

class _ElapsedState extends State<Elapsed> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => mounted ? setState(() {}) : null,
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = DateTime.now().difference(widget.since);
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final text = d.inHours > 0 ? '${d.inHours}:$m:$s' : '$m:$s';
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 12,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }
}

/// How many viewers have asked this host for a private reading.
///
/// Deliberately loud: it is the one number that should change what the host
/// does next, and they are looking at a camera, not a dashboard.
class WaitingPill extends StatelessWidget {
  const WaitingPill({required this.count, super.key});
  final int count;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Tooltip(
      message: l.liveWaitingTooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: BrandColors.goldGradient),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.record_voice_over_rounded,
              size: 13,
              color: Colors.black87,
            ),
            const SizedBox(width: 4),
            Text(
              l.liveWaitingCount(count),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
