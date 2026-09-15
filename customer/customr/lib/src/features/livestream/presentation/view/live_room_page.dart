import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Deep-link target for `talkacharya://livestreams/{id}`. Viewer UI + Agora
/// come later.
class LiveRoomPage extends StatelessWidget {
  const LiveRoomPage({required this.streamId, super.key});

  final String streamId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live session')),
      body: EmptyState(
        icon: Icons.live_tv_rounded,
        title: 'Live viewing coming soon',
        message: 'Stream $streamId — the watch experience is on the way.',
      ),
    );
  }
}
