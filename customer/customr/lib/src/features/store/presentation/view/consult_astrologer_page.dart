import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../../wallet/presentation/view/recharge_sheet.dart';
import '../../data/models/consult.dart';
import '../../data/models/product.dart';
import '../cubit/consult_cubits.dart';
import '../widgets/store_ui.dart';

/// `/store/products/:slug/consult` — pick an astrologer for a video call about
/// this product. The call runs in the normal consultation room.
class ConsultAstrologerPage extends StatelessWidget {
  const ConsultAstrologerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(title: Text(l.storeConsultTitle)),
      body: BlocBuilder<ConsultOptionsCubit, ConsultOptionsState>(
        builder: (context, state) {
          final options = state.options;
          final cubit = context.read<ConsultOptionsCubit>();
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              children: [
                _Hero(product: state.product.value, options: options.value),
                const SizedBox(height: 16),
                const _Steps(),
                const SizedBox(height: 20),
                StoreSectionTitle(l.storeConsultPick, hue: AstroPalette.career),
                if (options.isError && !options.hasValue)
                  SizedBox(
                    height: 260,
                    child: ErrorView(
                      message: options.error ?? '',
                      onRetry: cubit.load,
                    ),
                  )
                else if (options.value == null)
                  const _ListSkeleton()
                else if (!options.value!.enabled ||
                    options.value!.astrologers.isEmpty)
                  SizedBox(
                    height: 280,
                    child: EmptyState(
                      icon: Icons.videocam_off_rounded,
                      title: l.storeConsultNoneTitle,
                      message: l.storeConsultNoneBody,
                      action: OutlinedButton(
                        onPressed: () => context.go(
                          Routes.astrologersWith(channel: 'video'),
                        ),
                        child: Text(l.storeConsultBrowseAll),
                      ),
                    ),
                  )
                else
                  ...FadeSlideIn.list([
                    for (final a in options.value!.astrologers)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _AstrologerTile(
                          astrologer: a,
                          currency: options.value!.currency,
                          starting: state.startingId == a.id,
                          disabled: state.startingId != null,
                        ),
                      ),
                  ]),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.product, required this.options});
  final ProductDetail? product;
  final ConsultOptions? options;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final p = product;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          const Positioned.fill(child: CosmicBackdrop()),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 76,
                  height: 76,
                  child: StoreImage(
                    url: p?.card.image,
                    slug: p?.card.type ?? '',
                    radius: 18,
                    iconSize: 32,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.storeConsultAbout,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: brand.onCosmicMuted,
                        ),
                      ),
                      Text(
                        p?.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: brand.onCosmic,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _Pill(
                            icon: Icons.videocam_rounded,
                            label: l.storeConsultVideoPerMinute,
                          ),
                          if (options?.offerCouponCode != null)
                            _Pill(
                              icon: Icons.local_offer_rounded,
                              label: l.storeConsultOffer,
                              gold: true,
                            ),
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
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, this.gold = false});
  final IconData icon;
  final String label;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final color = gold ? context.brand.glowAccent : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _Steps extends StatelessWidget {
  const _Steps();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final steps = [
      (Icons.videocam_rounded, l.storeConsultStep1, AstroPalette.career),
      (Icons.auto_awesome_rounded, l.storeConsultStep2, AstroPalette.money),
      (Icons.shopping_bag_rounded, l.storeConsultStep3, AstroPalette.health),
    ];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                HueIcon(
                  hue: steps[i].$3,
                  icon: steps[i].$1,
                  size: 40,
                  iconSize: 20,
                ),
                const SizedBox(height: 6),
                Text(
                  steps[i].$2,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _AstrologerTile extends StatelessWidget {
  const _AstrologerTile({
    required this.astrologer,
    required this.currency,
    required this.starting,
    required this.disabled,
  });

  final ConsultAstrologer astrologer;
  final String currency;
  final bool starting;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final a = astrologer;
    final presenceLabel = switch (a.presence) {
      'online' => l.storePresenceOnline,
      'busy' => l.storePresenceBusy,
      _ => l.storePresenceOffline,
    };
    return StoreCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          PresenceAvatar(
            id: a.id,
            name: a.name,
            url: a.avatar,
            presence: a.presence,
            size: 56,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        a.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (a.skillMatch) ...[
                      const SizedBox(width: 6),
                      StoreBadge(
                        label: l.storeSpecialist,
                        hue: AstroPalette.money,
                      ),
                    ],
                  ],
                ),
                if (a.headline.isNotEmpty)
                  Text(
                    a.headline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    RatingLine(avg: a.ratingAvg, count: a.ratingCount),
                    if (a.yearsExperience > 0)
                      Text(
                        l.storeYearsExp(a.yearsExperience),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                    Text(
                      presenceLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: a.isOnline ? brand.online : brand.inkMuted,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l.storePerMinute(
                  storeMoney(context, a.ratePerMinute, currency),
                ),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 38),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  backgroundColor: AstroPalette.career.end,
                ),
                onPressed: (!a.canCallNow || disabled)
                    ? null
                    : () => _confirm(context, a),
                icon: starting
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.videocam_rounded, size: 18),
                label: Text(l.storeCall),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context, ConsultAstrologer a) async {
    final cubit = context.read<ConsultOptionsCubit>();
    final profile = context.read<BirthProfilesCubit>().state.resolvedProfile;
    final options = cubit.state.options.value;
    final question = await showAppSheet<String>(
      context: context,
      title: context.l10n.storeConsultConfirmTitle(a.name),
      builder: (_) => _ConfirmSheet(
        astrologer: a,
        currency: currency,
        preauthMinutes: options?.preauthMinutes ?? 5,
        defaultQuestion: options?.question ?? '',
        profileName: profile?.displayName,
      ),
    );
    if (question == null || !context.mounted) return;
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final outcome = await cubit.start(
      astrologer: a,
      question: question,
      birthProfileId: profile?.id,
    );
    if (!context.mounted) return;
    void toast(String m) => messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating, content: Text(m)),
      );
    switch (outcome) {
      case ConsultStarted(:final consultationId):
        router.pop();
        await router.push(Routes.consultation(consultationId));
      case ConsultNeedsRecharge(:final required):
        toast(l.storeConsultLowBalance);
        await showRechargeSheet(
          context,
          initialAmount: (required * (options?.preauthMinutes ?? 5)).ceil(),
        );
      case ConsultAstrologerBusy():
        toast(l.storeConsultBusy(a.name));
      case ConsultAstrologerOffline():
        toast(l.storeConsultOffline(a.name));
      case ConsultStartFailed(:final message):
        if (message.isNotEmpty) toast(message);
    }
  }
}

