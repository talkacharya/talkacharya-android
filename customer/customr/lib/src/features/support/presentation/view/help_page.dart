import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/config_repository.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../consultations/data/models/consultation.dart';
import '../../data/models/dispute.dart';
import '../cubit/help_cubit.dart';
import '../widgets/dispute_ui.dart';

/// Help & support hub (`/profile/help`): report a session, track reports,
/// contact the team, FAQs.
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(title: Text(l.helpTitle)),
      body: BlocBuilder<HelpCubit, HelpState>(
        builder: (context, state) => RefreshIndicator(
          onRefresh: () => context.read<HelpCubit>().load(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            children: FadeSlideIn.list([
              const _Hero(),
              _Section(
                title: l.helpReportSection,
                child: _SessionsCard(state: state),
              ),
              if (state.disputes.value?.isNotEmpty ?? false)
                _Section(
                  title: l.helpYourReports,
                  child: _ReportsCard(disputes: state.disputes.value!),
                ),
              _Section(
                title: l.helpContactSection,
                child: const _ContactCard(),
              ),
              _Section(title: l.helpFaqSection, child: const _FaqCard()),
            ]),
          ),
        ),
      ),
    );
  }
}

// --- hero -------------------------------------------------------------------

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          const Positioned.fill(child: CosmicBackdrop()),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.helpHeroTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: brand.onCosmic,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l.helpHeroBody,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: brand.onCosmicMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                const HueIcon(
                  hue: AstroPalette.money,
                  icon: Icons.support_agent_rounded,
                  size: 56,
                  iconSize: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- sessions you can report ---------------------------------------------

class _SessionsCard extends StatelessWidget {
  const _SessionsCard({required this.state});
  final HelpState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sessions = state.sessions;
    final reported = state.disputeBySession;

    if (sessions.status == AsyncStatus.error && !sessions.hasValue) {
      return _Card(
        child: _InlineRetry(
          message: l.helpLoadError,
          onRetry: () => context.read<HelpCubit>().load(),
        ),
      );
    }
    final list = sessions.value;
    if (list == null) return const _Card(child: _RowsSkeleton());
    if (list.isEmpty) {
      return _Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.forum_outlined, color: context.brand.inkMuted),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.helpReportEmpty,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.brand.inkMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return _Card(
      child: Column(
        children: [
          for (var i = 0; i < list.length; i++) ...[
            if (i > 0)
              Divider(height: 1, indent: 68, color: context.brand.hairline),
            _SessionRow(consultation: list[i], report: reported[list[i].id]),
          ],
        ],
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.consultation, this.report});

  final Consultation consultation;
  final Dispute? report;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = consultation;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final channel = switch (c.channel) {
      'voice' => l.channelVoice,
      'video' => l.channelVideo,
      _ => l.channelChat,
    };
    final r = report;
    // Reload on return — a report may have been filed or updated meanwhile.
    void open(String location, {Object? extra}) {
      final cubit = context.read<HelpCubit>();
      context.push(location, extra: extra).whenComplete(cubit.load);
    }

    return InkWell(
      onTap: r != null
          ? () => open(Routes.dispute(r.id), extra: r)
          : () => open(Routes.reportIssue(c.id)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Row(
          children: [
            HueAvatar(
              name: c.astrologerName,
              url: c.astrologerAvatar,
              hue: AstroPalette.forId(c.astrologerId),
              size: 42,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.astrologerName,
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
                      Money.format(c.gross, c.currency, locale: locale),
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
            const SizedBox(width: 8),
            if (r != null)
              DisputeStatusChip(status: r.status)
            else
              FilledButton.tonal(
                onPressed: () => open(Routes.reportIssue(c.id)),
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: Text(l.helpReportAction),
              ),
          ],
        ),
      ),
    );
  }
}

// --- your reports --------------------------------------------------------

class _ReportsCard extends StatelessWidget {
  const _ReportsCard({required this.disputes});
  final List<Dispute> disputes;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return _Card(
      child: Column(
        children: [
          for (var i = 0; i < disputes.length; i++) ...[
            if (i > 0)
              Divider(height: 1, indent: 64, color: context.brand.hairline),
            InkWell(
              onTap: () {
                final cubit = context.read<HelpCubit>();
                context
                    .push(Routes.dispute(disputes[i].id), extra: disputes[i])
                    .whenComplete(cubit.load);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Row(
                  children: [
                    HueIcon(
                      hue: disputes[i].type.hue,
                      icon: disputes[i].type.icon,
                      size: 38,
                      iconSize: 19,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            disputes[i].type.label(l),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            [
                              l.reportSessionWith(
                                disputes[i].consultation.astrologerName,
                              ),
                              disputeDate(context, disputes[i].createdAt),
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
                    const SizedBox(width: 8),
                    DisputeStatusChip(status: disputes[i].status),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// --- contact ---------------------------------------------------------------

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final support = getIt<ConfigRepository>().value.support;
    final rows = <Widget>[
      if (support.whatsapp.isNotEmpty)
        _ContactRow(
          icon: Icons.chat_rounded,
          hue: AstroPalette.health,
          label: l.helpWhatsapp,
          value: support.whatsapp,
          onTap: () => _open(
            'https://wa.me/${support.whatsapp.replaceAll(RegExp(r'[^0-9]'), '')}',
          ),
        ),
      if (support.email.isNotEmpty)
        _ContactRow(
          icon: Icons.mail_rounded,
          hue: AstroPalette.career,
          label: l.helpEmailUs,
          value: support.email,
          onTap: () => _open('mailto:${support.email}'),
        ),
      if (support.helpUrl.isNotEmpty)
        _ContactRow(
          icon: Icons.menu_book_rounded,
          hue: AstroPalette.water,
          label: l.helpCentre,
          onTap: () => _open(support.helpUrl),
        ),
    ];
    if (rows.isEmpty) return const SizedBox.shrink();
    return _Card(
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(height: 1, indent: 64, color: context.brand.hairline),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.hue,
    required this.label,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final AstroHue hue;
  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: hue.tint(0.13),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: hue.end),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (value != null)
                    Text(
                      value!,
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
              Icons.open_in_new_rounded,
              size: 18,
              color: context.brand.inkMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// --- FAQ ----------------------------------------------------------------------

class _FaqCard extends StatelessWidget {
  const _FaqCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final faqs = [
      (l.helpFaqChargesQ, l.helpFaqChargesA),
      (l.helpFaqNoResponseQ, l.helpFaqNoResponseA),
      (l.helpFaqRefundQ, l.helpFaqRefundA),
      (l.helpFaqBalanceQ, l.helpFaqBalanceA),
      (l.helpFaqPrivacyQ, l.helpFaqPrivacyA),
      (l.helpFaqLanguageQ, l.helpFaqLanguageA),
    ];
    return _Card(
      child: Theme(
        // ExpansionTile draws its own dividers; the card already separates rows.
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: Column(
          children: [
            for (var i = 0; i < faqs.length; i++) ...[
              if (i > 0)
                Divider(height: 1, indent: 16, color: context.brand.hairline),
              ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                expandedAlignment: Alignment.centerLeft,
                title: Text(
                  faqs[i].$1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Text(
                    faqs[i].$2,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// --- shared --------------------------------------------------------------------

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.brand.inkMuted,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.brand.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _RowsSkeleton extends StatelessWidget {
  const _RowsSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            for (var i = 0; i < 3; i++)
              Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : 14),
                child: const Row(
                  children: [
                    SkeletonBox(width: 42, height: 42, radius: 21),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonBox(width: 140),
                          SizedBox(height: 8),
                          SkeletonBox(width: 200, height: 10),
                        ],
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

class _InlineRetry extends StatelessWidget {
  const _InlineRetry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, color: context.brand.inkMuted),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
          TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
        ],
      ),
    );
  }
}
