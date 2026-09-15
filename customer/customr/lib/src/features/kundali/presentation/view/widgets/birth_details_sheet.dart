import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/hue_widgets.dart';
import '../../../../birthprofiles/data/models/birth_profile.dart';
import '../../kundali_terms.dart';
import '../../widgets/kundali_ui.dart';

/// The full "birth details" surface — the janma panchang running at birth plus
/// the avakahada chakra (varna, vashya, yoni, gana, nadi, tara, …). Opened from
/// the identity strip on the kundali overview.
Future<void> showBirthDetailsSheet(
  BuildContext context, {
  required Kundali kundali,
  BirthProfile? profile,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _BirthDetailsSheet(kundali: kundali, profile: profile),
  );
}

class _BirthDetailsSheet extends StatelessWidget {
  const _BirthDetailsSheet({required this.kundali, this.profile});

  final Kundali kundali;
  final BirthProfile? profile;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final p = kundali.panchang;
    final c = kundali.chakra;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.82,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
        children: [
          Row(
            children: [
              HueIcon(
                hue: kSignHue(kundali.moonSign),
                icon: Icons.cake_rounded,
                size: 48,
                iconSize: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.birthDetailsTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (profile != null)
            Text(
              [
                profile!.displayName,
                profile!.birthDate,
                if ((profile!.birthTime ?? '').isNotEmpty)
                  profile!.birthTime!.substring(0, 5),
                if (profile!.birthPlaceName.isNotEmpty) profile!.birthPlaceName,
              ].join(' · '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            '${l.birthDetailsAyanamsa}: Lahiri / Chitrapaksha',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              if (kundali.moonSign.isNotEmpty)
                Expanded(
                  child: _Highlight(
                    hue: kSignHue(kundali.moonSign),
                    label: l.birthDetailsMoonSign,
                    value: KTerms.signName(l, kundali.moonSign),
                  ),
                ),
              if (kundali.moonSign.isNotEmpty && p.nakshatra.isNotEmpty)
                const SizedBox(width: 10),
              if (p.nakshatra.isNotEmpty)
                Expanded(
                  child: _Highlight(
                    hue: AstroPalette.career,
                    label: l.birthDetailsNakshatra,
                    value: KTerms.nakshatraName(l, p.nakshatra),
                  ),
                ),
            ],
          ),

          _Section(l.birthDetailsPanchangTitle, hue: AstroPalette.money),
          _Grid([
            if (p.vaara.isNotEmpty) (l.birthDetailsWeekday, _vaara(l, p.vaara)),
            if (p.tithi.isNotEmpty)
              (
                l.birthDetailsTithi,
                p.paksha.isEmpty
                    ? _sel(l.kBdTithi, p.tithi)
                    : '${_sel(l.kBdPaksha, p.paksha)} ${_sel(l.kBdTithi, p.tithi)}',
              ),
            if (p.nakshatra.isNotEmpty)
              (
                l.birthDetailsNakshatra,
                p.nakshatraPada > 0
                    ? '${KTerms.nakshatraName(l, p.nakshatra)} · '
                          '${l.birthDetailsPada(p.nakshatraPada)}'
                    : KTerms.nakshatraName(l, p.nakshatra),
              ),
            if (p.yoga.isNotEmpty)
              (l.birthDetailsYoga, _sel(l.kBdYoga, p.yoga)),
            if (p.karana.isNotEmpty)
              (l.birthDetailsKarana, _sel(l.kBdKarana, p.karana)),
            if (kundali.moonSign.isNotEmpty)
              (l.birthDetailsMoonSign, KTerms.signName(l, kundali.moonSign)),
            if (kundali.sunSign.isNotEmpty)
              (l.birthDetailsSunSign, KTerms.signName(l, kundali.sunSign)),
            if (kundali.sunNakshatra.isNotEmpty)
              (
                l.birthDetailsSuryaNakshatra,
                kundali.sunNakshatraPada > 0
                    ? '${KTerms.nakshatraName(l, kundali.sunNakshatra)} · '
                          '${l.birthDetailsPada(kundali.sunNakshatraPada)}'
                    : KTerms.nakshatraName(l, kundali.sunNakshatra),
              ),
            if (p.sunrise.isNotEmpty) (l.birthDetailsSunrise, _hhmm(p.sunrise)),
            if (p.sunset.isNotEmpty) (l.birthDetailsSunset, _hhmm(p.sunset)),
            if (p.hasIshta)
              (
                l.birthDetailsIshtaKala,
                l.birthDetailsGhatiPala(
                  p.ishtaGhati,
                  p.ishtaPala,
                  p.ishtaVipala,
                ),
              ),
          ]),

          if (!c.isEmpty) ...[
            _Section(l.birthDetailsChakraTitle, hue: AstroPalette.love),
            _Grid([
              if (c.nakshatraLord.isNotEmpty)
                (
                  l.birthDetailsNakshatraLord,
                  KTerms.planetName(l, c.nakshatraLord),
                ),
              if (c.rasiLord.isNotEmpty)
                (l.birthDetailsRashiLord, KTerms.planetName(l, c.rasiLord)),
              if (c.varna.isNotEmpty)
                (l.birthDetailsVarna, _sel(l.kBdVarna, c.varna)),
              if (c.vashya.isNotEmpty)
                (l.birthDetailsVashya, _sel(l.kBdVashya, c.vashya)),
              if (c.yoni.isNotEmpty)
                (l.birthDetailsYoni, _sel(l.kBdYoni, c.yoni)),
              if (c.gana.isNotEmpty)
                (l.birthDetailsGana, _sel(l.kBdGana, c.gana)),
              if (c.nadi.isNotEmpty)
                (l.birthDetailsNadi, _sel(l.kBdNadi, c.nadi)),
              if (c.tara.isNotEmpty)
                (l.birthDetailsTara, _sel(l.kBdTara, c.tara)),
              if (c.tattva.isNotEmpty)
                (l.birthDetailsTattva, _tattva(l, c.tattva)),
              if (c.yunja.isNotEmpty)
                (l.birthDetailsYunja, _sel(l.kBdYunja, c.yunja)),
              if (c.rasiPaya.isNotEmpty)
                (l.birthDetailsRashiPaya, _paya(l, c.rasiPaya)),
              if (c.nakshatraPaya.isNotEmpty)
                (l.birthDetailsNakshatraPaya, _paya(l, c.nakshatraPaya)),
            ]),
          ],

          KFootnote(l.birthDetailsDisclaimer),
        ],
      ),
    );
  }

