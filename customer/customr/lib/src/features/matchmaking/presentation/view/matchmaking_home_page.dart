import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/utils/haptic_service.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../birthprofiles/data/models/birth_profile.dart';
import '../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../data/models/match_result.dart';
import '../cubit/matchmaking_cubit.dart';
import 'widgets/match_widgets.dart';

class MatchmakingHomePage extends StatefulWidget {
  const MatchmakingHomePage({super.key});

  @override
  State<MatchmakingHomePage> createState() => _MatchmakingHomePageState();
}

class _MatchmakingHomePageState extends State<MatchmakingHomePage> {
  @override
  void initState() {
    super.initState();
    final profiles = context.read<BirthProfilesCubit>();
    final cubit = context.read<MatchmakingCubit>();
    cubit.loadHistory();
    unawaited(
      profiles.load().then((_) {
        if (mounted) cubit.suggestFrom(profiles.state.primaryProfile);
      }),
    );
  }

  Future<void> _pick(BuildContext context, {required bool boy}) async {
    HapticService.light();
    final cubit = context.read<MatchmakingCubit>();
    final picked = await showPartnerPicker(
      context,
      boy: boy,
      exclude: boy ? cubit.state.girl?.id : cubit.state.boy?.id,
      selected: boy ? cubit.state.boy?.id : cubit.state.girl?.id,
    );
    if (picked == null || !context.mounted) return;
    boy ? cubit.setBoy(picked) : cubit.setGirl(picked);
  }

