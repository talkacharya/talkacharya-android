import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../data/earnings_api.dart';
import '../../data/earnings_models.dart';
import '../widgets/earnings_widgets.dart';

class PayoutDetailPage extends StatefulWidget {
  const PayoutDetailPage({required this.payoutId, super.key});
  final String payoutId;

  @override
  State<PayoutDetailPage> createState() => _PayoutDetailPageState();
}

class _PayoutDetailPageState extends State<PayoutDetailPage> {
  late Future<Payout> _future = _fetch();

  Future<Payout> _fetch() => getIt<EarningsApi>().payout(widget.payoutId);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FutureBuilder<Payout>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError || !snap.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text(l.payoutTitle)),
            body: ErrorView(
              message: l.payoutLoadError,
              onRetry: () => setState(() => _future = _fetch()),
            ),
          );
        }
        return _PayoutView(
          payout: snap.data!,
          onRefresh: () async {
            final next = _fetch();
            setState(() => _future = next);
            await next;
          },
        );
      },
    );
  }
}

class _PayoutView extends StatelessWidget {
  const _PayoutView({required this.payout, required this.onRefresh});

  final Payout payout;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final p = payout;
    final l = context.l10n;
    final sections = <Widget>[
      _Section(
        title: l.payoutTimeline,
        child: _Timeline(payout: p),
      ),
      _Section(
        title: l.payoutBreakdown,
        child: _Breakdown(payout: p),
      ),
      if (p.utr.isNotEmpty) _UtrCard(utr: p.utr),
      if (p.documents.isNotEmpty)
        _Section(
          title: l.earnTabDocuments,
          padded: false,
          child: Column(
            children: [
              for (final d in p.documents) TaxDocumentTile(document: d),
            ],
          ),
        ),
      if (p.entries.isNotEmpty)
        _Section(
          title: '${l.payoutIncluded} · ${p.entries.length}',
          padded: false,
          child: Column(
            children: [
              for (final e in p.entries)
                EarningEntryTile(
                  entry: e,
                  onTap: e.consultationId == null
                      ? null
                      : () => context.push(
                          Routes.requestDetail(e.consultationId!),
                        ),
                ),
            ],
          ),
        ),
    ];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        edgeOffset: 120,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _Hero(payout: p)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              sliver: SliverList.list(
                children: [
                  for (var i = 0; i < sections.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: FadeSlideIn(
                        delay: Duration(milliseconds: 60 * i),
                        child: sections[i],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.payout});

  final Payout payout;

  @override
  Widget build(BuildContext context) {
    final p = payout;
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final period = (p.periodStart != null && p.periodEnd != null)
        ? '${shortDate(context, p.periodStart!)} – ${shortDate(context, p.periodEnd!)}'
        : '';
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        child: Stack(
          children: [
            const Positioned.fill(child: CosmicBackdrop()),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BackButton(color: brand.onCosmic),
                        Text(
                          l.payoutTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: brand.onCosmic,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (r) => const LinearGradient(
                              colors: BrandColors.goldGradient,
                            ).createShader(r),
                            child: Text(
                              Money.format(p.net, p.currency),
                              style: theme.textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _OnCosmic(
                                child: PayoutStatusChip(status: p.status),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  [
                                    if (period.isNotEmpty) period,
                                    l.payoutEntries(p.entryCount),
                                  ].join(' · '),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: brand.onCosmicMuted,
                                  ),
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
          ],
        ),
      ),
    );
  }
}

/// Gives a light chip a solid backing so it reads on the cosmic surface.
class _OnCosmic extends StatelessWidget {
  const _OnCosmic({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(999),
    ),
    child: child,
  );
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.padded = true,
  });

