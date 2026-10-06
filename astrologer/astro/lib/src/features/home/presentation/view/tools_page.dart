import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import 'widgets/tools.dart';

/// Every tool, grouped by what it is for. Home shows the first eight; this is
/// where the rest live.
class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final groups = buildToolGroups(context);
    return SubPageScaffold(
      title: l.toolsTitle,
      children: [
        for (final g in groups) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 6, 4, 10),
            child: Text(
              g.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: context.brand.inkMuted,
              ),
            ),
          ),
          ToolGrid(actions: g.actions),
          const SizedBox(height: 18),
        ],
      ],
    );
  }
}
