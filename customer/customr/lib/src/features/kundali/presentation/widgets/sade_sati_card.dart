import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../kundali_terms.dart';
import 'kundali_ui.dart';

/// Calm (amber, never alarm-red) Sade Sati / small-panoti summary. Falls back to
/// a "current transits" teaser when neither is active.
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
    final brand = context.brand;
    final l = context.l10n;
    const phases = ['rising', 'peak', 'setting'];
    final phaseLabels = [l.kSsRising, l.kSsPeak, l.kSsSetting];
    final activeIdx = phases.indexOf(t.sadeSatiPhase);
    return KCard(
      tint: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.brightness_3_rounded, size: 17, color: brand.onTint),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  l.kSsTitle(_phaseName(l, t.sadeSatiPhase)),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: brand.onTint,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            KTerms.sadeSati(l, t.sadeSatiPhase),
            style: const TextStyle(fontSize: 13.5, height: 1.45),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i != 0) const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: i == activeIdx
                          ? brand.onTint.withValues(alpha: 0.14)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: brand.hairline),
                    ),
                    child: Text(
                      phaseLabels[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: i == activeIdx
                            ? brand.onTint
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.kSsNotCurse,
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
          if (onTap != null)
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(l.kSsWhatForMe),
            ),
        ],
      ),
    );
  }

  Widget _panoti(BuildContext context, Transits t) {
    final brand = context.brand;
    final l = context.l10n;
    return KCard(
      tint: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.kSsPanotiTitle(t.smallPanotiType),
            style: TextStyle(fontWeight: FontWeight.w700, color: brand.onTint),
          ),
          const SizedBox(height: 6),
          Text(
            l.kSsPanotiBody,
            style: const TextStyle(fontSize: 13.5, height: 1.45),
          ),
          if (onTap != null)
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(l.kSsSeeTransits),
            ),
        ],
      ),
    );
  }

  Widget _teaser(BuildContext context, Transits t) {
    final l = context.l10n;
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KLabel(l.kSsSkyNow),
          const SizedBox(height: 6),
          Text(
            t.jupiterFavourable ? l.kSsJupiterGood : l.kSsJupiterNeutral,
            style: const TextStyle(fontSize: 13.5, height: 1.45),
          ),
          if (onTap != null)
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(l.kSsSeeAllTransits),
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
