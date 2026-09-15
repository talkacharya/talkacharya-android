import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/language_quick_button.dart';
import '../../data/models/daily_mood.dart';
import '../cubit/kundali_cubit.dart';
import '../widgets/kundali_ui.dart';

/// Today's mood (`/kundali/:id/mood`) — where the daily-mood push lands.
///
/// Deliberately partial: the mood, why, and one small tip are free; the
/// personal "why in your chart / remedy / dasha" part is shown locked and
/// leads to an astrologer.
class MoodPage extends StatefulWidget {
  const MoodPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  @override
  void initState() {
    super.initState();
    // the mood moves with the Moon — always fetch fresh on open
    context.read<KundaliCubit>().loadMood(force: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.mood != b.mood,
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final m = state.mood.value;
        final hue = _moodHue(m?.tone ?? '');
        return KundaliScaffold(
          title: l.moodTitle,
          eyebrow: l.moodTitle,
          headline: m?.headline ?? l.moodTitle,
          subheadline: m?.moonHouseLabel,
          hue: hue,
          actions: const [LanguageQuickButton()],
          heroTrailing: m == null
              ? KHeroGlyph(hue: hue, icon: Icons.nightlight_round, size: 72)
              : KHeroGlyph(hue: hue, text: m.emoji, size: 72),
          heroChips: m == null
              ? const []
              : [
                  if (m.moonSignLabel.isNotEmpty)
                    KHeroChip(
                      icon: Icons.nightlight_round,
                      label: m.moonSignLabel,
                    ),
                ],
          heroBottom: m == null ? null : _MoodMeter(level: m.level),
          onRefresh: () => cubit.loadMood(force: true),
          animate: m != null,
          children: m == null
              ? [
                  SliceBuilder<DailyMood>(
                    slice: state.mood,
                    onRetry: () => cubit.loadMood(force: true),
                    skeleton: const KBodySkeleton(blocks: [120, 120, 180]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : [
                  _Note(
                    icon: Icons.nightlight_round,
                    hue: AstroPalette.air,
                    title: l.moodWhyTitle,
                    body: m.why,
                  ),
                  const SizedBox(height: 12),
                  _Note(
                    icon: Icons.lightbulb_rounded,
                    hue: AstroPalette.money,
                    title: l.moodTipTitle,
                    body: m.tip,
                  ),
                  if (m.locked.isNotEmpty)
                    KSection(
                      title: l.moodLockedTitle,
                      subtitle: l.moodLockedSub,
                      hue: AstroPalette.love,
                      child: _LockedList(items: m.locked),
                    ),
                  if (m.nextChangeAt != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.update_rounded,
                          size: 16,
                          color: context.brand.inkMuted,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            l.moodNextChange(
                              DateFormat(
                                'EEE, h:mm a',
                                Localizations.localeOf(context).toLanguageTag(),
                              ).format(m.nextChangeAt!.toLocal()),
                            ),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: context.brand.inkMuted),
                          ),
                        ),
                      ],
                    ),
                  ],
                  KAskCta(title: l.moodTalkCta),
                  if (m.disclaimer.isNotEmpty) KFootnote(m.disclaimer),
                ],
        );
      },
    );
  }
}

AstroHue _moodHue(String tone) => switch (tone) {
  'bright' => AstroPalette.money,
  'steady' => AstroPalette.health,
  'tender' => AstroPalette.air,
  _ => AstroPalette.career,
};

/// 1 (heavy) … 5 (uplifted) as gold segments on the hero.
class _MoodMeter extends StatelessWidget {
  const _MoodMeter({required this.level});
  final int level;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Row(
      children: [
        Text(
          context.l10n.moodMeter,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: brand.onCosmicMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
        for (var i = 1; i <= 5; i++)
          Expanded(
            child: Container(
              height: 8,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: i <= level
                    ? brand.gold
                    : brand.onCosmic.withValues(alpha: 0.18),
              ),
            ),
          ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({
    required this.icon,
    required this.hue,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final AstroHue hue;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KHueCard(
      hue: hue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HueIcon(hue: hue, icon: icon, size: 34, iconSize: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(body, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}

class _LockedList extends StatelessWidget {
  const _LockedList({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return KSurface(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) Divider(height: 1, color: brand.hairline),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  const KIconBox(
                    icon: Icons.lock_rounded,
                    hue: AstroPalette.love,
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      items[i],
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
