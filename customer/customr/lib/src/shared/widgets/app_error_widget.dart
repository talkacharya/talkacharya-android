import 'package:flutter/material.dart';

import '../../core/network/friendly_error.dart';

/// What replaces Flutter's red "exception thrown while building" box.
///
/// In development it keeps the exception text — that box is how a layout bug is
/// usually found. In production it is a calm, wordless-of-jargon panel: the
/// person sees that a piece of the screen didn't load, not our stack trace.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({required this.details, super.key});

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: theme.colorScheme.error,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            "This part didn't load. Please try again.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          if (showErrorDetails) ...[
            const SizedBox(height: 8),
            Text(
              details.exceptionAsString(),
              textAlign: TextAlign.center,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
