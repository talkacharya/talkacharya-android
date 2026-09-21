import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../data/models/consultation.dart';

/// Icon + label + hue for a consultation channel (`chat|call|video`).
({IconData icon, String label, AstroHue hue}) channelStyle(
  BuildContext context,
  String channel,
) {
  final l = context.l10n;
  return switch (channel) {
    'call' || 'voice' => (
      icon: Icons.call_rounded,
      label: l.channelCall,
      hue: AstroPalette.health,
    ),
    'video' => (
      icon: Icons.videocam_rounded,
      label: l.channelVideo,
      hue: AstroPalette.love,
    ),
    _ => (
      icon: Icons.chat_bubble_rounded,
      label: l.channelChat,
      hue: AstroPalette.career,
    ),
  };
}

/// Localised label + colour for a consultation status.
({String label, Color color}) statusStyle(BuildContext context, String status) {
  final l = context.l10n;
  final brand = context.brand;
  final muted = brand.inkMuted;
  return switch (status) {
    'requested' => (label: l.statusRequested, color: AstroPalette.money.end),
    'accepted' => (label: l.statusAccepted, color: AstroPalette.career.end),
    'active' => (label: l.statusActive, color: brand.online),
    'ended' => (label: l.statusEnded, color: brand.online),
    'rejected' => (label: l.statusRejected, color: muted),
    'cancelled' => (label: l.statusCancelled, color: muted),
    'expired' => (label: l.statusExpired, color: brand.live),
    'no_show' => (label: l.statusNoShow, color: brand.live),
    'failed' => (label: l.statusFailed, color: brand.live),
    _ => (label: status, color: muted),
  };
}

/// Small rounded status label.
class StatusChip extends StatelessWidget {
  const StatusChip({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final s = statusStyle(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: s.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        s.label,
        style: TextStyle(
          color: s.color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

/// Customer avatar: initial on a stable per-customer hue, with a small channel
/// badge and an optional live dot.
class CustomerAvatar extends StatelessWidget {
  const CustomerAvatar({
    required this.consultation,
    this.size = 48,
    this.live = false,
    super.key,
  });

  final Consultation consultation;
  final double size;
  final bool live;

  @override
  Widget build(BuildContext context) {
    final ch = channelStyle(context, consultation.channel);
    final surface = Theme.of(context).colorScheme.surface;
    return SizedBox.square(
      dimension: size + 4,
      child: Stack(
        children: [
          HueAvatar(
            name: consultation.customerName,
            hue: AstroPalette.forId(consultation.customerName),
            size: size,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(color: surface, shape: BoxShape.circle),
              child: Container(
                width: size * 0.38,
                height: size * 0.38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ch.hue.linear(),
                ),
                child: Icon(ch.icon, size: size * 0.22, color: Colors.white),
              ),
            ),
          ),
          if (live) const Positioned(top: 2, right: 2, child: LiveDot()),
        ],
      ),
    );
  }
}

/// One consultation in a list (active sessions, history, chats).
class ConsultationTile extends StatelessWidget {
  const ConsultationTile({
    required this.consultation,
    required this.onTap,
    this.showStatus = false,
    super.key,
  });

  final Consultation consultation;
  final VoidCallback onTap;

  /// Show the status chip instead of the channel label (history rows).
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final ch = channelStyle(context, c.channel);

    final String meta;
    if (c.isLive) {
      meta = [
        l.requestsLiveNow,
        if (c.question.isNotEmpty) c.question else ch.label,
      ].join(' · ');
    } else if (c.isEnded) {
      final earned = double.tryParse(c.astrologerAmount) ?? 0;
      meta = [
        ch.label,
        l.requestsMinutes(c.billedMinutes),
        l.requestsEarned(Money.format(earned, c.currency)),
      ].join(' · ');
    } else {
      meta = ch.label;
    }

    return Pressable(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              CustomerAvatar(consultation: c, live: c.isLive),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            c.customerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: c.unreadCount > 0
                                  ? FontWeight.w800
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (showStatus && !c.isEnded) ...[
                          const SizedBox(width: 6),
                          StatusChip(status: c.status),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: c.isLive ? brand.online : brand.inkMuted,
                        fontWeight: c.isLive ? FontWeight.w700 : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    TimeFormat.relative(l, c.endedAt ?? c.requestedAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: c.unreadCount > 0
                          ? theme.colorScheme.primary
                          : brand.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (c.unreadCount > 0)
                    Badge(
                      label: Text(
                        c.unreadCount > 99 ? '99+' : '${c.unreadCount}',
                      ),
                      backgroundColor: theme.colorScheme.primary,
                    )
                  else if (c.rating != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, size: 14, color: brand.gold),
                        Text(
                          '${c.rating}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(height: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
