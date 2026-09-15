import 'package:flutter/material.dart';

import '../models/chat_enums.dart';

/// A thin strip shown above the message list while the realtime socket is not
/// healthy. Collapses to zero height when online.
class ConnectionBanner extends StatelessWidget {
  const ConnectionBanner({required this.status, super.key});
  final ConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (String text, Color bg, Color fg) = switch (status) {
      ConnectionStatus.online => ('', Colors.transparent, Colors.transparent),
      ConnectionStatus.connecting => (
        'Connecting…',
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
      ConnectionStatus.reconnecting => (
        'Reconnecting…',
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      ConnectionStatus.offline => (
        'No connection — messages will send when you\'re back online',
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
    };

    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      child: status == ConnectionStatus.online
          ? const SizedBox(width: double.infinity)
          : Container(
              width: double.infinity,
              color: bg,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (status != ConnectionStatus.offline) ...[
                    SizedBox(
                      width: 11,
                      height: 11,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.6,
                        color: fg,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: fg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
