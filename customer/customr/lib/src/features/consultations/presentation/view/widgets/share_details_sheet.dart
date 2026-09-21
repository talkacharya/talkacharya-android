import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/hue_widgets.dart';
import '../../../../birthprofiles/data/models/birth_profile.dart';
import '../../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../../../matchmaking/data/matchmaking_repository.dart';
import '../../../../matchmaking/data/models/match_result.dart';
import '../../../data/models/consultation.dart';
import '../../cubit/chat_cubit.dart';

/// Share a birth profile or a Guna Milan match with the astrologer without
/// leaving the room (so a live chat or call is never interrupted).
Future<void> showShareDetailsSheet(BuildContext context) {
  final cubit = context.read<ChatCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) =>
        BlocProvider.value(value: cubit, child: const _ShareSheet()),
  );
}

class _ShareSheet extends StatefulWidget {
  const _ShareSheet();

  @override
  State<_ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<_ShareSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  late Future<List<MatchResult>> _matches;

  /// The id currently being shared.
  String? _busy;

  @override
  void initState() {
    super.initState();
    context.read<BirthProfilesCubit>().load();
    _matches = getIt<MatchmakingRepository>().history();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _share({
    required String id,
    required String name,
    bool isMatch = false,
  }) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = id);
    final error = await context.read<ChatCubit>().share(
      birthProfileId: isMatch ? null : id,
      matchId: isMatch ? id : null,
    );
    if (!mounted) return;
    setState(() => _busy = null);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(error == null ? l.shareDone(name) : l.shareFailed),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = context.select((ChatCubit b) => b.state.consultation);
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.72,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.shareTitle, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    l.shareSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabs,
              tabs: [
                Tab(text: l.shareTabProfiles),
                Tab(text: l.shareTabMatches),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [_profiles(c), _matchList(c)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profiles(Consultation? c) {
    final l = context.l10n;
    final shared = c?.sharedProfileIds ?? const <String>{};
    return BlocBuilder<BirthProfilesCubit, BirthProfilesState>(
      builder: (context, state) {
        if (state.profiles.isEmpty) {
          return _Empty(
            icon: Icons.person_add_alt_rounded,
            text: l.shareNoProfiles,
            actionLabel: l.shareAddProfile,
            onAction: () {
              Navigator.pop(context);
              context.push(Routes.birthProfileNew);
            },
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            for (final p in state.profiles)
              _ShareTile(
                icon: Icons.person_rounded,
                hue: AstroPalette.forId(p.id),
                title: p.fullName.isNotEmpty ? p.fullName : p.label,
                subtitle: _profileLine(context, p),
                shared: shared.contains(p.id),
                busy: _busy == p.id,
                onShare: () => _share(
                  id: p.id,
                  name: p.fullName.isNotEmpty ? p.fullName : p.label,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _matchList(Consultation? c) {
    final l = context.l10n;
    final shared = c?.sharedMatchIds ?? const <String>{};
    return FutureBuilder<List<MatchResult>>(
      future: _matches,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snap.data ?? const <MatchResult>[];
        if (items.isEmpty) {
          return _Empty(
            icon: Icons.favorite_border_rounded,
            text: l.shareNoMatches,
            actionLabel: l.matchTitle,
            onAction: () {
              Navigator.pop(context);
              context.push(Routes.matchmaking);
            },
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            for (final m in items)
              _ShareTile(
                icon: Icons.favorite_rounded,
                hue: AstroPalette.love,
                title: '${m.boy.name} & ${m.girl.name}',
                subtitle: l.shareMatchPoints(
                  m.pointsLabel,
                  m.maximum.toStringAsFixed(0),
                ),
                shared: shared.contains(m.id),
                busy: _busy == m.id,
                onShare: () => _share(
                  id: m.id,
                  name: '${m.boy.name} & ${m.girl.name}',
                  isMatch: true,
                ),
              ),
          ],
        );
      },
    );
  }

  String _profileLine(BuildContext context, BirthProfile p) {
    final parts = [
      p.birthDate,
      if (p.timeAssumed || (p.birthTime ?? '').isEmpty)
        context.l10n.shareTimeUnknown
      else
        p.birthTime!,
      if (p.birthPlaceName.isNotEmpty) p.birthPlaceName,
    ];
    return parts.join(' · ');
  }
}

class _ShareTile extends StatelessWidget {
  const _ShareTile({
    required this.icon,
    required this.hue,
    required this.title,
    required this.subtitle,
    required this.shared,
    required this.busy,
    required this.onShare,
  });

  final IconData icon;
  final AstroHue hue;
  final String title;
  final String subtitle;
  final bool shared;
  final bool busy;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: HueTile(
        hue: hue,
        onTap: shared || busy ? null : onShare,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            HueIcon(hue: hue, icon: icon, size: 40, iconSize: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
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
            if (busy)
              const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (shared)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: brand.online,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l.shareShared,
                    style: TextStyle(
                      color: brand.online,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            else
              FilledButton.tonal(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                onPressed: onShare,
                child: Text(l.shareAction),
              ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({
    required this.icon,
    required this.text,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String text;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: brand.inkMuted),
            const SizedBox(height: 12),
            Text(text, style: TextStyle(color: brand.inkMuted)),
            const SizedBox(height: 16),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