  final String title;
  final Widget child;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: brand.inkMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: padded
                ? const EdgeInsets.fromLTRB(16, 6, 16, 16)
                : const EdgeInsets.only(bottom: 6),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Vertical status steps: scheduled → transfer started → credited (or the
/// failure / hold / cancel outcome).
class _Timeline extends StatelessWidget {
  const _Timeline({required this.payout});

  final Payout payout;

  @override
  Widget build(BuildContext context) {
    final p = payout;
    final l = context.l10n;
    final brand = context.brand;
    final done = brand.online;
    final pendingColor = brand.hairline;

    String? when(DateTime? d) =>
        d == null ? null : '${TimeFormat.day(l, d)}, ${TimeFormat.clock(l, d)}';

    final steps = <_Step>[
      _Step(l.payoutStepScheduled, when(p.createdAt), done, true),
      switch (p.status) {
        PayoutStatuses.cancelled => _Step(
          l.payoutStepCancelled,
          null,
          brand.inkMuted,
          true,
        ),
        PayoutStatuses.onHold => _Step(
          l.payoutStepOnHold,
          null,
          payoutStatusStyle(context, p.status).color,
          true,
        ),
        _ => _Step(
          l.payoutStepInitiated,
          when(p.initiatedAt),
          p.initiatedAt != null ? done : pendingColor,
          p.initiatedAt != null,
        ),
      },
      if (p.status == PayoutStatuses.failed)
        _Step(
          l.payoutStepFailed,
          p.failureReason.isEmpty ? null : p.failureReason,
          brand.live,
          true,
        )
      else if (p.status != PayoutStatuses.cancelled &&
          p.status != PayoutStatuses.onHold)
        _Step(
          l.payoutStepPaid,
          when(p.paidAt),
          p.status == PayoutStatuses.paid ? done : pendingColor,
          p.status == PayoutStatuses.paid,
        ),
    ];

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          _StepRow(step: steps[i], last: i == steps.length - 1),
      ],
    );
  }
}

class _Step {
  const _Step(this.title, this.subtitle, this.color, this.reached);
  final String title;
  final String? subtitle;
  final Color color;
  final bool reached;
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.last});

  final _Step step;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step.reached ? step.color : Colors.transparent,
                    border: Border.all(color: step.color, width: 2),
                  ),
                  child: step.reached
                      ? const Icon(Icons.check, size: 10, color: Colors.white)
                      : null,
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: step.reached ? step.color : brand.hairline,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: step.reached ? null : brand.inkMuted,
                    ),
                  ),
                  if (step.subtitle != null)
                    Text(
                      step.subtitle!,
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

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.payout});

  final Payout payout;

  @override
  Widget build(BuildContext context) {
    final p = payout;
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    String m(double v) => Money.format(v, p.currency);

    Widget row(String label, String value, {bool bold = false, Color? color}) =>
        Padding(
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
                value,
                style:
                    (bold
                            ? theme.textTheme.titleMedium
                            : theme.textTheme.bodyMedium)
                        ?.copyWith(fontWeight: FontWeight.w800, color: color),
              ),
            ],
          ),
        );

    return Column(
      children: [
        row(l.payoutGross, m(p.gross)),
        if (p.tds > 0) row(l.payoutTds, '−${m(p.tds)}', color: brand.live),
        if (p.otherDeductions > 0)
          row(l.payoutOther, '−${m(p.otherDeductions)}', color: brand.live),
        Divider(height: 18, color: brand.hairline),
        row(l.payoutNet, m(p.net), bold: true, color: brand.online),
      ],
    );
  }
}

class _UtrCard extends StatelessWidget {
  const _UtrCard({required this.utr});

  final String utr;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
        leading: Icon(Icons.account_balance_rounded, color: brand.inkMuted),
        title: Text(
          l.payoutUtr,
          style: theme.textTheme.labelLarge?.copyWith(color: brand.inkMuted),
        ),
        subtitle: SelectableText(
          utr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
            letterSpacing: 0.6,
          ),
        ),
        trailing: IconButton(
          tooltip: l.payoutCopy,
          icon: const Icon(Icons.copy_rounded),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            await Clipboard.setData(ClipboardData(text: utr));
            messenger.showSnackBar(SnackBar(content: Text(l.payoutCopied)));
          },
        ),
      ),
    );
  }
}