  /// Runs a backend term through its ICU `select` message. Select keys can't
  /// contain spaces ("Ati Mitra" → `AtiMitra`); unknown terms echo [raw].
  static String _sel(String Function(String key, Object raw) msg, String raw) =>
      msg(raw.replaceAll(' ', ''), raw);

  static String _hhmm(String hhmmss) =>
      hhmmss.length >= 5 ? hhmmss.substring(0, 5) : hhmmss;

  static String _vaara(AppLocalizations l, String v) => KTerms.vaaraName(l, v);

  static String _tattva(AppLocalizations l, String t) => switch (t) {
    'Fire' => l.tattvaFire,
    'Earth' => l.tattvaEarth,
    'Air' => l.tattvaAir,
    'Water' => l.tattvaWater,
    _ => t,
  };

  static String _paya(AppLocalizations l, String p) => switch (p) {
    'Gold' => l.payaGold,
    'Silver' => l.payaSilver,
    'Copper' => l.payaCopper,
    'Iron' => l.payaIron,
    _ => p,
  };
}

class _Section extends StatelessWidget {
  const _Section(this.title, {required this.hue});
  final String title;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              gradient: hue.linear(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// A headline fact tile at the top of the sheet.
class _Highlight extends StatelessWidget {
  const _Highlight({
    required this.hue,
    required this.label,
    required this.value,
  });
  final AstroHue hue;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KHueCard(
      hue: hue,
      radius: 16,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: context.brand.inkMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Two-column label/value grid.
class _Grid extends StatelessWidget {
  const _Grid(this.rows);
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: brand.hairline),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                border: i == rows.length - 1
                    ? null
                    : Border(bottom: BorderSide(color: brand.hairline)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      rows[i].$1,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 6,
                    child: Text(
                      rows[i].$2,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
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
