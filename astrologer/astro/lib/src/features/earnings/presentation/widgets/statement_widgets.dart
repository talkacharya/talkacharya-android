import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../data/earnings_api.dart';
import '../../data/earnings_models.dart';
import 'earnings_widgets.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// The earnings statement, astrologer side: where the money came from, service by
/// service, and what came off it down to the payout — the figures the server
/// stamped on each earning the day it was made.

/// Label, colour and icon for a [StatementStatuses] value.
({String label, Color color, IconData icon}) statementStatusStyle(
  BuildContext context,
  String status,
) {
  final l = context.l10n;
  final brand = context.brand;
  return switch (status) {
    StatementStatuses.credited => (
      label: l.earnStatusCredited,
      color: brand.online,
      icon: Icons.check_circle_rounded,
    ),
    StatementStatuses.processing => (
      label: l.earnStatusProcessing,
      color: AstroPalette.career.end,
      icon: Icons.sync_rounded,
    ),
    StatementStatuses.failed => (
      label: l.earnStatusFailed,
      color: brand.live,
      icon: Icons.error_rounded,
    ),
    StatementStatuses.onHold => (
      label: l.earnStatusOnHold,
      color: AstroPalette.money.end,
      icon: Icons.pause_circle_rounded,
    ),
    StatementStatuses.clearing => (
      label: l.earnStatusClearing,
      color: brand.inkMuted,
      icon: Icons.hourglass_top_rounded,
    ),
    StatementStatuses.ready => (
      label: l.earnStatusReady,
      color: AstroPalette.health.end,
      icon: Icons.task_alt_rounded,
    ),
    _ => (
      label: l.earnStatusUpcoming,
      color: AstroPalette.money.end,
      icon: Icons.schedule_rounded,
    ),
  };
}

class StatementStatusChip extends StatelessWidget {
  const StatementStatusChip({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final s = statementStatusStyle(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: s.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 13, color: s.color),
          const SizedBox(width: 4),
          Text(
            s.label,
            style: TextStyle(
              color: s.color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Label, icon and colour of a statement service.
({String label, IconData icon, AstroHue hue}) serviceStyle(
  BuildContext context,
  String key,
) {
  final l = context.l10n;
  return switch (key) {
    'consultation' => (
      label: l.earnSvcConsultation,
      icon: Icons.forum_rounded,
      hue: AstroPalette.career,
    ),
    'gift' => (
      label: l.earnSvcGift,
      icon: Icons.card_giftcard_rounded,
      hue: AstroPalette.love,
    ),
    'prediction' => (
      label: l.earnSvcPrediction,
      icon: Icons.auto_awesome_rounded,
      hue: AstroPalette.air,
    ),
    'store' => (
      label: l.earnSvcStore,
      icon: Icons.storefront_rounded,
      hue: AstroPalette.money,
    ),
    'recommendation' => (
      label: l.earnSvcRecommendation,
      icon: Icons.thumb_up_alt_rounded,
      hue: AstroPalette.health,
    ),
    'refund' => (
      label: l.earnSvcRefund,
      icon: Icons.undo_rounded,
      hue: AstroPalette.fire,
    ),
    'fine' => (
      label: l.earnSvcFine,
      icon: Icons.gavel_rounded,
      hue: AstroPalette.fire,
    ),
    _ => (
      label: l.earnSvcBonus,
      icon: Icons.emoji_events_rounded,
      hue: AstroPalette.money,
    ),
  };
}

String _channelName(BuildContext context, String channel) =>
    channel == 'live_call'
    ? context.l10n.earnLiveCall
    : channelStyle(context, channel).label;

/// "Platform fee (30%)" — the rate when every earning had the same one.
String _withRate(String label, String? percent) =>
    percent == null || percent.isEmpty || percent == '0'
    ? label
    : '$label ($percent%)';

/// What a service row shows: what customers paid, or — for fines and refunds,
/// where nobody paid anything — what came off the astrologer's share.
double _shown(StatementService svc) =>
    svc.key == 'fine' || svc.key == 'refund' ? svc.share : svc.earned;

/// Where the money came from: one row per service, tap for its items.
class StatementServicesCard extends StatelessWidget {
  const StatementServicesCard({required this.statement, super.key});

  final EarningsStatement statement;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final s = statement;
    if (s.services.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Text(
          l.earnNothingYet,
          textAlign: TextAlign.center,
          style: TextStyle(color: brand.inkMuted),
        ),
      );
    }
    return Column(
      children: [
        for (final svc in s.services)
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => StatementItemsPage(
                  payoutId: s.payoutId,
                  service: svc.key,
                  currency: s.currency,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  HueIcon(
                    hue: serviceStyle(context, svc.key).hue,
                    icon: serviceStyle(context, svc.key).icon,
                    size: 34,
                    iconSize: 16,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceStyle(context, svc.key).label,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          svc.channels.isEmpty
                              ? l.earnItemsCount(svc.count)
                              : [
                                  for (final e in svc.channels.entries)
                                    '${_channelName(context, e.key)} ${Money.format(e.value, s.currency)}',
                                ].join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // fines and refunds: what they took off, as a minus
                  Text(
                    Money.format(_shown(svc), s.currency),
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: _shown(svc) < 0 ? brand.live : null,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: brand.inkMuted),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// What came off, down to the payout.
class StatementDeductionsCard extends StatelessWidget {
  const StatementDeductionsCard({required this.statement, super.key});

  final EarningsStatement statement;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final t = statement.totals;
    String m(double v) => Money.format(v, statement.currency);

    Widget row(
      String label,
      String value, {
      bool bold = false,
      bool minus = false,
      Color? color,
    }) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: bold ? null : brand.inkMuted,
                fontWeight: bold ? FontWeight.w800 : null,
              ),
            ),
          ),
          Text(
            minus ? '−$value' : value,
            style:
                (bold
                        ? theme.textTheme.titleMedium
                        : theme.textTheme.bodyMedium)
                    ?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: color ?? (minus ? brand.live : null),
                    ),
          ),
        ],
      ),
    );

    final tdsLabel = [
      l.earnTds,
      if (t.tdsSection.isNotEmpty) t.tdsSection,
    ].join(' ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row(l.earnCustomersPaid, m(t.earned)),
        if (t.platformFee != 0)
          row(
            _withRate(l.earnPlatformFee, t.platformFeePercent),
            m(t.platformFee),
            minus: true,
          ),
        if (t.gst != 0)
          row(_withRate(l.earnGstOnFee, t.gstPercent), m(t.gst), minus: true),
        if (t.gateway != 0)
          row(
            _withRate(l.earnGateway, t.gatewayPercent),
            m(t.gateway),
            minus: true,
          ),
        Divider(height: 14, color: brand.hairline),
        row(l.earnYourShare, m(t.share), bold: true),
        if (t.tds != 0)
          row(_withRate(tdsLabel, t.tdsPercent), m(t.tds), minus: true),
        Divider(height: 14, color: brand.hairline),
        row(l.earnPayoutLine, m(t.payout), bold: true, color: brand.online),
        if (statement.isCurrent && t.clearing > 0)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              l.earnClearingNote(m(t.clearing)),
              style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
            ),
          ),
        if (statement.isCurrent && t.onHold > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              l.earnOnHoldNote(m(t.onHold)),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AstroPalette.money.end,
              ),
            ),
          ),
      ],
    );
  }
}

