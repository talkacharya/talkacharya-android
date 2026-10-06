import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/network/friendly_error.dart';
import '../../../../../core/realtime/realtime_client.dart';
import '../../../../../core/realtime/realtime_event.dart';
import '../../../../../shared/widgets/app_snack.dart';
import '../../../../consultations/data/consultation_repository.dart';
import '../../../../consultations/data/models/queue_entry.dart';

/// This customer's place in [astrologerId]'s waitlist, on the astrologer's
/// profile: where they are in line, or — once the astrologer is free — that it
/// is their turn, with the time left to take it.
///
/// Takes no space when they are not in the list.
class WaitlistBanner extends StatefulWidget {
  const WaitlistBanner({
    required this.astrologerId,
    required this.onStart,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final String astrologerId;

  /// Start the consultation the turn is for; gets the channel that was queued.
  final ValueChanged<String> onStart;
  final EdgeInsets padding;

  @override
  State<WaitlistBanner> createState() => _WaitlistBannerState();
}

class _WaitlistBannerState extends State<WaitlistBanner>
    with WidgetsBindingObserver {
  final _repo = getIt<ConsultationRepository>();
  StreamSubscription<RealtimeEvent>? _realtime;
  Timer? _tick;
  QueueEntry? _entry;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    waitlistChanges.addListener(_load);
    _realtime = getIt<RealtimeClient>().events.listen((event) {
      if (event is QueueOffer || event is QueueRemoved) _load();
    });
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    waitlistChanges.removeListener(_load);
    _realtime?.cancel();
    _tick?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The turn usually arrives as a push while the app is in the background.
    if (state == AppLifecycleState.resumed) _load();
  }

  Future<void> _load() async {
    try {
      final entries = await _repo.myQueue();
      if (!mounted) return;
      final now = DateTime.now();
      final mine = entries
          .where((e) => e.astrologerId == widget.astrologerId)
          .where((e) => !e.isLapsedAt(now))
          .toList();
      // A turn outranks a place in line (they may be queued on two channels).
      mine.sort((a, b) => (b.isTurnAt(now) ? 1 : 0) - (a.isTurnAt(now) ? 1 : 0));
      _show(mine.isEmpty ? null : mine.first);
    } catch (_) {
      // Not knowing is shown as not being in the list; the next load corrects it.
    }
  }

  void _show(QueueEntry? entry) {
    _tick?.cancel();
    setState(() => _entry = entry);
    if (entry != null && entry.isTurnAt(DateTime.now())) {
      _tick = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        if (entry.isTurnAt(DateTime.now())) {
          setState(() {});
        } else {
          _load(); // the turn ran out — see where that leaves them
        }
      });
    }
  }

  Future<void> _leave() async {
    final entry = _entry;
    if (entry == null) return;
    setState(() => _leaving = true);
    try {
      await _repo.leaveQueue(entry.id);
      if (!mounted) return;
      _show(null);
    } catch (e) {
      if (!mounted) return;
      AppSnack.showTop(context, friendlyError(e), type: SnackType.error);
    } finally {
      if (mounted) setState(() => _leaving = false);
    }
  }

  static String _clock(Duration d) {
    final s = d.inSeconds.clamp(0, 5999);
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final entry = _entry;
    if (entry == null) return const SizedBox.shrink();

    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();
    final turn = entry.isTurnAt(now);
    final background = turn ? scheme.primaryContainer : scheme.surfaceContainerHighest;
    final foreground = turn ? scheme.onPrimaryContainer : scheme.onSurface;

    return Padding(
      padding: widget.padding,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              turn ? Icons.notifications_active_rounded : Icons.hourglass_top_rounded,
              color: foreground,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    turn ? l.waitlistTurnTitle : l.waitlistWaitingTitle(entry.position),
                    style: text.titleSmall?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    turn
                        ? l.waitlistTurnBody(
                            _clock(entry.offerExpiresAt!.difference(now)),
                          )
                        : l.waitlistWaitingBody,
                    style: text.bodySmall?.copyWith(
                      color: foreground.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (turn)
              FilledButton(
                onPressed: () => widget.onStart(entry.channel),
                child: Text(l.waitlistStart),
              )
            else
              TextButton(
                onPressed: _leaving ? null : _leave,
                child: Text(l.waitlistLeave),
              ),
          ],
        ),
      ),
    );
  }
}
