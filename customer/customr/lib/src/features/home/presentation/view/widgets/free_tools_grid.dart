import 'package:customr/src/core/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../features/birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../../../../features/kundali/presentation/view/kundali_routes.dart';
import '../../../../../shared/widgets/pressable.dart';
import 'home_shared.dart';

/// Lead-magnet grid. Kundli tools open the active birth profile's kundali (or
/// the birth-profile flow when there isn't one); discipline tiles drop into
/// discovery filtered by that skill.
///
/// Each tool gets a unique gradient icon badge for a vibrant, premium look.
class FreeToolsGrid extends StatelessWidget {
  const FreeToolsGrid({super.key});

  /// Opens a tool for the user's default birth profile — the explicitly active
  /// one, else the primary / `self` profile ([BirthProfilesState.resolvedProfile]).
  /// Only when the user has no profile at all do we send them to the create flow.
  void _openKundali(
    BuildContext context, {
    bool insights = false,
    bool numerology = false,
  }) {
    final id = context.read<BirthProfilesCubit>().state.resolvedProfile?.id;
    if (id == null || id.isEmpty) {
      context.push(Routes.birthProfiles);
      return;
    }
    context.push(
      numerology
          ? KundaliRoutes.numerology(id)
          : insights
          ? KundaliRoutes.insights(id)
          : KundaliRoutes.overview(id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tools = <_Tool>[
      _Tool(
        'Free Kundli',
        Icons.grid_on_rounded,
        AstroPalette.money,
        () => _openKundali(context),
      ),
      _Tool(
        'Kundli Reading',
        Icons.auto_stories_outlined,
        AstroPalette.fire,
        () => _openKundali(context, insights: true),
      ),
      _Tool(
        'Kundli Matching',
        Icons.join_inner_rounded,
        AstroPalette.love,
        () => context.push(Routes.birthProfiles),
      ),
      _Tool(
        'Predictions',
        Icons.insights_rounded,
        AstroPalette.career,
        () => context.push('/predictions'),
      ),
      _Tool(
        'Ask a Question',
        Icons.help_outline_rounded,
        const AstroHue(Color(0xFFA78BFA), Color(0xFF6D28D9)),
        () => context.push('/prashna'),
      ),
      _Tool(
        'Numerology',
        Icons.pin_rounded,
        AstroPalette.water,
        () => _openKundali(context, numerology: true),
      ),
      _Tool(
        'Tarot',
        Icons.style_rounded,
        const AstroHue(Color(0xFFE879F9), Color(0xFF9333EA)),
        () => context.go(Routes.astrologersWith(skill: 'tarot-reading')),
      ),
      _Tool(
        'Vastu',
        Icons.home_work_rounded,
        AstroPalette.health,
        () => context.go(Routes.astrologersWith(skill: 'vastu')),
      ),
      _Tool(
        'Palmistry',
        Icons.back_hand_rounded,
        AstroPalette.earth,
        () => context.go(Routes.astrologersWith(skill: 'palmistry')),
      ),
    ];

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.homeFreeToolsTitle,
          hue: AstroPalette.air,
        ),
        const SizedBox(height: 14),
        Padding(
          padding: HomeGaps.sidePad,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
            padding: EdgeInsets.zero,
            children: [
              for (final t in tools)
                Pressable(
                  child: HueTile(
                    hue: t.hue,
                    radius: 22,
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
                    onTap: t.onTap,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HueIcon(
                          hue: t.hue,
                          icon: t.icon,
                          size: 42,
                          iconSize: 21,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.label,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tool {
  const _Tool(this.label, this.icon, this.hue, this.onTap);
  final String label;
  final IconData icon;
  final AstroHue hue;
  final VoidCallback onTap;
}
