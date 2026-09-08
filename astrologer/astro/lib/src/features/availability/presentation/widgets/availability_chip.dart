import 'package:flutter/material.dart';

import '../../../../core/availability/availability_coordinator.dart';
import '../../../../core/di/service_locator.dart';

/// One-tap online/offline switch shown in the Home app bar.
class AvailabilityChip extends StatelessWidget {
  const AvailabilityChip({super.key});

  @override
  Widget build(BuildContext context) {
    final coord = getIt<AvailabilityCoordinator>();
    return AnimatedBuilder(
      animation: coord,
      builder: (context, _) {
        final on = coord.enabled;
        final (label, color) = switch (coord.presence) {
          'online' => ('Online', Colors.green),
          'busy' => ('Busy', Colors.orange),
          'away' => ('Away', Colors.blueGrey),
          _ => ('Offline', Theme.of(context).disabledColor),
        };
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ActionChip(
            avatar: CircleAvatar(
              radius: 5,
              backgroundColor: on ? color : Theme.of(context).disabledColor,
            ),
            label: Text(on ? label : 'Go online'),
            onPressed: () => coord.setEnabled(!on),
          ),
        );
      },
    );
  }
}
