import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

/// Personalised daily timing — Choghadiya + Hora for today, with the windows
/// that suit this chart highlighted (`/muhurta`). Guidance, not a rule.
class MuhurtaPage extends StatefulWidget {
  const MuhurtaPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<MuhurtaPage> createState() => _MuhurtaPageState();
}

class _MuhurtaPageState extends State<MuhurtaPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadMuhurta();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.muhurtaTitle)),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        buildWhen: (a, b) => a.muhurta != b.muhurta,
        builder: (context, state) => SliceBuilder<MuhurtaDay>(
          slice: state.muhurta,
          onRetry: () => context.read<KundaliCubit>().loadMuhurta(force: true),
          builder: (context, day) {
            if (!day.available) {
              return Center(child: Text(day.disclaimer));
            }
            final theme = Theme.of(context);
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              children: [
                Text(
                  l.muhurtaIntro,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l.muhurtaSunTimes(
                    day.sunrise,
                    day.sunset,
                    day.weekday,
                    day.dayLord,
                  ),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                if (day.currentChoghadiya != null || day.currentHora != null)
                  _NowCard(day: day),
                const SizedBox(height: 12),
                _BestWindows(day: day),
                const SizedBox(height: 12),
                _ChoghadiyaCard(
                  title: l.muhurtaDayChoghadiya,
                  slots: day.dayChoghadiya,
                ),
                const SizedBox(height: 10),
                _ChoghadiyaCard(
                  title: l.muhurtaNightChoghadiya,
                  slots: day.nightChoghadiya,
                ),
                const SizedBox(height: 10),
                _HoraCard(horas: day.horas),
                const SizedBox(height: 12),
                Text(
                  day.disclaimer,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NowCard extends StatelessWidget {
  const _NowCard({required this.day});
  final MuhurtaDay day;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return KCard(
      tint: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.muhurtaNow,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: context.brand.onTint,
            ),
          ),
          const SizedBox(height: 6),
          Text(day.summary, style: const TextStyle(fontSize: 13, height: 1.45)),
        ],
      ),
    );
  }
}

class _BestWindows extends StatelessWidget {
  const _BestWindows({required this.day});
  final MuhurtaDay day;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.muhurtaBestWindows,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),
          if (day.bestWindows.isEmpty)
            Text(
              l.muhurtaNoBest,
              style: const TextStyle(fontSize: 12.5, height: 1.4),
            )
          else
            for (final w in day.bestWindows)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  '·  ${w.summary}',
                  style: const TextStyle(fontSize: 12.5, height: 1.4),
                ),
              ),
          if (day.abhijit != null) ...[
            const SizedBox(height: 4),
            Text(
              '·  ${day.abhijit!.summary}',
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChoghadiyaCard extends StatelessWidget {
  const _ChoghadiyaCard({required this.title, required this.slots});
  final String title;
  final List<ChoghadiyaSlot> slots;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    (Color, Color, String) style(String q) => switch (q) {
      'good' => (
        const Color(0xFFDDF0E4),
        const Color(0xFF2C6B45),
        l.muhurtaChoGood,
      ),
      'bad' => (
        const Color(0xFFFBEBD8),
        const Color(0xFFB0691F),
        l.muhurtaChoBad,
      ),
      _ => (
        const Color(0xFFE4E8F5),
        const Color(0xFF3F4E86),
        l.muhurtaChoNeutral,
      ),
    };
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),
          for (final s in slots)
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: s.running
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.45)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.brand.hairline),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(
                      '${s.start}–${s.end}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${context.l10n.kMuChoghadiya(s.name, '${s.name[0].toUpperCase()}${s.name.substring(1)}')}'
                      ' · ${KTerms.planetName(context.l10n, s.lord)}',
                      style: const TextStyle(fontSize: 12.5),
                    ),
                  ),
                  Builder(
                    builder: (_) {
                      final (bg, fg, label) = style(s.quality);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: fg,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HoraCard extends StatelessWidget {
  const _HoraCard({required this.horas});
  final List<HoraSlot> horas;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.muhurtaHora,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),
          for (final h in horas)
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: h.running
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.45)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.brand.hairline),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(
                      '${h.start}–${h.end}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          KTerms.planetName(context.l10n, h.lord),
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          h.goodFor,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (h.personal != 'neutral')
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: h.personal == 'favourable'
                            ? const Color(0xFFDDF0E4)
                            : const Color(0xFFFBEBD8),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        h.personal == 'favourable'
                            ? l.muhurtaHoraFavourable
                            : l.muhurtaHoraCaution,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: h.personal == 'favourable'
                              ? const Color(0xFF2C6B45)
                              : const Color(0xFFB0691F),
                        ),
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
