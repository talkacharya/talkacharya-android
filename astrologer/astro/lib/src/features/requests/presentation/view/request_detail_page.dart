import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../consultations/data/consultation_api.dart';
import '../../../consultations/data/models/consultation.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../../consultations/presentation/widgets/shared_details.dart';
import '../cubit/requests_cubit.dart';
import 'widgets/decline_reason_sheet.dart';

/// Opened from a History row or an incoming-request push. Shows the
/// consultation and — while it's still `requested` — an Accept / Decline bar.
/// If it's already live, it bounces straight into the room.
class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({required this.consultationId, super.key});
  final String consultationId;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  late Future<Consultation> _future = _fetch();
  bool _busy = false;

  Future<Consultation> _fetch() =>
      getIt<ConsultationApi>().detail(widget.consultationId);

  void _reload() => setState(() => _future = _fetch());

  Future<void> _accept() async {
    setState(() => _busy = true);
    final c = await context.read<RequestsCubit>().accept(widget.consultationId);
    if (!mounted) return;
    if (c == null) {
      setState(() => _busy = false);
      _snack(context.l10n.requestsActionFailed);
      return;
    }
    context.pushReplacement(Routes.chatRoom(c.id));
  }

  Future<void> _decline() async {
    final reason = await showDeclineReasonSheet(context);
    if (reason == null || !mounted) return;
    setState(() => _busy = true);
    final ok = await context.read<RequestsCubit>().reject(
      widget.consultationId,
      reason,
    );
    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      setState(() => _busy = false);
      _snack(context.l10n.requestsActionFailed);
    }
  }

  void _snack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FutureBuilder<Consultation>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError || !snap.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text(l.detailTitle)),
            body: ErrorView(message: l.detailLoadError, onRetry: _reload),
          );
        }
        final c = snap.data!;
        // Already live → the room is the right place.
        if (c.isLive) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) context.pushReplacement(Routes.chatRoom(c.id));
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _DetailView(
          consultation: c,
          busy: _busy,
          onAccept: _accept,
          onDecline: _decline,
          onRefresh: () async => _reload(),
        );
      },
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({
    required this.consultation,
    required this.busy,
    required this.onAccept,
    required this.onDecline,
    required this.onRefresh,
  });

  final Consultation consultation;
  final bool busy;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final l = context.l10n;
    final brand = context.brand;
    final pending = c.isRequested;
    final rate = double.tryParse(c.rateSnapshot) ?? 0;
    final gross = double.tryParse(c.grossAmount) ?? 0;
    final earned = double.tryParse(c.astrologerAmount) ?? 0;

    final sections = <Widget>[
      if (c.shares.isNotEmpty)
        _Card(
          title: l.sharedTitle,
          icon: Icons.auto_awesome_rounded,
          child: SharedDetailsSection(
            consultation: c,
            canOpen: c.isEnded,
            padding: EdgeInsets.zero,
          ),
        ),
      if (c.question.isNotEmpty)
        _Card(
          title: l.detailQuestion,
          icon: Icons.help_outline_rounded,
          child: Text(
            c.question,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
        ),
      _Card(
        title: l.detailSession,
        icon: Icons.schedule_rounded,
        child: Column(
          children: [
            if (c.requestedAt != null)
              _Row(
                l.detailRequestedAt,
                '${TimeFormat.day(l, c.requestedAt!)}, '
                '${TimeFormat.clock(l, c.requestedAt!)}',
              ),
            if (c.billedSeconds > 0)
              _Row(l.detailDuration, l.requestsMinutes(c.billedMinutes)),
            if (rate > 0)
              _Row(l.detailRate, l.dashPerMin(Money.format(rate, c.currency))),
          ],
        ),
      ),
      if (c.isEnded)
        _EarningsCard(
          gross: Money.format(gross, c.currency),
          earned: Money.format(earned, c.currency),
          rating: c.rating,
        ),
      // The shared chart is only served once a consultation was accepted.
      if (c.isEnded)
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () => context.push(
            Routes.consultationKundali(c.id),
            extra: c.customerName,
          ),
          icon: const Icon(Icons.auto_awesome_rounded),
          label: Text(l.detailKundali),
        ),
    ];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        edgeOffset: 100,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _Hero(consultation: c)),
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
      bottomNavigationBar: pending
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(top: BorderSide(color: brand.hairline)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: busy ? null : onDecline,
                          child: Text(l.requestsDecline),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: brand.online,
                          ),
                          onPressed: busy ? null : onAccept,
                          child: busy
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l.requestsAccept),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.consultation});

  final Consultation consultation;

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final brand = context.brand;
    final theme = Theme.of(context);
    final ch = channelStyle(context, c.channel);
    const radius = BorderRadius.vertical(bottom: Radius.circular(28));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ClipRRect(
        borderRadius: radius,
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
                    BackButton(color: brand.onCosmic),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: BrandColors.goldGradient,
                              ),
                            ),
                            child: HueAvatar(
                              name: c.customerName,
                              hue: ch.hue,
                              size: 64,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.customerName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(color: brand.onCosmic),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    _GlassPill(icon: ch.icon, label: ch.label),
                                    StatusChip(status: c.status),
                                  ],
                                ),
                              ],
                            ),
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

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: brand.glowAccent),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: brand.onCosmic,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.icon, required this.child});

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: brand.inkMuted),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: brand.inkMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.brand.inkMuted,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gold-accented "you earned" summary with the customer's rating.
class _EarningsCard extends StatelessWidget {
  const _EarningsCard({
    required this.gross,
    required this.earned,
    required this.rating,
  });

  final String gross;
  final String earned;
  final int? rating;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: brand.tint,
        borderRadius: BorderRadius.circular(Radii.lg),
        boxShadow: brand.shadowWarm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.detailYouEarned,
            style: theme.textTheme.labelLarge?.copyWith(color: brand.onTint),
          ),
          Text(earned, style: theme.textTheme.displaySmall),
          const SizedBox(height: 4),
          Text(
            '${l.detailCustomerPaid}: $gross',
            style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
          ),
          if (rating != null) ...[
            Divider(height: 24, color: brand.hairline),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.detailRating,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                ),
                for (var i = 1; i <= 5; i++)
                  Icon(
                    i <= rating!
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 20,
                    color: brand.gold,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
