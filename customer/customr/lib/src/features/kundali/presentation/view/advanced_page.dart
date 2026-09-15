import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../widgets/kundali_pdf_sheet.dart';
import '../widgets/kundali_ui.dart';
import 'kundali_routes.dart';

/// Hub for the technical reports (ashtakavarga, shadbala, KP, Jaimini) and the
/// PDF download.
class AdvancedPage extends StatelessWidget {
  const AdvancedPage({required this.profileId, super.key});
  final String profileId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final items = <(IconData, AstroHue, String, String, String)>[
      (
        Icons.grid_4x4_rounded,
        AstroPalette.career,
        l.kAdvAshtakavarga,
        l.kAdvAshtakavargaSub,
        'ashtakavarga',
      ),
      (
        Icons.bar_chart_rounded,
        AstroPalette.health,
        l.kAdvShadbala,
        l.kAdvShadbalaSub,
        'shadbala',
      ),
      (Icons.tune_rounded, AstroPalette.air, l.kAdvKp, l.kAdvKpSub, 'kp'),
      (
        Icons.hub_rounded,
        AstroPalette.love,
        l.kAdvJaimini,
        l.kAdvJaiminiSub,
        'jaimini',
      ),
    ];

    return KundaliScaffold(
      title: l.kAdvTitle,
      eyebrow: l.kOvTitle,
      headline: l.kAdvTitle,
      subheadline: l.kAdvHeroSub,
      hue: AstroPalette.air,
      heroTrailing: const KHeroGlyph(
        hue: AstroPalette.air,
        icon: Icons.science_rounded,
        size: 72,
      ),
      heroChips: [
        KHeroChip(icon: Icons.analytics_rounded, label: l.kAdvReportCount(4)),
        KHeroChip(icon: Icons.picture_as_pdf_rounded, label: l.kAdvPdfChip),
      ],
      children: [
        Text(
          l.kAdvIntro,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: context.brand.inkMuted,
            height: 1.45,
          ),
        ),
        KSection(
          title: l.kAdvReportsTitle,
          hue: AstroPalette.air,
          padTop: 16,
          child: Column(
            children: [
              for (final it in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: KNavRow(
                    icon: it.$1,
                    hue: it.$2,
                    title: it.$3,
                    subtitle: it.$4,
                    onTap: () => context.push(
                      KundaliRoutes.advancedReport(profileId, it.$5),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        KHueCard(
          hue: AstroPalette.money,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const HueIcon(
                    hue: AstroPalette.money,
                    icon: Icons.picture_as_pdf_rounded,
                    size: 44,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.kAdvDownloadPdf,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          l.kAdvFooter,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: context.brand.inkMuted,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  final profiles = context
                      .read<BirthProfilesCubit>()
                      .state
                      .profiles;
                  final name = profiles
                      .where((p) => p.id == profileId)
                      .map((p) => p.displayName)
                      .firstOrNull;
                  showKundaliPdfSheet(
                    context,
                    profileId: profileId,
                    name: name ?? l.kOvTitle,
                  );
                },
                icon: const Icon(Icons.download_rounded, size: 18),
                label: Text(l.kAdvDownloadPdf),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
        const KAskCta(),
      ],
    );
  }
}
