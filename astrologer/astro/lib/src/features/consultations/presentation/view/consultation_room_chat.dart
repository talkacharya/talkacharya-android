part of 'consultation_room_page.dart';

class _RoomView extends StatelessWidget {
  const _RoomView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final c = state.consultation;
        if (state.loading) {
          return const Scaffold(
            body: Center(child: ChatRoomSkeleton()),
          );
        }
        if (c == null) {
          return Scaffold(
            appBar: AppBar(),
            body: ErrorView(
              message: l.roomLoadError,
              onRetry: context.read<ChatCubit>().init,
            ),
          );
        }
        // An ended chat keeps its room: the conversation stays there to read,
        // composer off, with the wrap-up (earnings, duration, the customer's
        // rating if given) folded in above the messages instead of replacing
        // them. Every other terminal case (rejected/no answer, or a call)
        // never had a chat worth preserving, so it keeps the summary.
        // Every finished session — ended, declined, missed, a chat or a call —
        // keeps the room, as the customer's does: the thread says what
        // happened in its own lines and the card at its end has the wrap-up.
        // The receipt is the app-bar summary sheet.
        if (c.isTerminal) {
          final hub = getIt<CallHub>();
          if (hub.isFor(c.id)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (hub.isFor(c.id)) unawaited(hub.release());
            });
          }
          return _ChatRoom(consultation: c, state: state, ended: true);
        }
        // A call the customer is still asking for is answered from the chat
        // (Accept / Decline in the thread); the call screen takes over once
        // it has been accepted.
        if (c.isCall && !c.isRequested) {
          // When minimized, switch to the chat room so the astrologer can
          // use the app normally — the mini-bar lets them tap back into the
          // call. ListenableBuilder re-runs when hub.expanded changes.
          final hub = getIt<CallHub>();
          return ListenableBuilder(
            listenable: hub,
            builder: (context, _) {
              if (!hub.expanded && hub.isFor(c.id)) {
                return _ChatRoom(consultation: c, state: state);
              }
              return _AstroCallRoom(consultation: c, state: state);
            },
          );
        }
        return _ChatRoom(consultation: c, state: state);
      },
    );
  }
}

/// The chat room. Live, this is the ordinary session with the running
/// earnings strip. Once [ended], it's the same room with the composer
/// switched off: the conversation stays visible — the astrologer can always
/// read back what was discussed — with the wrap-up (earnings, duration, the
/// customer's rating if given) one tap away instead of replacing the thread.
class _ChatRoom extends StatefulWidget {
  const _ChatRoom({
    required this.consultation,
    required this.state,
    this.ended = false,
  });

  final Consultation consultation;
  final ChatState state;
  final bool ended;

