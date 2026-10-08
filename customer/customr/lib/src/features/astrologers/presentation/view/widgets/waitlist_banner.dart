import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

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
  /// Null where the app's services are not set up (a screen shown on its
  /// own); the banner then stays empty.
  final ConsultationRepository? _repo =
      getIt.isRegistered<ConsultationRepository>()
      ? getIt<ConsultationRepository>()
      : null;
  StreamSubscription<RealtimeEvent>? _realtime;
  Timer? _tick;
  QueueEntry? _entry;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    waitlistChanges.addListener(_load);
    if (getIt.isRegistered<RealtimeClient>()) {
      _realtime = getIt<RealtimeClient>().events.listen((event) {
        if (event is QueueOffer || event is QueueRemoved) _load();
      });
    }
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
    final repo = _repo;
    if (repo == null) return;
    try {
      final entries = await repo.myQueue();
      if (!mounted) return;
      final now = DateTime.now();
      final mine = entries
          .where((e) => e.astrologerId == widget.astrologerId)
          .where((e) => !e.isLapsedAt(now))
          .toList();
      // A turn outranks a place in line (they may be queued on two channels).
      mine.sort(
        (a, b) => (b.isTurnAt(now) ? 1 : 0) - (a.isTurnAt(now) ? 1 : 0),
      );
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
      await _repo?.leaveQueue(entry.id);
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
    final theme = Theme.of(context);
    final brand = context.brand;
    final now = DateTime.now();
    final turn = entry.isTurnAt(now);
    const goldInk = Color(0xFF3A1703);
    final hue = AstroPalette.air;

    return Padding(
      padding: widget.padding,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        decoration: BoxDecoration(
          // The turn wears the app's gold: it is the one thing on the page
          // with a clock on it.
          gradient: turn
              ? const LinearGradient(colors: BrandColors.goldGradient)
              : null,
          color: turn ? null : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: turn ? null : Border.all(color: brand.hairline),
          boxShadow: turn
              ? [
                  BoxShadow(
                    color: BrandColors.goldGradient.last.withValues(
                      alpha: 0.35,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: turn
                    ? Colors.white.withValues(alpha: 0.35)
                    : hue.tint(0.13),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                turn
                    ? Icons.notifications_active_rounded
                    : Icons.hourglass_top_rounded,
                color: turn ? goldInk : hue.end,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    turn
                        ? l.waitlistTurnTitle
                        : l.waitlistWaitingTitle(entry.position),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: turn ? goldInk : null,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    turn
                        ? l.waitlistTurnBody(
                            _clock(entry.offerExpiresAt!.difference(now)),
                          )
                        : l.waitlistWaitingBody,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: turn
                          ? goldInk.withValues(alpha: 0.8)
                          : brand.inkMuted,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (turn)
              Pressable(
                child: Material(
                  color: goldInk,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => widget.onStart(entry.channel),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Text(
                        l.waitlistStart,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              TextButton(
                style: TextButton.styleFrom(foregroundColor: brand.inkMuted),
                onPressed: _leaving ? null : _leave,
                child: Text(l.waitlistLeave),
              ),
          ],
        ),
      ),
    );
  }
}
