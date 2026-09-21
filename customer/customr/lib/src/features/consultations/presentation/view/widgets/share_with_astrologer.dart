import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../data/consultation_repository.dart';
import '../../../data/models/consultation.dart';
import '../../../data/pending_share.dart';

/// Shares a birth profile or a match from outside the room.
///
/// * one live consultation → shares straight away;
/// * several → asks which one;
/// * none → parks the choice ([PendingShare]) and sends the customer to pick an
///   astrologer; the booking sheet attaches it to the new consultation.
Future<void> shareWithAstrologer(
  BuildContext context, {
  String? birthProfileId,
  String? matchId,
  required String label,
}) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  final repo = getIt<ConsultationRepository>();

  List<Consultation> live = const [];
  try {
    live = await repo.list(status: 'accepted,active');
  } catch (_) {
    // offline: fall through to the booking path
  }
  if (!context.mounted) return;

  if (live.isEmpty) {
    final pending = getIt<PendingShare>();
    if (matchId != null) {
      pending.setMatch(matchId, label: label);
    } else if (birthProfileId != null) {
      pending.setProfile(birthProfileId, label: label);
    }
    unawaited(router.push(Routes.astrologers));
    return;
  }

  final target = live.length == 1
      ? live.first
      : await showModalBottomSheet<Consultation>(
          context: context,
          showDragHandle: true,
          builder: (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l.sharePickConsultation,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                for (final c in live)
                  ListTile(
                    leading: const Icon(Icons.forum_rounded),
                    title: Text(c.astrologerName),
                    onTap: () => Navigator.pop(context, c),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
  if (target == null || !context.mounted) return;

  try {
    await repo.share(
      target.id,
      birthProfileId: birthProfileId,
      matchId: matchId,
    );
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(l.shareDone(target.astrologerName)),
          action: SnackBarAction(
            label: l.sessionReturn,
            onPressed: () =>
                unawaited(router.push(Routes.consultation(target.id))),
          ),
        ),
      );
  } catch (_) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(l.shareFailed),
        ),
      );
  }
}