  @override
  State<_ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<_ChatRoom> {
  /// The in-thread search bar, opened from the app bar.
  bool _searching = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.consultation;
    final state = widget.state;
    final ended = widget.ended;
    final l = context.l10n;
    final brand = context.brand;
    final ch = channelStyle(context, c.channel);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            HueAvatar(name: c.customerName, hue: ch.hue, size: 38),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    c.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (ended)
                    Text(
                      l.roomEndedTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    const ChatHeaderStatus(),
                ],
              ),
            ),
          ],
        ),
        actions: ended
            ? [
                _AstroRoomMenu(consultation: c),
                IconButton(
                  tooltip: l.roomViewSummary,
                  icon: const Icon(Icons.receipt_long_rounded),
                  onPressed: () => _showAstroSummarySheet(context, c),
                ),
              ]
            : [
                IconButton(
                  tooltip: l.roomSearch,
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () => setState(() => _searching = !_searching),
                ),
                const _AutoTranslateToggle(),
                if (c.sharedPeople.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.auto_awesome_rounded),
                    tooltip: l.detailKundali,
                    onPressed: () => context.push(
                      Routes.consultationKundali(
                        c.id,
                        profile: c.sharedPeople.first.id,
                      ),
                      extra: c.sharedPeople.first.name,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: brand.live,
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    onPressed: () => confirmEndConsultation(context),
                    child: Text(l.roomEnd),
                  ),
                ),
                _AstroRoomMenu(consultation: c),
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
                  hint: l.roomSearchHint,
                  emptyText: l.roomSearchEmpty,
                  onJumpTo: (seq) {
                    context.read<ChatController>().jumpTo(seq);
                    setState(() => _searching = false);
                  },
                ),
              if (!ended && c.question.isNotEmpty)
                _QuestionBanner(question: c.question),
              // Birth details are cards in the thread now (kundali_ref messages),
              // sitting where they were actually shared. The old panel above the
              // conversation said nothing about when that was, and pushed the
              // messages down the screen on every session that had one.
              Expanded(
                child: ChatView(
                  // Not the session's status: the thread stays open, unbilled,
                  // through the follow-up window after one ends.
                  composerEnabled: state.canSend,
                  composerHint: state.window.isFollowUp
                      ? l.roomFollowUpHint
                      : l.roomComposerHint,
                  aboveComposer: (context, insert) =>
                      QuickReplies(onPick: insert),
                  systemLabel: (m) => astroSystemLabel(
                    context,
                    m,
                    customerName: c.customerName,
                  ),
                  // Waiting, live earnings, the wrap-up — the last thing in the
                  // conversation rather than bars around it, as on the customer's
                  // side.
                  footer: AstroThreadCard(
                    key: const ValueKey('astro-thread-card'),
                    consultation: c,
                  ),
                  // A shared birth profile opens its kundali, a match its report —
                  // both scoped to the session it was shared in, which is what
                  // gives the astrologer access to it.
                  onOpenShared: (d) {
                    if (d.consultationId.isEmpty) return;
                    context.push(
                      d.isMatch
                          ? Routes.consultationMatch(d.consultationId, d.id)
                          : Routes.consultationKundali(
                              d.consultationId,
                              profile: d.id,
                            ),
                      extra: d.name.isEmpty ? null : d.name,
                    );
                  },
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

/// Mute and block for this thread. Block only between sessions — the server
/// refuses it while one is open, so no paid minute ends on a settings toggle.
class _AstroRoomMenu extends StatelessWidget {
  const _AstroRoomMenu({required this.consultation});

  final Consultation consultation;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final thread = context.select((ChatCubit c) => c.state.conversation);
    if (thread == null) return const SizedBox.shrink();
    final name = consultation.customerName;
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      tooltip: l.chatMoreOptions,
      onSelected: (v) => switch (v) {
        'remedy' => context.push(
          Routes.suggestRemedy(consultation: consultation.id, name: name),
        ),
        'favourite' => _favourite(context, thread.id, name),
        _ => _act(context, v, thread.muted, name),
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 'remedy', child: Text(l.remediesSuggest)),
        PopupMenuItem(value: 'favourite', child: Text(l.wsAddFavourite)),
        PopupMenuItem(
          value: 'mute',
          child: Text(thread.muted ? l.chatUnmute : l.chatMute),
        ),
        if (thread.blockedByMe)
          PopupMenuItem(value: 'unblock', child: Text(l.chatUnblock(name)))
        else if (consultation.isTerminal)
          PopupMenuItem(value: 'block', child: Text(l.chatBlock(name))),
      ],
    );
  }

  /// Marking twice is harmless, so the menu does not need to know whether
  /// they already are one; unmarking is done from the Favourites list.
  Future<void> _favourite(
    BuildContext context,
    String threadId,
    String name,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    String message;
    try {
      await getIt<WorkspaceApi>().setFavourite(threadId);
      message = l.wsFavouriteAdded(name);
    } catch (e) {
      message = friendlyError(e);
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _act(
    BuildContext context,
    String action,
    bool muted,
    String name,
  ) async {
    final cubit = context.read<ChatCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    String? error;
    switch (action) {
      case 'mute':
        error = await cubit.setPreferences(muted: !muted);
      case 'unblock':
        error = await cubit.setPreferences(blocked: false);
      case 'block':
        final ok = await showDialog<bool>(
          context: context,
          builder: (d) => AlertDialog(
            title: Text(l.chatBlockConfirmTitle(name)),
            content: Text(l.chatBlockConfirmBody(name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(d, false),
                child: Text(l.commonCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(d, true),
                child: Text(l.chatBlockConfirmYes),
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

/// The rest of what `_Summary` shows for an ended session, one tap away
/// instead of standing between the astrologer and the conversation itself.
void _showAstroSummarySheet(BuildContext context, Consultation c) {
  final l = context.l10n;
  final rate = double.tryParse(c.rateSnapshot) ?? 0;
  final earned = double.tryParse(c.astrologerAmount) ?? 0;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
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
                    Text(l.detailYouEarned),
                    Text(
                      Money.format(earned, c.currency),
                      style: Theme.of(sheetContext).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _Stat(
                          label: l.detailDuration,
                          value: l.requestsMinutes(c.billedMinutes),
                        ),
                        _Stat(
                          label: l.detailRate,
                          value: l.dashPerMin(Money.format(rate, c.currency)),
                        ),
                        if (c.rating != null)
                          _Stat(label: l.detailRating, value: '${c.rating} ★'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (c.sharedPeople.isNotEmpty) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  context.push(
                    Routes.consultationKundali(
                      c.id,
                      profile: c.sharedPeople.firstOrNull?.id,
                    ),
                    extra: c.customerName,
                  );
                },
                icon: const Icon(Icons.auto_awesome_rounded),
                label: Text(l.detailKundali),
              ),
            ],
            const SizedBox(height: 12),
            // What was actually advised, in something that survives the app.
            _TranscriptButton(consultation: c),
            const SizedBox(height: 4),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(sheetContext);
                context.go(Routes.requests);
              },
              icon: const Icon(Icons.inbox_rounded),
              label: Text(l.roomBackToRequests),
            ),
          ],
        ),
      ),
    ),
  );
}

class _AutoTranslateToggle extends StatelessWidget {
  const _AutoTranslateToggle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatController, ChatSessionState>(
      buildWhen: (a, b) => a.autoTranslate != b.autoTranslate,
      builder: (context, state) => IconButton(
        tooltip: context.l10n.roomTranslate,
        isSelected: state.autoTranslate,
        icon: const Icon(Icons.translate_outlined),
        selectedIcon: Icon(
          Icons.translate_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () => context.read<ChatController>().setAutoTranslate(
          !state.autoTranslate,
        ),
      ),
    );
  }
}

