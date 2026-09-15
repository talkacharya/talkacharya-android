import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
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
  int _table = 0; // 0 day choghadiya · 1 night choghadiya · 2 hora

  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadMuhurta();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const hue = AstroPalette.money;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.muhurta != b.muhurta,
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final day = state.muhurta.value;
        final theme = Theme.of(context);
        return KundaliScaffold(
          title: l.muhurtaTitle,
          eyebrow: day == null || day.weekday.isEmpty
              ? l.kOvTitle
              : day.weekday,
          headline: l.muhurtaTitle,
          subheadline: l.kMuHeroSub,
          hue: hue,
          heroTrailing: const KHeroGlyph(
            hue: hue,
            icon: Icons.schedule_rounded,
            size: 72,
          ),
          heroChips: day == null || !day.available
              ? const []
              : [
                  if (day.sunrise.isNotEmpty)
                    KHeroChip(icon: Icons.wb_sunny_rounded, label: day.sunrise),
                  if (day.sunset.isNotEmpty)
                    KHeroChip(
                      icon: Icons.nights_stay_rounded,
                      label: day.sunset,
                    ),
                  if (day.dayLord.isNotEmpty)
                    KHeroChip(
                      icon: Icons.brightness_7_rounded,
                      label: KTerms.planetName(l, day.dayLord),
                      color: kPlanetHue(day.dayLord).start,
                    ),
                ],
          onRefresh: () => cubit.loadMuhurta(force: true),
          animate: day != null,
          children: day == null
              ? [
                  SliceBuilder<MuhurtaDay>(
                    slice: state.muhurta,
                    onRetry: () => cubit.loadMuhurta(force: true),
                    skeleton: const KBodySkeleton(blocks: [130, 160, 320]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : !day.available
              ? [
                  KHueCard(
                    hue: AstroPalette.air,
                    child: Row(
                      children: [
                        const HueIcon(
                          hue: AstroPalette.air,
                          icon: Icons.location_off_rounded,
                          size: 40,
                          iconSize: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            day.disclaimer,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const KAskCta(),
                ]
              : [
                  Text(
                    l.muhurtaIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.muhurtaSunTimes(
                      day.sunrise,
                      day.sunset,
                      day.weekday,
                      KTerms.planetName(l, day.dayLord),
                    ),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: context.brand.inkMuted,
                    ),
                  ),
                  if (day.currentChoghadiya != null ||
                      day.currentHora != null) ...[
                    const SizedBox(height: 14),
                    _NowCard(day: day),
                  ],
                  KSection(
                    title: l.muhurtaBestWindows,
                    hue: AstroPalette.health,
                    child: _BestWindows(day: day),
                  ),
                  KSection(
                    title: l.kMuTimingsTitle,
                    hue: hue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        KSegment(
                          labels: [l.kMuTabDay, l.kMuTabNight, l.muhurtaHora],
                          selected: _table,
                          onSelect: (i) => setState(() => _table = i),
                          hue: hue,
                        ),
                        const SizedBox(height: 12),
                        switch (_table) {
                          0 => _ChoghadiyaList(slots: day.dayChoghadiya),
                          1 => _ChoghadiyaList(slots: day.nightChoghadiya),
                          _ => _HoraList(horas: day.horas),
                        },
                      ],
                    ),
                  ),
                  if (day.disclaimer.isNotEmpty) KFootnote(day.disclaimer),
                  const KAskCta(),
                ],
        );
      },
    );
  }
}

String _choName(AppLocalizations l, String name) => name.isEmpty
    ? ''
    : l.kMuChoghadiya(name, '${name[0].toUpperCase()}${name.substring(1)}');

(KTone, String) _quality(AppLocalizations l, String q) => switch (q) {
  'good' => (KTone.good, l.muhurtaChoGood),
  'bad' => (KTone.caution, l.muhurtaChoBad),
  _ => (KTone.neutral, l.muhurtaChoNeutral),
};

