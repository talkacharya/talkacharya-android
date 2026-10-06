import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/util/money.dart';
import '../../../../core/util/time_format.dart';
import '../../../performance/presentation/widgets/perf_format.dart';
import '../../../workspace/presentation/widgets/async_page.dart';
import '../../data/remedies_api.dart';
import 'remedies_page.dart';

/// Poojas with a date still open for booking, soonest first. Each can be
/// suggested to a customer; a booking through the suggestion pays commission.
class PoojaCalendarPage extends StatelessWidget {
  const PoojaCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<List<PoojaDate>>(
      title: l.poojaCalendarTitle,
      subtitle: l.poojaCalendarSubtitle,
      load: getIt<RemediesApi>().poojaCalendar,
      actions: [
        TextButton(
          onPressed: () => context.push(Routes.poojaBookings),
          child: Text(l.poojaBookingsTitle),
        ),
      ],
      builder: (context, dates, _, _) {
        if (dates.isEmpty) {
          return [
            WsEmpty(
              icon: Icons.temple_hindu_rounded,
              hue: AstroPalette.fire,
              title: l.poojaCalendarEmpty,
              message: l.poojaCalendarEmptyBody,
            ),
          ];
        }
        final theme = Theme.of(context);
        final out = <Widget>[];
        DateTime? day;
        for (final d in dates) {
          final at = d.startsAt?.toLocal();
          final key = at == null ? null : DateTime(at.year, at.month, at.day);
          if (key != day) {
            day = key;
            if (at != null) {
              out.add(
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                  child: Text(
                    DateFormat.MMMMEEEEd(l.localeName).format(at),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: context.brand.inkMuted,
                    ),
                  ),
                ),
              );
            }
          }
          out.add(_PoojaCard(date: d));
        }
        return out;
      },
    );
  }
}

class _PoojaCard extends StatelessWidget {
  const _PoojaCard({required this.date});

  final PoojaDate date;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final d = date;
    final p = d.product;
    final at = d.startsAt?.toLocal();
    final where = [
      if (at != null) DateFormat.jm(l.localeName).format(at),
      if (d.venue.isNotEmpty) d.venue else d.temple,
    ].join(' · ');
    return WsCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductThumb(url: p.image, size: 60),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  where,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (p.priceFrom != null)
                      Text(
                        l.poojaFrom(Money.format(p.priceFrom!, d.currency)),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    if (d.remaining != null && d.remaining! <= 10) ...[
                      const SizedBox(width: 8),
                      Text(
                        l.poojaSeatsLeft(d.remaining!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: BandColors.low,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () =>
                        context.push(Routes.suggestRemedy(), extra: p),
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: Text(l.poojaSuggest),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Poojas customers booked on this astrologer's suggestion, and how far each
/// has got.
class PoojaBookingsPage extends StatelessWidget {
  const PoojaBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<List<PoojaBooking>>(
      title: l.poojaBookingsTitle,
      subtitle: l.poojaBookingsSubtitle,
      load: getIt<RemediesApi>().poojaBookings,
      builder: (context, bookings, _, _) => bookings.isEmpty
          ? [
              WsEmpty(
                icon: Icons.event_available_rounded,
                hue: AstroPalette.health,
                title: l.poojaBookingsEmpty,
                message: l.poojaBookingsEmptyBody,
              ),
            ]
          : [for (final b in bookings) _BookingCard(booking: b)],
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final PoojaBooking booking;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final b = booking;
    final (label, color) = switch (b.status) {
      'completed' || 'proof_uploaded' => (l.poojaStatusDone, BandColors.good),
      'performed' => (l.poojaStatusPerformed, BandColors.good),
      'cancelled' => (l.poojaStatusCancelled, brand.inkMuted),
      'pending' => (l.poojaStatusPending, BandColors.mid),
      _ => (l.poojaStatusConfirmed, AstroPalette.career.end),
    };
    final name = b.customerName.trim().isEmpty
        ? l.winBackCustomer
        : b.customerName;
    final when = b.scheduledFor?.toLocal();
    return WsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  b.package.isEmpty ? b.title : '${b.title} · ${b.package}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            l.remedyFor(name, TimeFormat.relative(l, b.bookedAt)),
            style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
          ),
          Text(
            [
              if (b.temple.isNotEmpty) b.temple,
              if (when != null)
                DateFormat.MMMd(l.localeName).add_jm().format(when)
              else
                l.poojaNextDate,
            ].join(' · '),
            style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
          ),
        ],
      ),
    );
  }
}
