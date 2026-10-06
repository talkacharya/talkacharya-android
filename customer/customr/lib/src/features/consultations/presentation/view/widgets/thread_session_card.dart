import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/network/friendly_error.dart';
import '../../../../../core/util/money.dart';
import '../../../../wallet/presentation/cubit/wallet_cubit.dart';
import '../../../../wallet/presentation/view/recharge_sheet.dart';
import '../../../data/consultation_api.dart';
import '../../../data/models/consultation.dart';
import '../../../data/models/conversation.dart';
import '../../cubit/chat_cubit.dart';
import 'billing_hud.dart';
import 'quick_top_up.dart';

/// What is happening in the room *now*, as the last thing in the thread.
///
/// It used to be four separate bars bolted around the conversation — a
/// waiting strip and a billing strip above it, a rating panel and a "start
/// consultation" bar below the composer. The customer asked for all of it to
/// read like the chat itself, so it is one card at the end of the messages,
/// scrolling with them:
///
/// * asked for, not yet answered — who is being asked and how long they have,
///   with a way to withdraw;
/// * live — how long, what it has cost, how much balance is left, and the
///   top-up amounts once that runs low;
/// * over — the rating, the free follow-up window, and starting again, which
///   asks straight away rather than sending the customer back to a profile.
///
/// The steps themselves (asked, joined, ended, declined) are system lines the
/// server posts into the thread, so the history reads correctly on its own.
class ThreadSessionCard extends StatefulWidget {
  const ThreadSessionCard({
    required this.consultation,
    required this.window,
    required this.lowBalance,
    this.awaitingPaymentUntil,
    super.key,
  });

  final Consultation consultation;
  final SendingWindow window;
  final bool lowBalance;
  final DateTime? awaitingPaymentUntil;

  @override
  State<ThreadSessionCard> createState() => _ThreadSessionCardState();
}

class _ThreadSessionCardState extends State<ThreadSessionCard> {
  /// The server gives an astrologer about a minute and a half to pick up, then
  /// expires the request. Counting it down beats an indefinite spinner.
  static const _acceptWindow = Duration(seconds: 90);

  int _rating = 0;
  bool _ratingBusy = false;
  bool _justRated = false;

  bool _starting = false;
  bool _cancelling = false;

  /// Why the last attempt to start again did not go through, said in the card
  /// rather than a snackbar that is gone before it is read.
  String? _problem;

  Consultation get c => widget.consultation;

  @override
  void initState() {
    super.initState();
    // Per-second timer removed: _WaitingBodyText and _LiveClock each own
    // their own private Timer so only the clock/countdown Text widget
    // rebuilds each second — not the entire session card.
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (c.status == ConsultationStatus.requested) return _waiting(context);
    if (c.status.canChat) return _live(context);
    if (c.status.isTerminal) return _wrapUp(context);
    return const SizedBox.shrink();
  }

  // --- asked for ---------------------------------------------------------------