class _NowCard extends StatelessWidget {
  const _NowCard({required this.day});
  final MuhurtaDay day;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final cho = day.currentChoghadiya;
    final hora = day.currentHora;
    final (tone, label) = _quality(l, cho?.quality ?? 'neutral');
    final hue = kToneHue(tone);
    return KHueCard(
      hue: hue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              KToneChip(l.muhurtaNow, hue: hue),
              if (cho != null) KToneChip(label, tone: tone),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (cho != null)
                Expanded(
                  child: _NowFact(
                    icon: Icons.timelapse_rounded,
                    hue: hue,
                    title: _choName(l, cho.name),
                    sub: '${cho.start}–${cho.end}',
                  ),
                ),
              if (cho != null && hora != null) const SizedBox(width: 10),
              if (hora != null)
                Expanded(
                  child: _NowFact(
                    badge: hora.lord,
                    hue: kPlanetHue(hora.lord),
                    title: l.kMuHoraOf(KTerms.planetName(l, hora.lord)),
                    sub: '${hora.start}–${hora.end}',
                  ),
                ),
            ],
          ),
          if (day.summary.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              day.summary,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ],
        ],
      ),
    );
  }
}

class _NowFact extends StatelessWidget {
  const _NowFact({
    required this.hue,
    required this.title,
    required this.sub,
    this.icon,
    this.badge,
  });
  final AstroHue hue;
  final String title;
  final String sub;
  final IconData? icon;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          if (badge != null)
            PlanetBadge(badge!, size: 30)
          else
            KIconBox(icon: icon!, hue: hue, size: 30),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: context.brand.inkMuted,
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

class _BestWindows extends StatelessWidget {
  const _BestWindows({required this.day});
  final MuhurtaDay day;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    if (day.bestWindows.isEmpty && day.abhijit == null) {
      return KSurface(
        child: Text(
          l.muhurtaNoBest,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
        ),
      );
    }
    Widget row(MuhurtaBestWindow w, {bool abhijit = false}) {
      final hue = abhijit
          ? AstroPalette.money
          : (w.horaLord.isEmpty ? AstroPalette.health : kPlanetHue(w.horaLord));
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: KSurface(
          padding: const EdgeInsets.all(12),
          radius: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: hue.linear(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    for (final t in [w.start, w.end])
                      Text(
                        t,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (abhijit)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: KToneChip(l.kMuAbhijit, hue: hue),
                      ),
                    Text(
                      w.summary,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final w in day.bestWindows) row(w),
        if (day.abhijit != null) row(day.abhijit!, abhijit: true),
      ],
    );
  }
}

class _ChoghadiyaList extends StatelessWidget {
  const _ChoghadiyaList({required this.slots});
  final List<ChoghadiyaSlot> slots;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return KSurface(
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          for (final s in slots)
            Builder(
              builder: (context) {
                final (tone, label) = _quality(l, s.quality);
                final hue = kToneHue(tone);
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: s.running ? hue.tint(0.14) : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: hue.linear(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _choName(l, s.name),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${s.start}–${s.end} · ${KTerms.planetName(l, s.lord)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: context.brand.inkMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (s.running) ...[
                        KPill(l.muhurtaNow, hue: hue),
                        const SizedBox(width: 6),
                      ],
                      KToneChip(label, tone: tone),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _HoraList extends StatelessWidget {
  const _HoraList({required this.horas});
  final List<HoraSlot> horas;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return KSurface(
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          for (final h in horas)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: h.running ? kPlanetHue(h.lord).tint(0.14) : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  PlanetBadge(h.lord, size: 32),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${KTerms.planetName(l, h.lord)} · ${h.start}–${h.end}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (h.goodFor.isNotEmpty)
                          Text(
                            h.goodFor,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.brand.inkMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (h.personal == 'favourable')
                    KToneChip(l.muhurtaHoraFavourable, tone: KTone.good)
                  else if (h.personal == 'caution')
                    KToneChip(l.muhurtaHoraCaution, tone: KTone.caution),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
