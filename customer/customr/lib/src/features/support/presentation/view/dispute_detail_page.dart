import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/api_error_l10n.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../data/models/dispute.dart';
import '../cubit/dispute_detail_cubit.dart';
import '../widgets/dispute_ui.dart';

/// One report's status (`/disputes/:id`, deep link
/// `talkacharya://disputes/{id}`).
class DisputeDetailPage extends StatelessWidget {
  const DisputeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(title: Text(l.disputeTitle)),
      body: BlocBuilder<DisputeDetailCubit, AsyncValue<Dispute>>(
        builder: (context, state) {
          final d = state.value;
          if (d == null) {
            if (state.isError) {
              return ErrorView(
                message: localizedError(context, state.error),
                onRetry: () => context.read<DisputeDetailCubit>().load(),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () => context.read<DisputeDetailCubit>().load(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              children: FadeSlideIn.list([
                _StatusHero(dispute: d),
                if (!d.status.isOpen) _OutcomeCard(dispute: d),
                _TimelineCard(dispute: d),
                _ReportCard(dispute: d),
                _SessionLink(dispute: d),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class _StatusHero extends StatelessWidget {
  const _StatusHero({required this.dispute});
  final Dispute dispute;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final d = dispute;
    final hue = d.status.hue;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: hue.tint(0.25)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [hue.tint(0.16), surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HueIcon(hue: hue, icon: d.status.icon, size: 48, iconSize: 24),
              const Spacer(),
              DisputeStatusChip(status: d.status),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            d.status.headline(l),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            d.status.isOpen
                ? l.disputeOpenBody
                : l.disputeReportedOn(disputeDate(context, d.createdAt)),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.brand.inkMuted,
              height: 1.4,
            ),
          ),
          if (d.refunded) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
              decoration: BoxDecoration(
                color: AstroPalette.health.tint(0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AstroPalette.health.end,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l.disputeRefundedTitle(
                        Money.format(
                          d.refundAmount!,
                          d.consultation.currency,
                          locale: locale,
                        ),
                      ),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AstroPalette.health.end,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push(Routes.wallet),
                    child: Text(l.disputeOpenWallet),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  const _OutcomeCard({required this.dispute});
  final Dispute dispute;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final note = dispute.resolutionNote.trim();
    return _Card(
      title: l.disputeOutcome,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note.isNotEmpty)
            Text(
              note,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          if (!dispute.refunded) ...[
            if (note.isNotEmpty) const SizedBox(height: 8),
            Text(
              l.disputeOutcomeNoRefund,
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.brand.inkMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.dispute});
  final Dispute dispute;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = dispute;
    final done = {for (final s in d.timeline) s.type: s.at};
    final finalType = d.status == DisputeStatus.rejected
        ? 'rejected'
        : 'resolved';
    // Always show the full path so an open report shows what comes next.
    final steps = ['raised', 'reviewing', finalType];
    // A closed report may skip "reviewing" (resolved straight away) — then it
    // counts as done too.
    bool isDone(String t) =>
        done.containsKey(t) || (t == 'reviewing' && !d.status.isOpen);

    return _Card(
      title: l.disputeTimeline,
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            _Step(
              label: disputeStepLabel(l, steps[i]),
              at: done[steps[i]],
              done: isDone(steps[i]),
              current: !isDone(steps[i]) && (i == 0 || isDone(steps[i - 1])),
              last: i == steps.length - 1,
            ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.label,
    required this.done,
    required this.current,
    required this.last,
    this.at,
  });

  final String label;
  final DateTime? at;
  final bool done;
  final bool current;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final active = AstroPalette.health.end;
    final color = done
        ? active
        : current
        ? AstroPalette.money.end
        : brand.hairline;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? active : Colors.transparent,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: done
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : null,
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: done ? active : brand.hairline,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: done || current
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: done || current ? brand.ink : brand.inkMuted,
                    ),
                  ),
                  if (at != null)
                    Text(
                      disputeDate(context, at, time: true),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.dispute});
  final Dispute dispute;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final type = dispute.type;
    return _Card(
      title: l.disputeYourReport,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: type.hue.tint(0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(type.icon, size: 17, color: type.hue.end),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  type.label(l),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (dispute.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              dispute.description,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ],
        ],
      ),
    );
  }
}

class _SessionLink extends StatelessWidget {
  const _SessionLink({required this.dispute});
  final Dispute dispute;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = dispute.consultation;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final channel = switch (c.channel) {
      'voice' => l.channelVoice,
      'video' => l.channelVideo,
      _ => l.channelChat,
    };
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: context.brand.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: c.id.isEmpty
              ? null
              : () => context.push(Routes.consultation(c.id)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                HueAvatar(
                  name: c.astrologerName,
                  hue: AstroPalette.forId(c.astrologerId),
                  size: 42,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.reportSessionWith(c.astrologerName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [
                          channel,
                          disputeDate(context, c.endedAt),
                          Money.format(
                            c.grossAmount,
                            c.currency,
                            locale: locale,
                          ),
                        ].where((s) => s.isNotEmpty).join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.brand.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.brand.inkMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.brand.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.brand.inkMuted,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
