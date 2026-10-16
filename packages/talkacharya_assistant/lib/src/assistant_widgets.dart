import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import 'assistant_controller.dart';
import 'assistant_models.dart';

/// The words the room shows, in the app's language.
class AssistantLabels {
  const AssistantLabels({
    required this.hint,
    required this.emptyTitle,
    required this.emptyBody,
    required this.waitForReply,
    required this.blocked,
    required this.disabled,
    required this.notSent,
    required this.retry,
    required this.discard,
    required this.today,
    required this.yesterday,
    required this.loadFailed,
    required this.tryAgain,
    this.intro,
  });

  final String hint;
  final String emptyTitle;
  final String emptyBody;
  final String waitForReply;
  final String blocked;
  final String disabled;
  final String notSent;
  final String retry;
  final String discard;
  final String today;
  final String yesterday;
  final String loadFailed;
  final String tryAgain;

  /// A line at the top of the thread saying what this chat is.
  final String? intro;
}

/// Messages and the composer, for a page that brings its own header.
class AssistantRoomView extends StatefulWidget {
  const AssistantRoomView({
    required this.controller,
    required this.labels,
    this.errorText,
    super.key,
  });

  final AssistantRoomController controller;
  final AssistantLabels labels;

  /// Turns a failed send into a sentence; the generic one otherwise.
  final String Function(Object error)? errorText;

  @override
  State<AssistantRoomView> createState() => _AssistantRoomViewState();
}

class _AssistantRoomViewState extends State<AssistantRoomView> {
  final _field = TextEditingController();
  final _scroll = ScrollController();

