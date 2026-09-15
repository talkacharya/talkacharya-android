import 'package:customr/src/core/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../data/models/home_consultation.dart';
import '../../cubit/home_cubit.dart';
import 'home_shared.dart';

/// Recently consulted astrologers — the cheapest repeat revenue. Hidden for
/// users with no history. Each tile carries the astrologer's own colour.
class TalkAgainRail extends StatelessWidget {
  const TalkAgainRail({super.key});

  @override
  Widget build(BuildContext context) {
    final talkAgain = context.select((HomeCubit c) => c.state.talkAgain);
    final items = talkAgain.value ?? const <HomeConsultation>[];
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.homeTalkAgainTitle,
          hue: AstroPalette.fire,
          seeAllLabel: 'History',
          onSeeAll: () => context.push(Routes.chats),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(
              HomeGaps.side,
              0,
              HomeGaps.side,
              12,
            ),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) => _Tile(consultation: items[i]),
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.consultation});

  final HomeConsultation consultation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = consultation;
    final hue = HomeHues.forId(c.astrologerId);
    void open() => context.go(Routes.astrologer(c.astrologerId));

    return Pressable(
      child: SizedBox(
        width: 120,
        child: HueTile(
          hue: hue,
          radius: 22,
          padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
          onTap: open,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [hue.start, hue.end, hue.start],
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surface,
                  ),
                  child: HueAvatar(name: c.astrologerName, hue: hue, size: 48),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                c.astrologerName.isEmpty ? 'Astrologer' : c.astrologerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  gradient: hue.linear(),
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.replay_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Chat',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
