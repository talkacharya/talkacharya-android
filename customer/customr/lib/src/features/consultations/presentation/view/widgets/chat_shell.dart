import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

import '../../../../../core/config/config_repository.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../follows/presentation/widgets/follow_widgets.dart';
import '../../../../gifting/data/models/gift.dart';
import '../../../../gifting/presentation/view/gift_sheet.dart';
import '../../../../store/presentation/view/consults_pages.dart';
import '../../../data/consultation_repository.dart';
import '../../../data/models/consultation.dart';
import '../../../data/models/conversation.dart';
import '../../cubit/chat_cubit.dart';
import 'share_details_sheet.dart';
import 'thread_session_card.dart';

import 'chat_room_skeleton.dart';
/// The chat room, whatever state the session in it is in. The thread is the
/// whole surface: its own lines say what happened (asked, joined, ended,
/// declined), and [ThreadSessionCard] as its last row says what is happening
/// now — waiting, billing, the rating and starting again. The composer follows
/// the thread's sending window, not the session.
///
/// App bar layout: at most three things are visible so the astrologer's name
/// always has room — switch-to-call and End while a session is open (search
/// while it is finished), then the overflow menu, always last. Everything
/// else (search, share details, auto-translate, gift, summary, mute, block)
/// lives in that menu. The live timer sits under the name, not in the actions.

class ChatShell extends StatefulWidget {
  const ChatShell({
    required this.consultation,
    required this.lowBalance,
    super.key,
  });

  final Consultation consultation;
  final bool lowBalance;

  @override
  State<ChatShell> createState() => _ChatShellState();
}

class _ChatShellState extends State<ChatShell> {
  /// The in-thread search bar, opened from the app bar.
  bool _searching = false;

  void _toggleSearch() => setState(() => _searching = !_searching);

