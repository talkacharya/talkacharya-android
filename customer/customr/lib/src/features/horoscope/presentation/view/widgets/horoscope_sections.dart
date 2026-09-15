import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../../../shared/widgets/score_ring.dart';
import '../../../../home/data/models/zodiac.dart';
import '../../../../kundali/presentation/kundali_terms.dart';
import '../../../data/models/sign_horoscope.dart';
import '../horoscope_page.dart';

/// Card chrome used by every section: surface, hairline, generous radius.
class _Section extends StatelessWidget {
  const _Section({required this.child, this.color});
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.brand.hairline),
      ),
      child: child,
    );
  }
}

String areaLabel(AppLocalizations l, String key) => switch (key) {
  'love' => l.horoAreaLove,
  'career' => l.horoAreaCareer,
  'money' => l.horoAreaMoney,
  'health' => l.horoAreaHealth,
  _ => key,
};

String toneLabel(AppLocalizations l, int score) => score >= 4
    ? l.horoToneSupportive
    : score == 3
    ? l.horoToneBalanced
    : l.horoToneChallenging;

// --- overview --------------------------------------------------------------------

class OverviewCard extends StatelessWidget {
  const OverviewCard({required this.horoscope, super.key});
  final SignHoroscope horoscope;

  @override
  Widget build(BuildContext context) {
    final h = horoscope;
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final band = AstroPalette.band(h.overall);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: brand.hairline),
        boxShadow: brand.shadowWarm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    band.start.withValues(alpha: 0.22),
                    band.start.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ScoreRing(
                      value: h.overall / 5,
                      colors: [band.start, band.end, band.start],
                      size: 104,
                      stroke: 10,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${h.overall}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: band.end,
                              height: 1,
                            ),
                          ),
                          Text(
                            l.horoOutOfFive,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: brand.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (h.band.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: band.linear(),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                h.band,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            h.headline.isNotEmpty ? h.headline : l.horoOverall,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontFamily:
                                  theme.textTheme.titleLarge?.fontFamily,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                          if (h.isEditorial) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  size: 14,
                                  color: brand.online,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    l.horoEditorialBadge,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: brand.online,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (h.general.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    h.general,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                  ),
                ],
                if (h.areas.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Divider(height: 1, color: brand.hairline),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final a in h.areas)
                        Expanded(child: _MiniAreaRing(area: a)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniAreaRing extends StatelessWidget {
  const _MiniAreaRing({required this.area});
  final HoroscopeArea area;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hue = AstroPalette.area(area.key);
    final theme = Theme.of(context);
    return Semantics(
      label: '${areaLabel(l, area.key)} ${area.score}/5',
      child: Column(
        children: [
          ScoreRing(
            value: area.score / 5,
            colors: [hue.start, hue.end, hue.start],
            size: 54,
            stroke: 5,
            trackColor: hue.tint(0.14),
            center: Icon(
              AstroPalette.areaIcon(area.key),
              size: 20,
              color: hue.end,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              areaLabel(l, area.key),
              maxLines: 1,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '${area.score}/5',
            style: theme.textTheme.labelSmall?.copyWith(
              color: hue.end,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// --- life areas ------------------------------------------------------------------

class AreaCard extends StatelessWidget {
  const AreaCard({required this.area, super.key});
  final HoroscopeArea area;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final hue = AstroPalette.area(area.key);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: brand.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                gradient: hue.linear(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: hue.linear(),
                            boxShadow: [
                              BoxShadow(
                                color: hue.start.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            AstroPalette.areaIcon(area.key),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                areaLabel(l, area.key),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                toneLabel(l, area.score),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: hue.end,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _SegmentMeter(score: area.score, hue: hue),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      area.text,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentMeter extends StatelessWidget {
  const _SegmentMeter({required this.score, required this.hue});
  final int score;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: i <= score ? 1 : 0),
            duration: Duration(milliseconds: 250 + i * 90),
            curve: Curves.easeOutBack,
            builder: (context, t, _) => Container(
              width: 8,
              height: 8 + 10 * (i / 5),
              margin: const EdgeInsets.only(left: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Color.lerp(
                  hue.tint(0.18),
                  Color.lerp(hue.start, hue.end, i / 5),
                  t,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// --- lucky ------------------------------------------------------------------------

class LuckyRow extends StatelessWidget {
  const LuckyRow({required this.lucky, super.key});
  final HoroscopeLucky lucky;

  static Color _hex(String hex) {
    final v = int.tryParse(hex.replaceFirst('#', ''), radix: 16) ?? 0xF2A93B;
    return Color(0xFF000000 | v);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final colour = _hex(lucky.colourHex);
    final planet = KTerms.planetName(l, lucky.planet);

    Widget tile({
      required Widget visual,
      required String label,
      required String value,
      required List<Color> wash,
    }) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: wash,
            ),
            border: Border.all(color: context.brand.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 34, child: visual),
              const SizedBox(height: 10),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: context.brand.inkMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        tile(
          visual: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colour,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(color: colour.withValues(alpha: 0.5), blurRadius: 10),
              ],
            ),
          ),
          label: l.horoLuckyColour,
          value: lucky.colourLabel,
          wash: [
            colour.withValues(alpha: 0.16),
            colour.withValues(alpha: 0.04),
          ],
        ),
        const SizedBox(width: 10),
        tile(
          visual: ShaderMask(
            shaderCallback: (r) => const LinearGradient(
              colors: BrandColors.goldGradient,
            ).createShader(r),
            child: Text(
              '${lucky.number}',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                height: 1.05,
              ),
            ),
          ),
          label: l.horoLuckyNumber,
          value: '${lucky.number}',
          wash: [
            const Color(0xFFF2A93B).withValues(alpha: 0.16),
            const Color(0xFFF2A93B).withValues(alpha: 0.03),
          ],
        ),
        const SizedBox(width: 10),
        tile(
          visual: Icon(
            Icons.brightness_7_rounded,
            size: 32,
            color: AstroPalette.career.end,
          ),
          label: l.horoLuckyPlanet,
          value: planet,
          wash: [
            AstroPalette.career.tint(0.14),
            AstroPalette.career.tint(0.03),
          ],
        ),
      ],
    );
  }
}

// --- favourable days -------------------------------------------------------------

class FavourableDaysCard extends StatelessWidget {
  const FavourableDaysCard({required this.horoscope, super.key});
  final SignHoroscope horoscope;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final hue = AstroPalette.band(5);
    final fmtTop = DateFormat.E(locale);
    final fmtBottom = DateFormat.d(locale);
    return _Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_available_rounded, color: hue.end, size: 20),
              const SizedBox(width: 8),
              Text(
                l.horoBestDays,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final d in horoscope.favourableDays)
                Container(
                  width: 54,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: hue.linear(),
                    boxShadow: [
                      BoxShadow(
                        color: hue.start.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        fmtTop.format(d),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        fmtBottom.format(d),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- tip ----------------------------------------------------------------------------

class TipCard extends StatelessWidget {
  const TipCard({required this.horoscope, super.key});
  final SignHoroscope horoscope;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFFF6D695).withValues(alpha: 0.35), brand.tint],
        ),
        border: Border.all(color: brand.gold.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: BrandColors.goldGradient),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  horoscope.tipPlanet == null
                      ? l.horoTipTitle
                      : l.horoTipFor(
                          KTerms.planetName(l, horoscope.tipPlanet!),
                        ),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: brand.onTint,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  horoscope.tip!,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- why (transits) ---------------------------------------------------------------

class WhyCard extends StatelessWidget {
  const WhyCard({required this.horoscope, super.key});
  final SignHoroscope horoscope;

  @override
  Widget build(BuildContext context) {
    final h = horoscope;
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final good = AstroPalette.band(5);
    final watch = AstroPalette.band(2);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [brand.cosmicStart, brand.cosmicEnd],
        ),
        boxShadow: brand.shadowCosmic,
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: brand.onCosmic,
          collapsedIconColor: brand.onCosmicMuted,
          leading: Icon(Icons.public_rounded, color: brand.cosmicAccent),
          title: Text(
            l.horoWhyTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              color: brand.onCosmic,
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: h.moonSignLabel == null
              ? null
              : Text(
                  l.horoMoonLine(
                    h.moonSignLabel!,
                    h.moonNakshatraLabel ?? '',
                    '${h.moonHouse ?? '-'}',
                  ),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: brand.onCosmicMuted,
                  ),
                ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.horoWhyBody,
              style: theme.textTheme.bodySmall?.copyWith(
                color: brand.onCosmicMuted,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in h.transits)
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 6, 10, 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: (t.favourable ? good.start : watch.end).withValues(
                        alpha: 0.16,
                      ),
                      border: Border.all(
                        color: (t.favourable ? good.start : watch.end)
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          t.favourable
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          size: 14,
                          color: t.favourable ? good.start : watch.start,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${KTerms.planetName(l, t.planet)} · ${l.horoHouseN('${t.house}')}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: brand.onCosmic,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- about the sign ----------------------------------------------------------------

class AboutSignCard extends StatelessWidget {
  const AboutSignCard({required this.sign, super.key});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hue = AstroPalette.element(sign.index);
    final name = KTerms.signName(l, sign.label);

    Widget fact(IconData icon, String label, String value) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: hue.end),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: context.brand.inkMuted,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    return _Section(
      color: hue.tint(0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.horoAboutSign(name),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            KTerms.sign(l, sign.label),
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              fact(
                signElementIcon(sign.index),
                l.horoElement,
                signElementLabel(l, sign.index),
              ),
              fact(
                Icons.brightness_7_rounded,
                l.horoRuler,
                KTerms.planetName(l, signRuler(sign.index)),
              ),
              fact(
                Icons.sync_alt_rounded,
                l.horoQuality,
                signQualityLabel(l, sign.index),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- CTA + source -------------------------------------------------------------------

class AstrologerCta extends StatelessWidget {
  const AstrologerCta({required this.sign, super.key});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return Pressable(
      child: Material(
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF8A3D), Color(0xFFE8364F), Color(0xFF8B3FE4)],
            ),
          ),
          child: InkWell(
            onTap: () =>
                context.go(Routes.astrologersWith(sort: 'recommended')),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.horoCtaTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontFamily: theme.textTheme.titleLarge?.fontFamily,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.horoCtaBody(KTerms.signName(l, sign.label)),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l.horoCtaButton,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: brand.primaryPressed,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.support_agent_rounded,
                    color: Colors.white,
                    size: 54,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SourceNote extends StatelessWidget {
  const SourceNote({required this.horoscope, super.key});
  final SignHoroscope horoscope;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        context.l10n.horoSourceNote,
        textAlign: TextAlign.center,
        style: theme.textTheme.labelSmall?.copyWith(
          color: context.brand.inkMuted,
          height: 1.4,
        ),
      ),
    );
  }
}
