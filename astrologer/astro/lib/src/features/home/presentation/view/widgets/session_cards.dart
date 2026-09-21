import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../core/util/money.dart';
import '../../../../../shared/widgets/cosmic.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../../consultations/data/models/consultation.dart';
import 'dash_shared.dart';

/// Urgent card for requests waiting on the astrologer. Only placed in the
/// feed when [requests] is non-empty.
class IncomingRequestsCard extends StatelessWidget {
  const IncomingRequestsCard({required this.requests, super.key});

  final List<Consultation> requests;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final shown = requests.take(3).toList();
    return Padding(
      padding: DashGaps.sidePad,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radii.lg),
          color: theme.colorScheme.surface,
          border: Border.all(color: brand.live.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: brand.live.withValues(alpha: 0.14),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              color: brand.live.withValues(alpha: 0.08),
              child: Row(
                children: [
                  _Pulse(color: brand.live),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.dashRequestsWaiting(requests.length),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          l.dashRequestsHint,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: brand.live,
                      minimumSize: const Size(0, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () => context.go(Routes.requests),
                    child: Text(l.dashReview),
                  ),
                ],
              ),
            ),
            for (final c in shown)
              _SessionRow(
                consultation: c,
                onTap: () => context.push(Routes.requestDetail(c.id)),
              ),
          ],
        ),
      ),
    );
  }
}

/// Sessions already in progress — one tap back into the room.
class ActiveSessionsSection extends StatelessWidget {
  const ActiveSessionsSection({required this.sessions, super.key});

  final List<Consultation> sessions;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: l.dashActiveTitle),
        const SizedBox(height: 10),
        Padding(
          padding: DashGaps.sidePad,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final c in sessions)
                  _SessionRow(
                    consultation: c,
                    live: true,
                    onTap: () => context.push(Routes.chatRoom(c.id)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.consultation,
    required this.onTap,
    this.live = false,
  });

  final Consultation consultation;
  final VoidCallback onTap;
  final bool live;

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final ch = channelStyle(context, c.channel);
    final rate = double.tryParse(c.rateSnapshot) ?? 0;
    final meta = [
      ch.label,
      if (rate > 0) l.dashPerMin(Money.format(rate, c.currency)),
      if (c.question.isNotEmpty) c.question,
    ].join(' · ');

    return Pressable(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          child: Row(
            children: [
              HueIcon(hue: ch.hue, icon: ch.icon, size: 40, iconSize: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.customerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (live) ...[
                const LiveDot(),
                const SizedBox(width: 8),
                Text(
                  l.dashResume,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
              Icon(Icons.chevron_right_rounded, color: brand.inkMuted),
            ],
          ),
        ),
      ),
    );
  }
}

/// Red dot with an expanding ring — "needs you now".
class _Pulse extends StatefulWidget {
  const _Pulse({required this.color});

  final Color color;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final dot = Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
    );
    return SizedBox.square(
      dimension: 22,
      child: reduce
          ? Center(child: dot)
          : AnimatedBuilder(
              animation: _c,
              builder: (_, _) => Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 10 + 12 * _c.value,
                    height: 10 + 12 * _c.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withValues(
                        alpha: 0.35 * (1 - _c.value),
                      ),
                    ),
                  ),
                  dot,
                ],
              ),
            ),
    );
  }
}