  Widget _waiting(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return _Card(
      color: scheme.secondaryContainer,
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: scheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.roomWaitingTitle(c.astrologerName),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 2),
                // _WaitingBodyText owns its own 1-second timer — only this
                // one Text widget rebuilds each second, not the whole card.
                _WaitingBodyText(
                  requestedAt: c.requestedAt,
                  acceptWindow: _acceptWindow,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: scheme.onSecondaryContainer.withValues(alpha: .8),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            // Bounded: the app-wide button theme asks for an infinite width,
            // and a Row hands its non-flex children unbounded constraints.
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 40),
              foregroundColor: scheme.onSecondaryContainer,
            ),
            onPressed: _cancelling ? null : _cancel,
            child: Text(l10n.roomCancelRequest),
          ),
        ],
      ),
    );
  }

  Future<void> _cancel() async {
    setState(() => _cancelling = true);
    await context.read<ChatCubit>().cancelRequest();
    if (mounted) setState(() => _cancelling = false);
  }

  // --- live --------------------------------------------------------------------

  Widget _live(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final showTopUp =
        widget.lowBalance ||
        widget.awaitingPaymentUntil != null ||
        c.runwaySeconds <= 180;
    return _Card(
      color: scheme.surfaceContainerLow,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                const _LiveDot(),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.roomLiveNow(_sessionNoun(context, c.channel)),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                // _LiveClock owns its own 1-second timer — only the
                // clock Text widget rebuilds each second, not billing hud.
                _LiveClock(
                  startedAt: c.startedAt,
                  billedSeconds: c.billedSeconds,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: scheme.primary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          // Spent, minutes left, and the add-money action once it runs low —
          // the same strip the call screen shows, now inside the thread.
          BillingHud(
            consultation: c,
            lowBalance: widget.lowBalance,
            awaitingPaymentUntil: widget.awaitingPaymentUntil,
            onRecharge: () => showRechargeSheet(
              context,
              initialAmount: QuickTopUp.amountFor(
                double.tryParse(c.rateSnapshot) ?? 0,
                10,
              ),
            ),
          ),
          if (showTopUp) QuickTopUp(consultation: c),
        ],
      ),
    );
  }

  // --- over ----------------------------------------------------------------------

  Widget _wrapUp(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    if (widget.window.isBlocked) return _blocked(context);
    final ended = c.status == ConsultationStatus.ended;
    final ranOut = ended && c.endReason == 'balance_exhausted';
    final window = widget.window;
    // Starting again is the main thing to do once the thread has closed, or
    // when the balance is what ended it; during the free follow-up it is an
    // option next to simply writing.
    final primaryStart = window.isClosed || ranOut;

    return _Card(
      color: scheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (ranOut) ...[
            _Line(
              icon: Icons.account_balance_wallet_outlined,
              color: scheme.error,
              text: l10n.roomBalanceOutTitle,
              bold: true,
            ),
            const SizedBox(height: 10),
          ],
          if (ended && c.billedSeconds > 0) ...[
            _ratingRow(context),
            const SizedBox(height: 10),
          ],
          if (window.isFollowUp)
            _Line(
              icon: Icons.chat_bubble_outline_rounded,
              color: scheme.tertiary,
              text: _followUpLabel(context, window.followUpUntil),
            )
          else if (window.isClosed)
            _Line(
              icon: Icons.lock_clock_outlined,
              color: scheme.onSurfaceVariant,
              text: l10n.roomClosedHint,
            ),
          const SizedBox(height: 12),
          if (_starting)
            Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(l10n.roomStarting(c.astrologerName))),
              ],
            )
          else
            primaryStart
                ? FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                    ),
                    onPressed: _start,
                    icon: const Icon(Icons.forum_rounded, size: 18),
                    label: Text(l10n.roomStartConsultation),
                  )
                : OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                    ),
                    onPressed: _start,
                    icon: const Icon(Icons.forum_outlined, size: 18),
                    label: Text(l10n.roomStartConsultation),
                  ),
          const SizedBox(height: 6),
          Text(
            l10n.roomStartHint(
              c.astrologerName,
              l10n.roomRatePerMinute(
                c.currency,
                c.ratePerMinute.toStringAsFixed(0),
              ),
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (_problem != null) ...[
            const SizedBox(height: 8),
            Text(
              _problem!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Blocked, one way or the other. The one who blocked can undo it here;
  /// the one who was blocked is told only that messages are off.
  Widget _blocked(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final thread = context.select((ChatCubit c) => c.state.conversation);
    final mine = thread?.blockedByMe ?? false;
    return _Card(
      color: scheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Line(
            icon: Icons.block_rounded,
            color: scheme.onSurfaceVariant,
            text: mine
                ? l10n.chatBlockedByMe(c.astrologerName)
                : l10n.chatBlockedByThem,
          ),
          if (mine) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
              onPressed: () async {
                final error = await context
                    .read<ChatCubit>()
                    .setPreferences(blocked: false);
                if (error != null) _fail(error);
              },
              child: Text(l10n.chatUnblock(c.astrologerName)),
            ),
          ],
          if (_problem != null) ...[
            const SizedBox(height: 8),
            Text(
              _problem!,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.error, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  /// "How was it?" once, then "you rated it 4/5" every time after. A tap on a
  /// star is the rating — there is no second button to find.
  Widget _ratingRow(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final given = _justRated ? _rating : c.rating;
    const gold = Color(0xFFF2A93B);
    if (given != null) {
      return Row(
        children: [
          for (var i = 1; i <= 5; i++)
            Icon(
              i <= given ? Icons.star_rounded : Icons.star_border_rounded,
              size: 18,
              color: gold,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _justRated ? l10n.roomRatingThanks : l10n.roomYouRated(given),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.roomRateQuestion,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 1; i <= 5; i++)
              IconButton(
                tooltip: '$i',
                onPressed: _ratingBusy ? null : () => _rate(i),
                icon: Icon(
                  i <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 32,
                  color: gold,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _rate(int stars) async {
    setState(() {
      _rating = stars;
      _ratingBusy = true;
    });
    try {
      await context.read<ChatCubit>().submitReview(stars);
      if (mounted) setState(() => _justRated = true);
    } catch (_) {
      // The cubit surfaces the reason; the stars stay tappable to try again.
    } finally {
      if (mounted) setState(() => _ratingBusy = false);
    }
  }

  // --- starting again ----------------------------------------------------------

  /// Ask straight away. Short on balance → the top-up sheet, and the request
  /// goes out on its own once the money is in.
  Future<void> _start() async {
    setState(() {
      _starting = true;
      _problem = null;
    });
    try {
      final short = await _attempt();
      if (short != null && mounted) await _topUpThenRetry(short);
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  /// One try. Returns the shortfall when the wallet was short; any other
  /// refusal is written into the card.
  Future<InsufficientBalance?> _attempt() async {
    final l10n = context.l10n;
    final cubit = context.read<ChatCubit>();
    try {
      await cubit.startAgain();
      if (mounted) setState(() => _problem = null);
    } on InsufficientBalance catch (e) {
      return e;
    } on AstrologerBusy {
      _fail(l10n.roomStartBusy(c.astrologerName));
    } on AstrologerOffline catch (e) {
      _fail(e.message ?? l10n.roomStartOffline(c.astrologerName));
    } catch (e) {
      _fail(friendlyError(e));
    }
    return null;
  }

  Future<void> _topUpThenRetry(InsufficientBalance e) async {
    final l10n = context.l10n;
    final wallet = context.read<WalletCubit>();
    final locale = Localizations.localeOf(context).toLanguageTag();
    final perMinute = double.tryParse(e.required) ?? 0;
    final before = wallet.state.primaryFor(e.currency)?.available ?? 0;

    _fail(
      l10n.roomStartNeedMoney(
        Money.format(perMinute, e.currency, locale: locale),
      ),
    );
    await showRechargeSheet(
      context,
      initialAmount: QuickTopUp.amountFor(perMinute, 10),
    );
    if (!mounted) return;

    // Paid, as far as the wallet can tell — the credit can land a moment
    // after checkout closes, so give it a few tries. Otherwise one, in case
    // the wallet simply had not refreshed; if that is short too, the line
    // above still says what is needed.
    final after = wallet.state.primaryFor(e.currency)?.available ?? 0;
    final tries = after > before ? 4 : 1;
    for (var i = 0; i < tries; i++) {
      final still = await _attempt();
      if (still == null || !mounted) return;
      if (i < tries - 1) await Future<void>.delayed(const Duration(seconds: 2));
    }
  }

  void _fail(String why) {
    if (mounted) setState(() => _problem = why);
  }

  // --- helpers -----------------------------------------------------------------

  String _followUpLabel(BuildContext context, DateTime? until) {
    final l10n = context.l10n;
    final left = until?.difference(DateTime.now());
    if (left == null || left.isNegative) return l10n.roomFollowUpOpen;
    return left.inHours >= 1
        ? l10n.roomFollowUpHours(left.inHours)
        : l10n.roomFollowUpMinutes(left.inMinutes.clamp(1, 59));
  }

}

// --- clock helpers -----------------------------------------------------------

String _mmss(int seconds) =>
    '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

/// 75 → "01:15", 3725 → "1:02:05".
String _clock(int seconds) {
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  final s = seconds % 60;
  String two(int v) => v.toString().padLeft(2, '0');
  return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
}

// --- isolated ticking widgets ------------------------------------------------

/// Countdown body text for the waiting state. Owns its own [Timer.periodic]
/// so only this single Text widget rebuilds every second — not the whole
/// [ThreadSessionCard] tree (billing hud, rating stars, top-up buttons…).
class _WaitingBodyText extends StatefulWidget {
  const _WaitingBodyText({
    required this.requestedAt,
    required this.acceptWindow,
    required this.style,
  });

  final DateTime? requestedAt;
  final Duration acceptWindow;
  final TextStyle? style;

  @override
  State<_WaitingBodyText> createState() => _WaitingBodyTextState();
}

class _WaitingBodyTextState extends State<_WaitingBodyText> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final since = widget.requestedAt;
    if (since == null) return Text(l10n.roomWaitingBody, style: widget.style);
    final left = widget.acceptWindow - DateTime.now().difference(since);
    final clamped = left.isNegative ? Duration.zero : left;
    return Text(
      l10n.roomWaitingCountdown(_mmss(clamped.inSeconds)),
      style: widget.style,
    );
  }
}

/// Session elapsed clock (mm:ss or h:mm:ss). Owns its own [Timer.periodic]
/// so only this single Text widget rebuilds every second — not the whole
/// [ThreadSessionCard] tree.
class _LiveClock extends StatefulWidget {
  const _LiveClock({
    required this.startedAt,
    required this.billedSeconds,
    required this.style,
  });

  final DateTime? startedAt;
  final int billedSeconds;
  final TextStyle? style;

  @override
  State<_LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<_LiveClock> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final started = widget.startedAt;
    final secs = started == null
        ? widget.billedSeconds
        : math.max(0, DateTime.now().difference(started).inSeconds);
    return Text(_clock(secs), style: widget.style);
  }
}

String _sessionNoun(BuildContext context, String? channel) {
  final l10n = context.l10n;
  return switch (channel) {
    'voice' => l10n.sessionVoice,
    'video' => l10n.sessionVideo,
    _ => l10n.sessionChat,
  };
}

/// The customer's wording for the session lines the server posts into the
/// thread — localised, and with what a session cost on the line that ends it.
/// Null for anything else, which falls back to the chat package's text.
String? customerSystemLabel(
  BuildContext context,
  ChatMessage m, {
  required String astrologerName,
}) {
  final l10n = context.l10n;
  final session = _sessionNoun(context, m.meta['channel'] as String?);
  return switch (m.systemEvent) {
    'requested' => l10n.sysRequested(session),
    'accepted' => l10n.sysAccepted(astrologerName),
    'started' => l10n.sysStarted(astrologerName, session),
    'ended' => _endedLabel(context, m, session),
    'rejected' => l10n.sysRejected(astrologerName),
    'cancelled' => l10n.sysCancelled,
    'expired' => l10n.sysExpired(astrologerName),
    'no_show' => l10n.sysNoShow(session),
    'ending_soon' => l10n.sysEndingSoon,
    _ => null,
  };
}

String _endedLabel(BuildContext context, ChatMessage m, String session) {
  final l10n = context.l10n;
  final secs = (m.meta['billed_seconds'] as num?)?.toInt() ?? 0;
  if (secs <= 0) return l10n.sysEndedPlain(session);
  final amount = double.tryParse('${m.meta['gross_amount']}') ?? 0;
  final currency = m.meta['currency'] as String? ?? 'INR';
  return l10n.sysEnded(
    session,
    (secs / 60).ceil(),
    Money.format(
      amount,
      currency,
      locale: Localizations.localeOf(context).toLanguageTag(),
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    required this.color,
    this.padding = const EdgeInsets.fromLTRB(14, 12, 14, 12),
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(6, 10, 6, 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: .6)),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.icon,
    required this.color,
    required this.text,
    this.bold = false,
  });

  final IconData icon;
  final Color color;
  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: color,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}

/// A small pulsing dot: this is live, and being billed.
class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: Tween(begin: .35, end: 1.0).animate(_pulse),
    child: Container(
      width: 9,
      height: 9,
      decoration: const BoxDecoration(
        color: Color(0xFF2EAD5B),
        shape: BoxShape.circle,
      ),
    ),
  );
}
