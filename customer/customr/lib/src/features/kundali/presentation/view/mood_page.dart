import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(l.moodTitle),
        actions: const [LanguageQuickButton()],
      ),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        buildWhen: (a, b) => a.mood != b.mood,
        builder: (context, state) => SliceBuilder<DailyMood>(
          slice: state.mood,
          onRetry: () => context.read<KundaliCubit>().loadMood(force: true),
          builder: (context, m) => RefreshIndicator(
            onRefresh: () => context.read<KundaliCubit>().loadMood(force: true),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                _MoodHero(mood: m),
                const SizedBox(height: 14),
                _Section(
                  icon: Icons.nightlight_round,
                  title: l.moodWhyTitle,
                  body: m.why,
                ),
                const SizedBox(height: 10),
                _Section(
                  icon: Icons.lightbulb_outline_rounded,
                  title: l.moodTipTitle,
                  body: m.tip,
                ),
                const SizedBox(height: 14),
                _LockedCard(mood: m),
                if (m.nextChangeAt != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    l.moodNextChange(
                      DateFormat(
                        'EEE, h:mm a',
                        Localizations.localeOf(context).toLanguageTag(),
                      ).format(m.nextChangeAt!.toLocal()),
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Text(
                  m.disclaimer,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
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

class _MoodHero extends StatelessWidget {
  const _MoodHero({required this.mood});
  final DailyMood mood;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [brand.cosmicStart, brand.cosmicEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(mood.emoji, style: const TextStyle(fontSize: 34)),
              const Spacer(),
              _Pill(text: '🌙 ${mood.moonSignLabel}'),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            mood.headline,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: brand.onCosmic,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            mood.moonHouseLabel,
            style: TextStyle(color: brand.onCosmicMuted, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                l.moodMeter,
                style: TextStyle(
                  color: brand.onCosmicMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              for (var i = 1; i <= 5; i++)
                Container(
                  width: 22,
                  height: 8,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: i <= mood.level
                        ? brand.gold
                        : brand.onCosmic.withValues(alpha: 0.18),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: brand.onCosmic.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: brand.onCosmic,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}

class _LockedCard extends StatelessWidget {
  const _LockedCard({required this.mood});
  final DailyMood mood;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final l = context.l10n;
    return KCard(
      tint: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.moodLockedTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: brand.onTint,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.moodLockedSub,
            style: TextStyle(fontSize: 12.5, color: brand.onTint, height: 1.4),
          ),
          const SizedBox(height: 12),
          for (final item in mood.locked)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: brand.onTint,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          AskAstrologerBar(
            label: l.moodTalkCta,
            onTap: () => context.go(Routes.astrologers),
          ),
        ],
      ),
    );
  }
}
