import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../data/consultation_api.dart';
import '../../data/models/saved_reply.dart';

/// The astrologer's canned openers, as a scrolling strip above the composer.
///
/// Tapping one puts it in the field instead of sending it: the first line of a
/// reading is almost always "namaste <name>", and a one-tap send would make
/// the conversation read like a bot answering.
class QuickReplies extends StatefulWidget {
  const QuickReplies({required this.onPick, super.key});

  final void Function(String text) onPick;

  @override
  State<QuickReplies> createState() => _QuickRepliesState();
}

class _QuickRepliesState extends State<QuickReplies> {
  ConsultationApi get _api => getIt<ConsultationApi>();

  List<SavedReply> _replies = const [];
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await _api.savedReplies();
      if (mounted) setState(() => _replies = rows);
    } catch (_) {
      // The composer works without them; a failed load is not worth a banner.
    }
  }

  void _pick(SavedReply reply) {
    widget.onPick(reply.body);
    setState(() => _open = false);
    // Fire and forget: the ordering catches up on the next open, and a failed
    // bump must never cost the astrologer the reply they just inserted.
    _api.useSavedReply(reply.id).then((_) {}, onError: (_) {});
  }

  Future<void> _add() async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => const _NewReplyDialog(),
    );
    if (text == null || text.trim().isEmpty) return;
    try {
      final row = await _api.createSavedReply(text.trim());
      if (mounted) setState(() => _replies = [..._replies, row]);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(context.l10n.quickRepliesSaveFailed)),
          );
      }
    }
  }

  Future<void> _delete(SavedReply reply) async {
    setState(() => _replies = _replies.where((r) => r.id != reply.id).toList());
    try {
      await _api.deleteSavedReply(reply.id);
    } catch (_) {
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    if (_replies.isEmpty) return const SizedBox.shrink();

    if (!_open) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
          child: ActionChip(
            avatar: const Icon(Icons.bolt_rounded, size: 16),
            label: Text(l.quickReplies),
            visualDensity: VisualDensity.compact,
            onPressed: () => setState(() => _open = true),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const SizedBox(width: 6),
              Icon(Icons.bolt_rounded, size: 15, color: brand.inkMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  l.quickRepliesHint,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded, size: 18),
                tooltip: l.quickRepliesAdd,
                visualDensity: VisualDensity.compact,
                onPressed: _add,
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                tooltip: l.commonClose,
                visualDensity: VisualDensity.compact,
                onPressed: () => setState(() => _open = false),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 132),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              itemCount: _replies.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, i) {
                final reply = _replies[i];
                return InkWell(
                  onTap: () => _pick(reply),
                  onLongPress: () => _confirmDelete(reply),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      reply.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(SavedReply reply) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(reply.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.quickRepliesDelete),
          ),
        ],
      ),
    );
    if (ok == true) await _delete(reply);
  }
}

class _NewReplyDialog extends StatefulWidget {
  const _NewReplyDialog();

  @override
  State<_NewReplyDialog> createState() => _NewReplyDialogState();
}

class _NewReplyDialogState extends State<_NewReplyDialog> {
  final _field = TextEditingController();

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.quickRepliesAdd),
      content: TextField(
        controller: _field,
        autofocus: true,
        minLines: 2,
        maxLines: 5,
        maxLength: 1000,
        decoration: InputDecoration(hintText: l.quickRepliesNewHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _field.text),
          child: Text(l.commonSave),
        ),
      ],
    );
  }
}