class _ConfirmSheet extends StatefulWidget {
  const _ConfirmSheet({
    required this.astrologer,
    required this.currency,
    required this.preauthMinutes,
    required this.defaultQuestion,
    this.profileName,
  });

  final ConsultAstrologer astrologer;
  final String currency;
  final int preauthMinutes;
  final String defaultQuestion;
  final String? profileName;

  @override
  State<_ConfirmSheet> createState() => _ConfirmSheetState();
}

class _ConfirmSheetState extends State<_ConfirmSheet> {
  late final _question = TextEditingController(text: widget.defaultQuestion);

  @override
  void dispose() {
    _question.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final a = widget.astrologer;
    final hold = a.ratePerMinute * widget.preauthMinutes;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _question,
          maxLines: 3,
          maxLength: 500,
          decoration: InputDecoration(labelText: l.storeConsultQuestion),
        ),
        if (widget.profileName != null)
          Row(
            children: [
              Icon(
                Icons.account_circle_rounded,
                size: 18,
                color: AstroPalette.career.end,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l.storeConsultSharingChart(widget.profileName!),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        const SizedBox(height: 10),
        Text(
          l.storeConsultHoldNote(
            storeMoney(context, a.ratePerMinute, widget.currency),
            storeMoney(context, hold, widget.currency),
          ),
          style: theme.textTheme.bodySmall?.copyWith(
            color: brand.inkMuted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        GoldButton(
          icon: Icons.videocam_rounded,
          label: l.storeConsultStartCall,
          onPressed: () => Navigator.of(context).pop(_question.text.trim()),
        ),
      ],
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) => AppShimmer(
    child: Column(
      children: [
        for (var i = 0; i < 4; i++)
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: SkeletonBox(height: 84, radius: 18),
          ),
      ],
    ),
  );
}
