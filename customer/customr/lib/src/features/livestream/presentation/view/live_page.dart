import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Live tab — browse ongoing streams (`GET /app/livestreams`). Wired shell only.
class LivePage extends StatelessWidget {
  const LivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Live',
      child: EmptyState(
        icon: Icons.live_tv_rounded,
        title: 'No live sessions right now',
        message: 'Astrologers going live will show up here to watch and join.',
      ),
    );
  }
}