  AssistantRoomController get c => widget.controller;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      // The list is reversed: the far end is the top of the conversation.
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 200) {
        c.loadOlder();
      }
    });
    _field.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _field.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _field.text;
    if (text.trim().isEmpty) return;
    _field.clear();
    c.sendText(text);
    if (_scroll.hasClients) {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final l = widget.labels;
        if (c.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.loadError != null && c.thread == null) {
          return ErrorView(message: l.loadFailed, onRetry: c.reload);
        }
        return Column(
          children: [
            Expanded(child: _list(context)),
            _footer(context),
          ],
        );
      },
    );
  }

  Widget _list(BuildContext context) {
    final l = widget.labels;
    final items = c.messages;
    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.forum_rounded,
        hue: AstroPalette.career,
        title: l.emptyTitle,
        message: l.emptyBody,
      );
    }
    final locale = Localizations.localeOf(context).toLanguageTag();
    // Reversed, newest at the bottom; index 0 is the latest.
    final rows = <Widget>[];
    for (var i = items.length - 1; i >= 0; i--) {
      final m = items[i];
      final prev = i > 0 ? items[i - 1] : null;
      final next = i < items.length - 1 ? items[i + 1] : null;
      rows.add(
        _Bubble(
          message: m,
          mine: m.senderRole == c.myRole,
          continuesAbove:
              prev != null &&
              prev.senderRole == m.senderRole &&
              _sameDay(prev.createdAt, m.createdAt),
          continuesBelow:
              next != null &&
              next.senderRole == m.senderRole &&
              _sameDay(next.createdAt, m.createdAt),
          locale: locale,
          notSent: l.notSent,
          onFailedTap: () => _failedActions(context, m),
        ),
      );
      if (prev == null || !_sameDay(prev.createdAt, m.createdAt)) {
        rows.add(_DayChip(label: _dayLabel(m.createdAt, locale)));
      }
    }
    if (c.loadingOlder) {
      rows.add(
        const Padding(
          padding: EdgeInsets.all(12),
          child: Center(
            child: SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      );
    } else if (c.reachedStart && l.intro != null) {
      rows.add(_Intro(text: l.intro!));
    }
    return ListView(
      controller: _scroll,
      reverse: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      children: rows,
    );
  }

  Widget _footer(BuildContext context) {
    final l = widget.labels;
    final closed = switch (c.composer) {
      AssistantComposerState.open => null,
      AssistantComposerState.waitForReply => l.waitForReply,
      AssistantComposerState.blocked => l.blocked,
      AssistantComposerState.disabled => l.disabled,
    };
    if (closed != null) return _ClosedBar(text: closed);

    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;
    final canSend = _field.text.trim().isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: brand.hairline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _field,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: c.maxLength,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: l.hint,
                    counterText: '',
                    isDense: true,
                    filled: true,
                    fillColor: scheme.surfaceContainerHighest.withValues(
                      alpha: 0.6,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Pressable(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: canSend ? 1 : 0.45,
                  child: Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: Ink(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: BrandColors.goldGradient,
                        ),
                      ),
                      child: InkWell(
                        onTap: canSend ? _send : null,
                        child: const Icon(
                          Icons.send_rounded,
                          size: 20,
                          color: Color(0xFF3A1703),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _failedActions(BuildContext context, AssistantMessage m) async {
    final l = widget.labels;
    final why = c.sendError == null
        ? null
        : widget.errorText?.call(c.sendError!);
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (why != null && why.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    why,
                    style: Theme.of(sheet).textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                    ),
                  ),
                ),
              if (c.canSend)
                FilledButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l.retry),
                  onPressed: () => Navigator.of(sheet).pop('retry'),
                ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text(l.discard),
                onPressed: () => Navigator.of(sheet).pop('discard'),
              ),
            ],
          ),
        ),
      ),
    );
    if (action == 'retry') {
      await c.retry(m);
    } else if (action == 'discard') {
      c.discard(m);
    }
  }

  String _dayLabel(DateTime at, String locale) {
    final now = DateTime.now();
    if (_sameDay(at, now)) return widget.labels.today;
    if (_sameDay(at, now.subtract(const Duration(days: 1)))) {
      return widget.labels.yesterday;
    }
    return at.year == now.year
        ? DateFormat.MMMd(locale).format(at)
        : DateFormat.yMMMd(locale).format(at);
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.message,
    required this.mine,
    required this.continuesAbove,
    required this.continuesBelow,
    required this.locale,
    required this.notSent,
    required this.onFailedTap,
  });

  final AssistantMessage message;
  final bool mine;
  final bool continuesAbove;
  final bool continuesBelow;
  final String locale;
  final String notSent;
  final VoidCallback onFailedTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = mine ? scheme.primary : scheme.surfaceContainerHighest;
    final fg = mine ? scheme.onPrimary : scheme.onSurface;
    final m = message;
    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.78,
      ),
      margin: EdgeInsets.only(top: continuesAbove ? 2 : 8),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      decoration: BoxDecoration(
        color: m.failed ? bg.withValues(alpha: 0.55) : bg,
        borderRadius: BorderRadius.circular(14).copyWith(
          topRight: mine && continuesAbove ? const Radius.circular(4) : null,
          topLeft: !mine && continuesAbove ? const Radius.circular(4) : null,
          bottomRight: mine && !continuesBelow
              ? const Radius.circular(3)
              : null,
          bottomLeft: !mine && !continuesBelow
              ? const Radius.circular(3)
              : null,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectableText(
            m.body,
            style: TextStyle(color: fg, fontSize: 14.5, height: 1.32),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat.jm(locale).format(m.createdAt),
            style: TextStyle(color: fg.withValues(alpha: 0.6), fontSize: 11),
          ),
        ],
      ),
    );
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: mine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Opacity(opacity: m.pending ? 0.7 : 1, child: bubble),
          if (m.failed)
            GestureDetector(
              onTap: onFailedTap,
              child: Padding(
                padding: const EdgeInsets.only(top: 4, right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 14,
                      color: scheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      notSent,
                      style: TextStyle(
                        color: scheme.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: brand.tint,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: brand.onTint,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: brand.tint,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, size: 18, color: brand.onTint),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: brand.onTint,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClosedBar extends StatelessWidget {
  const _ClosedBar({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: brand.tint,
        border: Border(top: BorderSide(color: brand.hairline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              Icon(Icons.hourglass_top_rounded, size: 18, color: brand.onTint),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: brand.onTint,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One inbox row: avatar, name, the last line, and a dot when it waits on you.
class AssistantThreadTile extends StatelessWidget {
  const AssistantThreadTile({
    required this.thread,
    required this.onTap,
    required this.youPrefix,
    super.key,
  });

  final AssistantThread thread;
  final VoidCallback onTap;

  /// "You: " before a last line this person wrote.
  final String youPrefix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final t = thread;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final at = t.lastAt;
    final when = at == null
        ? ''
        : DateUtils.isSameDay(at, DateTime.now())
        ? DateFormat.jm(locale).format(at)
        : DateFormat.MMMd(locale).format(at);
    final fromMe = !t.awaitingYou && t.lastSenderRole.isNotEmpty;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            HueAvatar(
              name: t.otherName,
              url: t.otherAvatar,
              hue: AstroPalette.career,
              size: 48,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          t.otherName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: t.awaitingYou
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        when,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: t.awaitingYou ? brand.gold : brand.inkMuted,
                          fontWeight: t.awaitingYou ? FontWeight.w700 : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${fromMe ? youPrefix : ''}${t.lastBody}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: t.awaitingYou ? brand.ink : brand.inkMuted,
                          ),
                        ),
                      ),
                      if (t.awaitingYou) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: brand.gold,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
