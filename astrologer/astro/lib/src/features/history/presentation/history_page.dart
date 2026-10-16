import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/network/friendly_error.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/util/money.dart';
import '../../../core/util/time_format.dart';
import '../../../shared/widgets/settings_widgets.dart';
import '../../assistant/data/assistant_api.dart';
import '../../performance/presentation/widgets/perf_format.dart';
import '../../workspace/data/workspace_api.dart';
import '../data/history_api.dart';

/// What the list shows.
enum HistoryFilter { all, chat, voice, video, favourites }

/// Every finished session, newest first, as a card with the customer's
/// details and the ways to follow up: their kundali, a remedy, the free
/// assistant chat, a private note.
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _api = getIt<HistoryApi>();
  final _items = <HistoryEntry>[];
  String? _next;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  String _query = '';
  HistoryFilter _filter = HistoryFilter.all;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  String? get _channel => switch (_filter) {
    HistoryFilter.chat => 'chat',
    HistoryFilter.voice => 'voice',
    HistoryFilter.video => 'video',
    _ => null,
  };

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await _api.page(
        query: _query,
        channel: _channel,
        favourites: _filter == HistoryFilter.favourites,
      );
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(page.items);
        _next = page.next;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyError(e);
          _loading = false;
        });
      }
    }
  }

  Future<void> _more() async {
    final cursor = _next;
    if (cursor == null || _loadingMore) return;
    setState(() => _loadingMore = true);
    try {
      final page = await _api.page(
        cursor: cursor,
        query: _query,
        channel: _channel,
        favourites: _filter == HistoryFilter.favourites,
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(page.items);
        _next = page.next;
      });
    } catch (_) {
      // The button stays; tapping again retries.
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  void _search(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (text.trim() == _query) return;
      _query = text.trim();
      _load();
    });
  }

  void _replace(HistoryEntry updated) {
    setState(() {
      for (var i = 0; i < _items.length; i++) {
        // A favourite / note belongs to the customer, so every card of theirs.
        if (_items[i].conversationId != null &&
            _items[i].conversationId == updated.conversationId) {
          _items[i] = _items[i].copyWith(
            favourite: updated.favourite,
            note: updated.note,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final body = <Widget>[
      TextField(
        onChanged: _search,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: l.histSearch,
          prefixIcon: const Icon(Icons.search_rounded),
          isDense: true,
        ),
      ),
      const SizedBox(height: 10),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final f in HistoryFilter.values) ...[
              ChoiceChip(
                avatar: f == HistoryFilter.favourites
                    ? Icon(
                        Icons.favorite_rounded,
                        size: 16,
                        color: AstroPalette.love.end,
                      )
                    : null,
                label: Text(switch (f) {
                  HistoryFilter.all => l.histFilterAll,
                  HistoryFilter.chat => l.channelChat,
                  HistoryFilter.voice => l.channelCall,
                  HistoryFilter.video => l.channelVideo,
                  HistoryFilter.favourites => l.histFilterFavourites,
                }),
                selected: f == _filter,
                onSelected: (_) {
                  setState(() => _filter = f);
                  _load();
                },
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
      const SizedBox(height: 12),
    ];

    if (_loading && _items.isEmpty) {
      body.add(
        const Padding(
          padding: EdgeInsets.only(top: 48),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    } else if (_error != null && _items.isEmpty) {
      body.add(
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: ErrorView(message: _error!, onRetry: _load),
        ),
      );
    } else if (_items.isEmpty) {
      body.add(
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: EmptyState(
            icon: Icons.history_rounded,
            hue: AstroPalette.air,
            title: _query.isEmpty && _filter == HistoryFilter.all
                ? l.histEmptyTitle
                : l.histEmptyFilter,
            message: _query.isEmpty && _filter == HistoryFilter.all
                ? l.histEmptyBody
                : null,
          ),
        ),
      );
    } else {
      for (final e in _items) {
        body
          ..add(_HistoryCard(entry: e, onChanged: _replace))
          ..add(const SizedBox(height: 12));
      }
      if (_next != null) {
        body.add(
          Center(
            child: OutlinedButton(
              onPressed: _loadingMore ? null : _more,
              style: OutlinedButton.styleFrom(minimumSize: const Size(160, 44)),
              child: Text(_loadingMore ? l.histLoading : l.histLoadMore),
            ),
          ),
        );
      }
    }

    return SubPageScaffold(
      title: l.histTitle,
      subtitle: l.histSubtitle,
      onRefresh: _load,
      actions: [
        IconButton(
          tooltip: l.histPerformance,
          icon: Icon(Icons.speed_rounded, color: brand.ink),
          onPressed: () => context.push(Routes.performance),
        ),
      ],
      children: body,
    );
  }
}

// --- one session ----------------------------------------------------------------------

class _HistoryCard extends StatefulWidget {
  const _HistoryCard({required this.entry, required this.onChanged});

  final HistoryEntry entry;
  final ValueChanged<HistoryEntry> onChanged;

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  bool _openingChat = false;

  HistoryEntry get e => widget.entry;

  Future<void> _toggleFavourite() async {
    final id = e.conversationId;
    if (id == null) return;
    final ws = getIt<WorkspaceApi>();
    try {
      if (e.favourite) {
        await ws.removeFavourite(id);
        widget.onChanged(e.copyWith(favourite: false, note: ''));
      } else {
        await ws.setFavourite(id, note: e.note);
        widget.onChanged(e.copyWith(favourite: true));
      }
    } catch (err) {
      _toast(friendlyError(err));
    }
  }

  Future<void> _editNote() async {
    final id = e.conversationId;
    if (id == null) return;
    final l = context.l10n;
    final controller = TextEditingController(text: e.note);
    final note = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.histNoteTitle),
        content: TextField(
          controller: controller,
          maxLength: 240,
          maxLines: 3,
          autofocus: true,
          decoration: InputDecoration(hintText: l.histNoteHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.histCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(88, 40)),
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l.histSave),
          ),
        ],
      ),
    );
    if (note == null) return;
    try {
      // A note keeps the customer among the favourites, where it is listed.
      await getIt<WorkspaceApi>().setFavourite(id, note: note);
      widget.onChanged(e.copyWith(favourite: true, note: note.trim()));
    } catch (err) {
      _toast(friendlyError(err));
    }
  }

  Future<void> _openAssistant() async {
    if (_openingChat) return;
    final existing = e.assistantThreadId;
    if (existing != null) {
      await context.push(Routes.assistantRoom(existing));
      return;
    }
    setState(() => _openingChat = true);
    try {
      final detail = await getIt<AssistantApi>().openForConsultation(e.id);
      if (mounted) await context.push(Routes.assistantRoom(detail.thread.id));
    } catch (err) {
      _toast(friendlyError(err));
    } finally {
      if (mounted) setState(() => _openingChat = false);
    }
  }

  void _toast(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final at = (e.startedAt ?? e.requestedAt)?.toLocal();
    final channelHue = switch (e.channel) {
      'voice' => AstroPalette.health,
      'video' => AstroPalette.love,
      _ => AstroPalette.career,
    };
    final first = e.sessionNumber == 1;
    final birth = e.birth;

    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        side: BorderSide(color: brand.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Pill(
                  label: first
                      ? l.histFirstSession
                      : e.sessionNumber != null
                      ? l.histSessionNumber(e.sessionNumber!)
                      : l.histRepeatClient,
                  hue: first ? AstroPalette.health : AstroPalette.air,
                  icon: first
                      ? Icons.waving_hand_rounded
                      : Icons.replay_rounded,
                ),
                const Spacer(),
                if (e.conversationId != null) ...[
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: l.histNoteTitle,
                    icon: Icon(Icons.edit_note_rounded, color: brand.inkMuted),
                    onPressed: _editNote,
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: l.histFavourite,
                    icon: Icon(
                      e.favourite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: e.favourite
                          ? AstroPalette.love.end
                          : brand.inkMuted,
                    ),
                    onPressed: _toggleFavourite,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '#${e.shortId}  ',
                      style: TextStyle(color: brand.inkMuted),
                    ),
                    TextSpan(
                      text: e.customerName.isEmpty
                          ? l.histCustomer
                          : e.customerName,
                    ),
                  ],
                ),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text.rich(
              TextSpan(
                children: [
                  if (at != null)
                    TextSpan(
                      text:
                          '${TimeFormat.day(l, at)}, ${TimeFormat.clock(l, at)}  ·  ',
                    ),
                  TextSpan(
                    text: switch (e.channel) {
                      'voice' => l.channelCall,
                      'video' => l.channelVideo,
                      _ => l.channelChat,
                    }.toUpperCase(),
                    style: TextStyle(
                      color: channelHue.end,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                children: [
                  if (birth != null) ...[
                    if (birth.date != null)
                      _InfoRow(
                        label: l.histBirthDate,
                        value: [
                          birth.date!,
                          if (birth.time != null) _hm(birth.time!),
                        ].join(', '),
                      ),
                    if (birth.place.isNotEmpty)
                      _InfoRow(label: l.histBirthPlace, value: birth.place),
                    if (birth.gender.isNotEmpty)
                      _InfoRow(
                        label: l.histGender,
                        value: _gender(l, birth.gender),
                      ),
                  ],
                  _InfoRow(
                    label: l.histDuration,
                    value: e.billedSeconds > 0
                        ? formatDuration(l, e.billedSeconds)
                        : '—',
                  ),
                  _InfoRow(
                    label: l.histEarned,
                    value: Money.format(e.earned, e.currency),
                    trailing: _StatusPill(status: e.status),
                  ),
                  if (e.rating != null)
                    _InfoRow(
                      label: l.histRating,
                      valueWidget: Row(
                        children: [
                          for (var i = 1; i <= 5; i++)
                            Icon(
                              i <= e.rating!
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 16,
                              color: brand.gold,
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (e.review.isNotEmpty) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '“${e.review}”',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            if (e.note.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: brand.gold.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.sticky_note_2_rounded,
                      size: 16,
                      color: brand.gold,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(e.note, style: theme.textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            ],
            if (e.tags.where(_tagShown).isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final t in e.tags.where(_tagShown)) _TagChip(tag: t),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (birth != null && e.isEnded)
                  _Action(
                    icon: Icons.blur_circular_rounded,
                    label: l.histOpenKundali,
                    onTap: () => context.push(
                      Routes.consultationKundali(
                        e.id,
                        profile: birth.id.isEmpty ? null : birth.id,
                      ),
                    ),
                  ),
                if (e.isEnded)
                  _Action(
                    icon: Icons.spa_rounded,
                    label: l.histSendRemedy,
                    onTap: () => context.push(
                      Routes.suggestRemedy(
                        consultation: e.id,
                        name: e.customerName,
                      ),
                    ),
                  ),
                if (e.canMessage)
                  _Action(
                    icon: Icons.support_agent_rounded,
                    label: l.histChatAssistant,
                    busy: _openingChat,
                    onTap: _openAssistant,
                  ),
                if (e.conversationId != null)
                  _Action(
                    icon: Icons.forum_rounded,
                    label: l.histOpenChat,
                    onTap: () =>
                        context.push(Routes.chatRoom(e.conversationId!)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// "22:45:00" → "22:45".
String _hm(String t) => t.length >= 5 ? t.substring(0, 5) : t;

String _gender(AppLocalizations l, String g) => switch (g.toLowerCase()) {
  'male' || 'm' => l.histGenderMale,
  'female' || 'f' => l.histGenderFemale,
  _ => g,
};

/// The first-session / repeat tags are already the badge at the top.
bool _tagShown(String t) => t != 'first_session' && t != 'repeat_client';

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    this.value,
    this.valueWidget,
    this.trailing,
  });

  final String label;
  final String? value;
  final Widget? valueWidget;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
            ),
          ),
          Expanded(
            child:
                valueWidget ??
                Text(
                  value ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.hue, required this.icon});

  final String label;
  final AstroHue hue;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
      decoration: BoxDecoration(
        color: hue.tint(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: hue.end),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: hue.end,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, good) = switch (status) {
      'ended' => (l.histStatusCompleted, true),
      'cancelled' => (l.histStatusCancelled, false),
      'expired' => (l.histStatusMissed, false),
      'rejected' => (l.histStatusDeclined, false),
      'no_show' => (l.histStatusNoShow, false),
      _ => (l.histStatusFailed, false),
    };
    final color = good ? AstroPalette.health.end : AstroPalette.fire.end;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag});
  final String tag;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, good) = switch (tag) {
      'picked_fast' => (l.histTagPickedFast, true),
      'picked_late' => (l.histTagPickedLate, false),
      'short_session' => (l.histTagShort, false),
      'ended_by_customer' => (l.histTagEndedCustomer, null),
      'ended_by_you' => (l.histTagEndedYou, null),
      'ended_low_balance' => (l.histTagEndedBalance, false),
      'ended_disconnect' => (l.histTagEndedDisconnect, false),
      'remedy_suggested' => (l.histTagRemedy, true),
      _ => (tag, null),
    };
    final color = switch (good) {
      true => AstroPalette.health.end,
      false => AstroPalette.fire.end,
      null => context.brand.inkMuted,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    this.busy = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: busy ? null : onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 38),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: busy
          ? const SizedBox.square(
              dimension: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon, size: 16),
      label: Text(label),
    );
  }
}
