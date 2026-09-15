import 'package:customr/src/core/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../astrologers/data/models/astrologer.dart';
import '../../cubit/home_cubit.dart';
import 'astrologer_card.dart';
import 'home_shared.dart';

const _channels = <(String, String, IconData, AstroHue)>[
  ('', 'All', Icons.people_rounded, AstroPalette.money),
  ('chat', 'Chat', Icons.chat_bubble_rounded, AstroPalette.career),
  ('voice', 'Call', Icons.phone_in_talk_rounded, AstroPalette.health),
  ('video', 'Video', Icons.videocam_rounded, AstroPalette.love),
];

/// The core marketplace surface — recommended astrologers, channel-filterable
/// in place, one-tap into a profile. Redesigned chips with gradient selection.
class OnlineAstrologersRail extends StatelessWidget {
  const OnlineAstrologersRail({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final online = context.select((HomeCubit c) => c.state.online);
    final channel = context.select((HomeCubit c) => c.state.onlineChannel);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.homeTalkToAstrologerTitle,
          hue: AstroPalette.career,
          onSeeAll: () => context.go(
            Routes.astrologersWith(
              channel: channel.isEmpty ? null : channel,
              sort: 'recommended',
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: HomeGaps.sidePad,
            itemCount: _channels.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final (value, label, icon, hue) = _channels[i];
              final selected = value == channel;
              return _FilterChip(
                label: label,
                icon: icon,
                hue: hue,
                selected: selected,
                onTap: () => cubit.setOnlineChannel(value),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SectionSwitcher(
          child: online.when(
            idle: () => const _RailSkeleton(),
            loading: () => online.hasValue
                ? _Rail(items: online.value!)
                : const _RailSkeleton(),
            error: (msg) => SectionError(
              onRetry: cubit.retryOnline,
              label: "Couldn't load astrologers",
            ),
            data: (items) => items.isEmpty
                ? Padding(
                    padding: HomeGaps.sidePad,
                    child: Text(
                      'No astrologers match this filter right now.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : _Rail(items: items),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.hue,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final AstroHue hue;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: selected ? hue.linear() : null,
            color: selected ? null : hue.tint(0.08),
            border: selected ? null : Border.all(color: hue.tint(0.25)),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: hue.start.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: selected ? Colors.white : hue.end),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? Colors.white : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.items});
  final List<Astrologer> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kAstrologerCardHeight + 24,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(HomeGaps.side, 2, HomeGaps.side, 22),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) => AstrologerCard(astrologer: items[i]),
      ),
    );
  }
}

class _RailSkeleton extends StatelessWidget {
  const _RailSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kAstrologerCardHeight + 24,
      child: HomeShimmer(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(
            HomeGaps.side,
            2,
            HomeGaps.side,
            22,
          ),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, _) => Container(
            width: 184,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}