/// Every earning behind a statement for one service, each with its own
/// breakdown and status.
class StatementItemsPage extends StatefulWidget {
  const StatementItemsPage({
    required this.service,
    required this.currency,
    this.payoutId,
    super.key,
  });

  final String? payoutId;
  final String service;
  final String currency;

  @override
  State<StatementItemsPage> createState() => _StatementItemsPageState();
}

class _StatementItemsPageState extends State<StatementItemsPage> {
  late Future<List<StatementItem>> _future = _fetch();

  Future<List<StatementItem>> _fetch() => getIt<EarningsApi>().statementItems(
    payoutId: widget.payoutId,
    service: widget.service,
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SubPageScaffold(
      title: serviceStyle(context, widget.service).label,
      children: [
        FutureBuilder<List<StatementItem>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snap.hasError) {
              return ErrorView(
                message: l.commonLoadFailed,
                onRetry: () => setState(() {
                  _future = _fetch();
                }),
              );
            }
            final rows = snap.data ?? const [];
            if (rows.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Center(child: Text(l.earnNothingYet)),
              );
            }
            return Column(
              children: [
                for (final r in rows)
                  _ItemCard(item: r, currency: widget.currency),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item, required this.currency});

  final StatementItem item;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final r = item;
    String m(double v) => Money.format(v, currency);

    Widget line(String label, double value, {bool minus = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
            ),
          ),
          Text(
            minus ? '−${m(value)}' : m(value),
            style: theme.textTheme.bodySmall?.copyWith(
              color: minus ? brand.live : null,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    final when = r.at == null ? '' : shortDate(context, r.at!);
    final sub = [
      when,
      if (r.minutes != null && r.minutes! > 0) l.earnMinutes(r.minutes!),
      if (r.status == StatementStatuses.clearing && r.availableOn != null)
        l.earnClearsOn(shortDate(context, r.availableOn!)),
    ].where((s) => s.isNotEmpty).join(' · ');

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: r.consultationId == null
            ? null
            : () => context.push(Routes.requestDetail(r.consultationId!)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      r.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  StatementStatusChip(status: r.status),
                ],
              ),
              if (sub.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 6),
                  child: Text(
                    sub,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                ),
              line(l.earnCustomersPaid, r.earned),
              if (r.platformFee != 0)
                line(
                  _withRate(l.earnPlatformFee, r.platformFeePercent),
                  r.platformFee,
                  minus: true,
                ),
              if (r.gst != 0)
                line(
                  _withRate(l.earnGstOnFee, r.gstPercent),
                  r.gst,
                  minus: true,
                ),
              if (r.gateway != 0)
                line(
                  _withRate(l.earnGateway, r.gatewayPercent),
                  r.gateway,
                  minus: true,
                ),
              Divider(height: 12, color: brand.hairline),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.earnYourShare,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Text(
                    m(r.share),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: r.share < 0 ? brand.live : brand.online,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
