import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_call/talkacharya_call.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';

/// The customer's chart button, over a live video call.
///
/// Tapping this minimizes the video call into an in-app picture-in-picture
/// window and navigates the astrologer to the full Kundali screen, allowing
/// them to use the complete chart interface while continuing the video call.
class CallChartPanel extends StatelessWidget {
  const CallChartPanel({
    required this.consultationId,
    required this.profileId,
    required this.profileName,
    super.key,
  });

  final String consultationId;
  final String profileId;
  final String profileName;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, right: 4),
        child: FilledButton.tonalIcon(
          onPressed: () {
            // Minimize the video call to in-app PiP.
            final hub = getIt<CallHub>();
            hub.minimize();

            // Navigate to the full chart screen.
            context.push(
              Routes.consultationKundali(
                consultationId,
                profile: profileId,
              ),
              extra: profileName,
            );
          },
          icon: const Icon(Icons.auto_awesome_rounded, size: 18),
          label: Text(l.detailKundali),
          style: FilledButton.styleFrom(
            visualDensity: VisualDensity.compact,
            backgroundColor: Colors.black.withValues(alpha: 0.45),
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