  /// Ends a live session, or withdraws a request that hasn't been accepted
  /// yet (nothing is billed then, but without this a waiting customer has no
  /// way out from the app bar).
  Future<void> _confirmEnd(
    BuildContext context, {
    required bool pending,
  }) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.roomEndConfirmTitle),
        content: Text(l10n.roomEndConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.roomKeepTalking),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.roomEnd),
          ),
        ],
      ),
    );
    if ((ok ?? false) && context.mounted) {
      final cubit = context.read<ChatCubit>();
      await (pending ? cubit.cancelRequest() : cubit.endConsultation());
    }
  }

  /// "Can we talk instead?" — the commonest thing that happens in a reading,
  /// and it used to mean ending the chat and finding the astrologer again.
  Future<void> _switchToCall(BuildContext context, Consultation c) async {
    final cubit = context.read<ChatCubit>();
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    final channel = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                l10n.roomSwitchBody(c.astrologerName),
                style: Theme.of(sheetContext).textTheme.bodyMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.call_rounded),
              title: Text(l10n.roomSwitchVoice),
              onTap: () => Navigator.pop(sheetContext, 'voice'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam_rounded),
              title: Text(l10n.roomSwitchVideo),
              onTap: () => Navigator.pop(sheetContext, 'video'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (channel == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.roomSwitchRinging(c.astrologerName)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    final id = await cubit.upgradeChannel(channel);
    if (id == null || !context.mounted) return;
    // Straight into the new session's room; the thread underneath is the same
    // one, so the conversation is still there behind the call.
    context.pushReplacement(Routes.consultation(id));
  }

  void _openGift(BuildContext context, Consultation c) {
    showGiftSheet(
      context,
      target: ConsultationGiftTarget(
        consultationId: c.id,
        astrologerName: c.astrologerName,
        currency: c.currency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.consultation;
    final ended = c.status == ConsultationStatus.ended;
    // Over, one way or another: nothing to end, switch or bill.
    final finished = c.status.isTerminal;
    // Asked for, not yet accepted. Nothing is being billed.
    final pending = c.status == ConsultationStatus.requested;
    final active = c.status == ConsultationStatus.active;
    // The thread decides whether the composer is live, not the session: it
    // stays open, unbilled, through the free follow-up window after one ends.
    final window = context.select((ChatCubit cubit) => cubit.state.window);
    final canChat = window.canSend;
    final awaitingPaymentUntil = context.select(
      (ChatCubit cubit) => cubit.state.awaitingPaymentUntil,
    );
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    final canGift = finished ? canThankFrom(c) : !pending;
    final canSwitchToCall = !finished && !pending && c.channel == 'chat';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: scheme.primaryContainer,
              foregroundImage:
                  (c.astrologerAvatar != null && c.astrologerAvatar!.isNotEmpty)
                  ? NetworkImage(c.astrologerAvatar!)
                  : null,
              child: (c.astrologerAvatar == null || c.astrologerAvatar!.isEmpty)
                  ? Text(
                      c.astrologerName.isEmpty
                          ? '★'
                          : c.astrologerName.characters.first.toUpperCase(),
                      style: TextStyle(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    c.astrologerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (finished)
                    Text(
                      l10n.roomEndedTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Flexible(child: ChatHeaderStatus()),
                        if (active) ...[
                          const SizedBox(width: 6),
                          // RepaintBoundary confines the 1-second repaint
                          // to just the badge layer; the rest of the AppBar
                          // chrome stays stable between ticks.
                          RepaintBoundary(
                            child: ChatElapsedBadge(
                              since: c.startedAt,
                              fallbackSeconds: c.billedSeconds,
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
        actions: [
          if (finished)
            IconButton(
              tooltip: l10n.roomSearch,
              icon: const Icon(Icons.search_rounded),
              onPressed: _toggleSearch,
            ),
          if (canSwitchToCall)
            IconButton(
              tooltip: l10n.roomSwitchToCall,
              icon: const Icon(Icons.phone_in_talk_rounded),
              onPressed: () => _switchToCall(context, c),
            ),
          if (!finished)
            TextButton(
              onPressed: () => _confirmEnd(context, pending: pending),
              child: Text(l10n.roomEnd),
            ),
          // Always the last action, in every state.
          RoomMenu(
            consultation: c,
            onSearch: _toggleSearch,
            onShareDetails: finished
                ? null
                : () => showShareDetailsSheet(context),
            onGift: canGift ? () => _openGift(context, c) : null,
            onSummary: ended ? () => showSummarySheet(context, c) : null,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(child: _TiledWallpaper()),
          Column(
            children: [
              if (_searching)
                ChatSearchBar(
                  hint: l10n.roomSearchHint,
                  emptyText: l10n.roomSearchEmpty,
                  onJumpTo: (seq) {
                    context.read<ChatController>().jumpTo(seq);
                    setState(() => _searching = false);
                  },
                ),
              Expanded(
                child: ChatView(
                  composerEnabled: canChat,
                  systemLabel: (m) => customerSystemLabel(
                    context,
                    m,
                    astrologerName: c.astrologerName,
                  ),
                  // The customer's own profile or match: its kundali, or the
                  // match report. Customer cannot open it.
                  onOpenShared: null,
                  // Waiting, live billing, the wrap-up and starting again — all of
                  // it the last thing in the conversation, not bars around it.
                  footer: ThreadSessionCard(
                    key: const ValueKey('thread-session-card'),
                    consultation: c,
                    window: window,
                    lowBalance: widget.lowBalance,
                    awaitingPaymentUntil: awaitingPaymentUntil,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TiledWallpaper extends StatelessWidget {
  const _TiledWallpaper();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = scheme.primary.withValues(alpha: 0.4);
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double tileSize = 300;
          final cols = (constraints.maxWidth / tileSize).ceil();
          final rows = (constraints.maxHeight / tileSize).ceil();
          return OverflowBox(
            maxWidth: cols * tileSize,
            maxHeight: rows * tileSize,
            alignment: Alignment.topLeft,
            child: Wrap(
              children: List.generate(
                cols * rows,
                (_) => SvgPicture.asset(
                  'assets/svg/chat_wallpaper.svg',
                  width: tileSize,
                  height: tileSize,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The app bar's overflow menu — search, share details, auto-translate, gift
/// and the receipt (each shown only when the caller passes its callback), then
/// mute and block for this thread. Block is offered only between sessions —
/// the server refuses it while one is open, so a paid minute is never cut off
/// by a settings toggle.
class RoomMenu extends StatelessWidget {
  const RoomMenu({
    required this.consultation,
    required this.onSearch,
    this.onShareDetails,
    this.onGift,
    this.onSummary,
    super.key,
  });

  final Consultation consultation;
  final VoidCallback onSearch;
  final VoidCallback? onShareDetails;
  final VoidCallback? onGift;
  final VoidCallback? onSummary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final thread = context.select((ChatCubit c) => c.state.conversation);
    final name = consultation.astrologerName;
    final open = !consultation.status.isTerminal;
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      tooltip: l10n.chatMoreOptions,
      onSelected: (v) => _act(context, v, thread, name),
      itemBuilder: (menuContext) {
        // Read when the menu opens, so the check mark is current.
        final autoTranslate = context
            .read<ChatController>()
            .state
            .autoTranslate;
        return [
          PopupMenuItem(
            value: 'search',
            child: MenuRow(Icons.search_rounded, l10n.roomSearch),
          ),
          if (onShareDetails != null)
            PopupMenuItem(
              value: 'share',
              child: MenuRow(
                Icons.auto_awesome_rounded,
                l10n.shareWithAstrologer,
              ),
            ),
          PopupMenuItem(
            value: 'translate',
            child: MenuRow(
              autoTranslate
                  ? Icons.translate_rounded
                  : Icons.translate_outlined,
              autoTranslate
                  ? l10n.roomAutoTranslateOn
                  : l10n.roomAutoTranslateOff,
              highlight: autoTranslate,
            ),
          ),
          if (onGift != null)
            PopupMenuItem(
              value: 'gift',
              child: MenuRow(Icons.card_giftcard_rounded, l10n.giftAction),
            ),
          if (onSummary != null)
            PopupMenuItem(
              value: 'summary',
              child: MenuRow(Icons.receipt_long_rounded, l10n.roomViewSummary),
            ),
          if (thread != null) ...[
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'mute',
              child: MenuRow(
                thread.muted
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined,
                thread.muted ? l10n.chatUnmute : l10n.chatMute,
              ),
            ),
            if (thread.blockedByMe)
              PopupMenuItem(
                value: 'unblock',
                child: MenuRow(Icons.lock_open_rounded, l10n.chatUnblock(name)),
              )
            else if (!open)
              PopupMenuItem(
                value: 'block',
                child: MenuRow(Icons.block_rounded, l10n.chatBlock(name)),
              ),
          ],
        ];
      },
    );
  }

  Future<void> _act(
    BuildContext context,
    String action,
    Conversation? thread,
    String name,
  ) async {
    switch (action) {
      case 'search':
        onSearch();
        return;
      case 'share':
        onShareDetails?.call();
        return;
      case 'gift':
        onGift?.call();
        return;
      case 'summary':
        onSummary?.call();
        return;
      case 'translate':
        final controller = context.read<ChatController>();
        await controller.setAutoTranslate(!controller.state.autoTranslate);
        return;
    }

    if (thread == null) return;
    if (!context.mounted) return;
    final cubit = context.read<ChatCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    String? error;
    switch (action) {
      case 'mute':
        error = await cubit.setPreferences(muted: !thread.muted);
      case 'unblock':
        error = await cubit.setPreferences(blocked: false);
      case 'block':
        final ok = await showDialog<bool>(
          context: context,
          builder: (d) => AlertDialog(
            title: Text(l10n.chatBlockConfirmTitle(name)),
            content: Text(l10n.chatBlockConfirmBody(name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(d, false),
                child: Text(l10n.commonCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(d, true),
                child: Text(l10n.chatBlockConfirmYes),
              ),
            ],
          ),
        );
        if (ok != true) return;
        error = await cubit.setPreferences(blocked: true);
    }
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }
}

/// Icon + label row used by [RoomMenu].
class MenuRow extends StatelessWidget {
  const MenuRow(this.icon, this.label, {this.highlight = false, super.key});

  final IconData icon;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: highlight ? scheme.primary : null),
        const SizedBox(width: 12),
        Flexible(child: Text(label)),
      ],
    );
  }
}

/// How long this chat has been live, ticking every second — the astrologer's
/// room already shows this; the customer's didn't. Compact, so it fits under
/// the name instead of competing with the action buttons.
class ChatElapsedBadge extends StatefulWidget {
  const ChatElapsedBadge({
    required this.since,
    required this.fallbackSeconds,
    super.key,
  });

  final DateTime? since;
  final int fallbackSeconds;

  @override
  State<ChatElapsedBadge> createState() => _ChatElapsedBadgeState();
}

class _ChatElapsedBadgeState extends State<ChatElapsedBadge> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final since = widget.since;
    final secs = since == null
        ? widget.fallbackSeconds
        : DateTime.now().difference(since).inSeconds.clamp(0, 1 << 30);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 12,
            color: scheme.onPrimaryContainer,
          ),
          const SizedBox(width: 3),
          Text(
            formatElapsed(secs),
            style: TextStyle(
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// 75 → "01:15", 3725 → "1:02:05".
String formatElapsed(int seconds) {
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  final s = seconds % 60;
  String two(int v) => v.toString().padLeft(2, '0');
  return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
}

/// Same 72h post-session window the gift prompt already respects — the
/// server is the real authority; this only hides a button that would bounce.
bool canThankFrom(Consultation c) =>
    c.status == ConsultationStatus.ended &&
    c.billedSeconds > 0 &&
    (c.endedAt == null ||
        DateTime.now().difference(c.endedAt!) < const Duration(hours: 72));

/// The receipt for a finished session — duration, amount, follow, transcript,
/// report — one tap away instead of standing between the customer and their
/// own conversation.
void showSummarySheet(BuildContext context, Consultation c) {
  final l10n = context.l10n;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      // Scrolls, so the receipt + store + follow cards + buttons can't
      // overflow on a small screen.
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SummaryRow(l10n.roomRowAstrologer, c.astrologerName),
                    SummaryRow(
                      l10n.roomRowDuration,
                      l10n.roomMinutes(c.billedMinutes),
                    ),
                    SummaryRow(
                      l10n.roomRowAmount,
                      '${c.currency} ${c.gross.toStringAsFixed(2)}',
                    ),
                    SummaryRow(
                      l10n.roomRowRate,
                      l10n.roomRatePerMinute(
                        c.currency,
                        c.ratePerMinute.toStringAsFixed(0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (getIt<ConfigRepository>().value.features.store) ...[
              const SizedBox(height: 12),
              StoreConsultSummaryCard(consultationId: c.id),
            ],
            if (c.billedSeconds > 0 && c.astrologerId.isNotEmpty) ...[
              const SizedBox(height: 12),
              FollowPromptCard(
                astrologerId: c.astrologerId,
                astrologerName: c.astrologerName,
              ),
            ],
            const SizedBox(height: 16),
            // What was actually said, in something they can keep. People pay
            // for advice and forget the specifics of it within a week.
            TranscriptButton(consultation: c),
            if (c.billedSeconds > 0)
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  context.push(Routes.reportIssue(c.id));
                },
                icon: const Icon(Icons.flag_outlined, size: 18),
                label: Text(l10n.roomReportProblem),
              ),
          ],
        ),
      ),
    ),
  );
}

class SummaryRow extends StatelessWidget {
  const SummaryRow(this.label, this.value, {super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

/// Saves or shares a transcript of the session.
class TranscriptButton extends StatefulWidget {
  const TranscriptButton({required this.consultation, super.key});

  final Consultation consultation;

  @override
  State<TranscriptButton> createState() => _TranscriptButtonState();
}

class _TranscriptButtonState extends State<TranscriptButton> {
  bool _busy = false;

  Future<void> _download() async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      final bytes = await getIt<ConsultationRepository>().transcript(
        widget.consultation.id,
        consultationId: widget.consultation.id,
      );
      // The server decides the format — plain text where it cannot build a
      // PDF — so sniff rather than assume.
      final isPdf =
          bytes.length > 4 &&
          bytes[0] == 0x25 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x44 &&
          bytes[3] == 0x46;
      final fileName = 'consultation.${isPdf ? 'pdf' : 'txt'}';
      await Share.shareXFiles(
        [
          XFile.fromData(
            Uint8List.fromList(bytes),
            mimeType: isPdf ? 'application/pdf' : 'text/plain',
            name: fileName,
          ),
        ],
        // `XFile.name` is ignored on several platforms; this is what
        // actually sets the shared file's name.
        fileNameOverrides: [fileName],
      );
    } catch (e, st) {
      debugPrint('Transcript share failed: $e\n$st');
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.commonSomethingWentWrong)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: _busy ? null : _download,
      icon: _busy
          ? const SizedBox(width: 16, height: 16, child: ChatRoomSkeleton())
          : const Icon(Icons.download_rounded, size: 18),
      label: Text(context.l10n.roomDownloadTranscript),
    );
  }
}
