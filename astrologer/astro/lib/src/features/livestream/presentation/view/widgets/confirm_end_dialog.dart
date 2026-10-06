import 'package:flutter/material.dart';
import '../../../../../core/l10n/l10n.dart';

Future<bool> confirmHostEnd(BuildContext context) async {
  final l = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.hostEndTitle),
      content: const Text(
        'Everyone watching will be disconnected and the stream closes.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l.hostStayLive),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.hostEndSession),
        ),
      ],
    ),
  );
  return ok ?? false;
}
