import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../core/util/money.dart';
import '../../../../../core/util/time_format.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../../consultations/data/models/consultation.dart';
import '../../../../consultations/presentation/widgets/consultation_style.dart';
import '../../../../consultations/presentation/widgets/shared_details.dart';

/// Backend `CONSULTATIONS["ACCEPT_TIMEOUT_SECONDS"]` — a request auto-expires
/// this long after it was made.
const kAcceptTimeout = Duration(seconds: 90);

/// A waiting request: who, which channel, the rate, their question, a
/// draining expiry bar, and Decline / Accept.
class IncomingRequestCard extends StatelessWidget {
  const IncomingRequestCard({
    required this.consultation,
    required this.busy,
    required this.onAccept,
    required this.onDecline,
    required this.onTap,
    required this.onExpired,
    super.key,
  });

  final Consultation consultation;
  final bool busy;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onTap;
  final VoidCallback onExpired;

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final ch = channelStyle(context, c.channel);
    final rate = double.tryParse(c.rateSnapshot) ?? 0;

    return Pressable(
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.lg),
          side: BorderSide(color: ch.hue.tint(0.35)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [ch.hue.tint(0.12), theme.colorScheme.surface],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (c.requestedAt != null)
                  _ExpiryBar(
                    requestedAt: c.requestedAt!,
                    color: ch.hue.end,
                    onExpired: onExpired,
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          CustomerAvatar(consultation: c, size: 50),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.customerName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    _Tag(
                                      icon: ch.icon,
                                      label: ch.label,
                                      color: ch.hue.end,
                                    ),
                                    if (rate > 0)
                                      _Tag(
                                        label: l.dashPerMin(
                                          Money.format(rate, c.currency),
                                        ),
                                        color: brand.onTint,
                                      ),
                                    SharedBadges(consultation: c),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            TimeFormat.relative(l, c.requestedAt),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: brand.inkMuted,
                            ),
                          ),
                        ],
                      ),
                      if (c.question.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                          decoration: BoxDecoration(
                            color: brand.sectionBg,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(14),
                              bottomLeft: Radius.circular(14),
                              bottomRight: Radius.circular(14),
                              topLeft: Radius.circular(4),
                            ),
                          ),
                          child: Text(
                            c.question,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: busy ? null : onDecline,
                              child: Text(l.requestsDecline),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(46),
                                backgroundColor: brand.online,
                              ),
                              onPressed: busy ? null : onAccept,
                              icon: busy
                                  ? const SizedBox.square(
                                      dimension: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(ch.icon, size: 20),
                              label: Text(l.requestsAccept),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Thin bar draining over the accept window, with a seconds label. Calls
/// [onExpired] once when it runs out.
class _ExpiryBar extends StatefulWidget {
  const _ExpiryBar({
    required this.requestedAt,
    required this.color,
    required this.onExpired,
  });

  final DateTime requestedAt;
  final Color color;
  final VoidCallback onExpired;

  @override
  State<_ExpiryBar> createState() => _ExpiryBarState();
}

class _ExpiryBarState extends State<_ExpiryBar> {
  Timer? _timer;
  bool _fired = false;

  Duration get _left =>
      widget.requestedAt.add(kAcceptTimeout).difference(DateTime.now());

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!mounted) return;
    setState(() {});
    if (!_fired && _left <= Duration.zero) {
      _fired = true;
      _timer?.cancel();
      widget.onExpired();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final secs = _left.inSeconds.clamp(0, kAcceptTimeout.inSeconds);
    final frac = secs / kAcceptTimeout.inSeconds;
    final urgent = secs <= 20;
    final color = urgent ? brand.live : widget.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(end: frac),
          duration: const Duration(milliseconds: 950),
          builder: (_, v, _) => LinearProgressIndicator(
            value: v,
            minHeight: 4,
            color: color,
            backgroundColor: color.withValues(alpha: 0.12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
          child: Row(
            children: [
              Icon(Icons.timer_outlined, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                secs > 0 ? l.requestsExpiresIn(secs) : l.requestsExpired,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
