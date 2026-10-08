import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import 'dash_shared.dart';
import 'tools.dart';

/// The twelve tools an astrologer reaches for most, with "See all" opening the
/// full, grouped list. Counts show only where something is waiting.
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  /// How many tiles Home keeps — three rows of four.
  static const featured = 12;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final groups = buildToolGroups(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: l.dashTools,
          hue: AstroPalette.money,
          onSeeAll: () => context.push(Routes.tools),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: DashGaps.sidePad,
          child: ToolGrid(
            actions: groups.first.actions.take(featured).toList(),
          ),
        ),
      ],
    );
  }
}