  Future<void> _run(BuildContext context) async {
    HapticService.medium();
    final router = GoRouter.of(context);
    final result = await context.read<MatchmakingCubit>().run();
    if (result != null && mounted) {
      unawaited(router.push(MatchRoutes.result(result.id), extra: result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return BlocConsumer<MatchmakingCubit, MatchmakingState>(
      listenWhen: (a, b) => b.error != null && a.error != b.error,
      listener: (context, state) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error!))),
      builder: (context, state) {
        final cubit = context.read<MatchmakingCubit>();
        return Scaffold(
          backgroundColor: brand.canvas,
          body: RefreshIndicator(
            color: AstroPalette.romance[1],
            edgeOffset: 100,
            onRefresh: () => cubit.loadHistory(force: true),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 250,
                  backgroundColor: AstroPalette.romance[1],
                  foregroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  title: Text(l.matchTitle),
                  flexibleSpace: const FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: _Hero(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
                  sliver: SliverList.list(
                    children: FadeSlideIn.list([
                      _PairPicker(
                        state: state,
                        onPickBoy: () => _pick(context, boy: true),
                        onPickGirl: () => _pick(context, boy: false),
                        onSwap: state.boy == null && state.girl == null
                            ? null
                            : () {
                                HapticService.light();
                                cubit.swap();
                              },
                      ),
                      const SizedBox(height: 16),
                      GradientCta(
                        label: l.matchRunCta,
                        icon: Icons.favorite_rounded,
                        busy: state.running,
                        enabled: state.canRun,
                        onPressed: () => _run(context),
                      ),
                      if (!state.canRun) ...[
                        const SizedBox(height: 8),
                        Text(
                          l.matchPickBothHint,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: brand.inkMuted),
                        ),
                      ],
                      const SizedBox(height: 26),
                      const _HowItWorks(),
                      const SizedBox(height: 26),
                      _History(state: state),
                      const SizedBox(height: 36),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MatchRoutes {
  const MatchRoutes._();
  static const base = '/matchmaking';
  static String result(String id) => '/matchmaking/$id';
}

// --- hero -------------------------------------------------------------------------

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AstroPalette.romance,
            ),
          ),
        ),
        Positioned(
          right: -24,
          bottom: -16,
          child: Opacity(
            opacity: 0.9,
            child: SvgPicture.asset('assets/svg/matching.svg', width: 150),
          ),
        ),
        const CustomPaint(painter: HeartsPainter()),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 4, 118, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  l.matchHeroTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l.matchHeroBody,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- pair picker ------------------------------------------------------------------

class _PairPicker extends StatelessWidget {
  const _PairPicker({
    required this.state,
    required this.onPickBoy,
    required this.onPickGirl,
    required this.onSwap,
  });

  final MatchmakingState state;
  final VoidCallback onPickBoy;
  final VoidCallback onPickGirl;
  final VoidCallback? onSwap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: brand.hairline),
        boxShadow: brand.shadowWarm,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: _PartnerSlot(
                  title: l.matchBoy,
                  hue: AstroPalette.partnerA,
                  profile: state.boy,
                  onTap: onPickBoy,
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: _PartnerSlot(
                  title: l.matchGirl,
                  hue: AstroPalette.partnerB,
                  profile: state.girl,
                  onTap: onPickGirl,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PulsingHeart(size: 40),
              const SizedBox(height: 6),
              IconButton.filledTonal(
                tooltip: l.matchSwap,
                visualDensity: VisualDensity.compact,
                onPressed: onSwap,
                icon: const Icon(Icons.swap_horiz_rounded, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PartnerSlot extends StatelessWidget {
  const _PartnerSlot({
    required this.title,
    required this.hue,
    required this.profile,
    required this.onTap,
  });

  final String title;
  final AstroHue hue;
  final BirthProfile? profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final p = profile;
    return Pressable(
      child: Material(
        color: hue.tint(p == null ? 0.06 : 0.1),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: p == null ? hue.start.withValues(alpha: 0.45) : hue.end,
                width: p == null ? 1.2 : 1.6,
              ),
            ),
            child: Column(
              children: [
                Text(
                  title.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: hue.end,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (c, a) =>
                      ScaleTransition(scale: a, child: c),
                  child: p == null
                      ? Container(
                          key: const ValueKey('empty'),
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(color: hue.start, width: 1.5),
                          ),
                          child: Icon(
                            Icons.person_add_alt_1_rounded,
                            color: hue.end,
                          ),
                        )
                      : PersonAvatar(
                          key: ValueKey(p.id),
                          initials: _initials(p.displayName),
                          hue: hue,
                          size: 64,
                        ),
                ),
                const SizedBox(height: 10),
                Text(
                  p?.displayName ?? l.matchChoosePerson,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: p == null ? brand.inkMuted : brand.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  p == null ? l.matchTapToSelect : _birthLine(context, p),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: brand.inkMuted,
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

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  final letters = parts
      .take(2)
      .map((p) => String.fromCharCode(p.runes.first).toUpperCase());
  return letters.isEmpty ? '?' : letters.join();
}

String _birthLine(BuildContext context, BirthProfile p) {
  final d = DateTime.tryParse(p.birthDate);
  if (d == null) return p.birthPlaceName;
  final date = DateFormat.yMMMd(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(d);
  return date;
}

// --- picker sheet -----------------------------------------------------------------

/// Pick one of the user's birth profiles for a slot, or add a new person.
/// Profiles matching the slot's gender are listed first.
Future<BirthProfile?> showPartnerPicker(
  BuildContext context, {
  required bool boy,
  String? exclude,
  String? selected,
}) {
  final l = context.l10n;
  final hue = boy ? AstroPalette.partnerA : AstroPalette.partnerB;
  return showAppSheet<BirthProfile>(
    context: context,
    title: boy ? l.matchPickBoyTitle : l.matchPickGirlTitle,
    builder: (sheet) => BlocBuilder<BirthProfilesCubit, BirthProfilesState>(
      bloc: context.read<BirthProfilesCubit>(),
      builder: (_, bp) {
        final want = boy ? 'male' : 'female';
        final list = [...bp.profiles.where((p) => p.id != exclude)]
          ..sort((a, b) {
            final ga = a.gender == want ? 0 : 1;
            final gb = b.gender == want ? 0 : 1;
            return ga != gb ? ga - gb : a.displayName.compareTo(b.displayName);
          });
        final theme = Theme.of(sheet);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Pressable(
              child: Material(
                color: hue.tint(0.1),
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    final created = await GoRouter.of(
                      sheet,
                    ).push<BirthProfile>(Routes.birthProfileNew);
                    if (created != null && sheet.mounted)
                      Navigator.pop(sheet, created);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: hue.linear(),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.matchAddPerson,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                l.matchAddPersonHint,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: sheet.brand.inkMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: hue.end),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (bp.status == BpStatus.loading && bp.profiles.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  l.matchNoProfiles,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: sheet.brand.inkMuted,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final p = list[i];
                    final isSel = p.id == selected;
                    final pHue = p.gender == 'female'
                        ? AstroPalette.partnerB
                        : p.gender == 'male'
                        ? AstroPalette.partnerA
                        : AstroPalette.health;
                    return Material(
                      color: isSel ? hue.tint(0.12) : theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSel ? hue.end : sheet.brand.hairline,
                        ),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        leading: PersonAvatar(
                          initials: _initials(p.displayName),
                          hue: pHue,
                          size: 42,
                        ),
                        title: Text(
                          p.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          [
                            relationLabel(l, p.relation),
                            _birthLine(sheet, p),
                          ].where((s) => s.isNotEmpty).join(' · '),
                        ),
                        trailing: isSel
                            ? Icon(Icons.check_circle_rounded, color: hue.end)
                            : null,
                        onTap: () => Navigator.pop(sheet, p),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
          ],
        );
      },
    ),
  );
}

// --- how it works -----------------------------------------------------------------

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final steps = [
      (
        Icons.people_alt_rounded,
        AstroPalette.career,
        l.matchStep1Title,
        l.matchStep1Body,
      ),
      (
        Icons.nightlight_round,
        AstroPalette.love,
        l.matchStep2Title,
        l.matchStep2Body,
      ),
      (
        Icons.insights_rounded,
        AstroPalette.health,
        l.matchStep3Title,
        l.matchStep3Body,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.matchHowTitle,
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: steps[i].$2.linear(),
                    boxShadow: [
                      BoxShadow(
                        color: steps[i].$2.start.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(steps[i].$1, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${i + 1}. ${steps[i].$3}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        steps[i].$4,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.brand.inkMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// --- history ----------------------------------------------------------------------

class _History extends StatelessWidget {
  const _History({required this.state});
  final MatchmakingState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final history = state.history;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.matchHistoryTitle,
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 12),
        history.when(
          idle: () => const _HistoryLoading(),
          loading: () => const _HistoryLoading(),
          error: (m) => Row(
            children: [
              Expanded(child: Text(m, style: theme.textTheme.bodySmall)),
              TextButton(
                onPressed: () =>
                    context.read<MatchmakingCubit>().loadHistory(force: true),
                child: Text(l.matchRetry),
              ),
            ],
          ),
          data: (items) => items.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AstroPalette.love.tint(0.07),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AstroPalette.love.tint(0.25)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        color: AstroPalette.love.end,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l.matchHistoryEmpty,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    for (final m in items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: MatchHistoryTile(match: m),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _HistoryLoading extends StatelessWidget {
  const _HistoryLoading();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(20),
    child: Center(child: CircularProgressIndicator()),
  );
}

class MatchHistoryTile extends StatelessWidget {
  const MatchHistoryTile({required this.match, super.key});
  final MatchResult match;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final band = AstroPalette.ratio(match.ratio);
    final date = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(match.createdAt);
    return Pressable(
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: brand.hairline),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => context.push(MatchRoutes.result(match.id), extra: match),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  height: 44,
                  child: Stack(
                    children: [
                      PersonAvatar(
                        initials: match.boy.initials,
                        hue: AstroPalette.partnerA,
                        size: 44,
                      ),
                      Positioned(
                        left: 26,
                        child: PersonAvatar(
                          initials: match.girl.initials,
                          hue: AstroPalette.partnerB,
                          size: 44,
                          ring: theme.colorScheme.surface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.matchPairNames(match.boy.name, match.girl.name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${verdictLabel(l, match.verdictKey)} · $date',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: band.linear(),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${match.pointsLabel}/36',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
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
