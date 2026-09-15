import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../kundali_terms.dart';
import 'kundali_ui.dart';

/// Calm (amber / indigo, never alarm-red) Sade Sati / small-panoti summary.
/// Falls back to a "sky right now" teaser when neither is active.
class SadeSatiCard extends StatelessWidget {
  const SadeSatiCard({required this.transits, this.onTap, super.key});

  final Transits transits;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = transits;
    if (t.sadeSatiActive) return _sadeSati(context, t);
    if (t.smallPanotiActive) return _panoti(context, t);
    return _teaser(context, t);
  }

  Widget _sadeSati(BuildContext context, Transits t) {
    final l = context.l10n;
    final theme = Theme.of(context);
    const hue = AstroPalette.money;
    return KHueCard(
      hue: hue,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PlanetBadge('Saturn', size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.kSsTitle(_phaseName(l, t.sadeSatiPhase)),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SaturnPhaseStepper(
            labels: [l.kSsRising, l.kSsPeak, l.kSsSetting],
            active: const [
              'rising',
              'peak',
              'setting',
            ].indexOf(t.sadeSatiPhase),
          ),
          const SizedBox(height: 12),
          Text(
            KTerms.sadeSati(l, t.sadeSatiPhase),
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 6),
          Text(
            l.kSsNotCurse,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.brand.inkMuted,
              height: 1.4,
            ),
          ),
          if (onTap != null) _Link(label: l.kSsWhatForMe, hue: hue),
        ],
      ),
    );
  }

  Widget _panoti(BuildContext context, Transits t) {
    final l = context.l10n;
    final theme = Theme.of(context);
    const hue = AstroPalette.air;
    return KHueCard(
      hue: hue,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PlanetBadge('Saturn', size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.kSsPanotiTitle(t.smallPanotiType),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l.kSsPanotiBody,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          if (onTap != null) _Link(label: l.kSsSeeTransits, hue: hue),
        ],
      ),
    );
  }

  Widget _teaser(BuildContext context, Transits t) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hue = t.jupiterFavourable ? AstroPalette.health : AstroPalette.air;
    return KHueCard(
      hue: hue,
      onTap: onTap,
      child: Row(
        children: [
          HueIcon(hue: hue, icon: Icons.public_rounded, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KLabel(l.kSsSkyNow),
                const SizedBox(height: 4),
                Text(
                  t.jupiterFavourable ? l.kSsJupiterGood : l.kSsJupiterNeutral,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                ),
                if (onTap != null) _Link(label: l.kSsSeeAllTransits, hue: hue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _phaseName(AppLocalizations l, String p) => switch (p) {
    'rising' => l.kSsPhaseRising,
    'peak' => l.kSsPhasePeak,
    'setting' => l.kSsPhaseSetting,
    _ => '',
  };
}

class _Link extends StatelessWidget {
  const _Link({required this.label, required this.hue});
  final String label;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: hue.end,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Icon(Icons.chevron_right_rounded, size: 18, color: hue.end),
      ],
    ),
  );
}

/// Rising → Peak → Setting as three connected steps, the active one filled.
class SaturnPhaseStepper extends StatelessWidget {
  const SaturnPhaseStepper({
    required this.labels,
    required this.active,
    this.hints,
    this.hue = AstroPalette.money,
    super.key,
  });

  final List<String> labels;
  final int active;
  final List<String>? hints;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 3,
                        color: i == 0
                            ? Colors.transparent
                            : (i <= active ? hue.end : brand.hairline),
                      ),
                    ),
                    Container(
                      width: i == active ? 22 : 14,
                      height: i == active ? 22 : 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: i <= active ? hue.linear() : null,
                        color: i <= active ? null : brand.hairline,
                        border: i == active
                            ? Border.all(color: hue.tint(0.35), width: 4)
                            : null,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 3,
                        color: i == labels.length - 1
                            ? Colors.transparent
                            : (i < active ? hue.end : brand.hairline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: i == active ? FontWeight.w800 : FontWeight.w600,
                    color: i == active ? hue.end : brand.inkMuted,
                  ),
                ),
                if (hints != null && i < hints!.length)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      hints![i],
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: brand.inkMuted,
                        height: 1.25,
                      ),
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
