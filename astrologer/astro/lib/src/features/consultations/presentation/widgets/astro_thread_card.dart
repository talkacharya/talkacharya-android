import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/util/money.dart';
import '../../../requests/presentation/cubit/requests_cubit.dart';
import '../../../requests/presentation/view/widgets/request_card.dart'
    show kAcceptTimeout;
import '../../data/models/consultation.dart';
import '../cubit/chat_cubit.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';
/// The astrologer's view of what is happening in the room *now*, as the last
/// thing in the thread — the same shape as the customer's, with the facts an
/// astrologer works from.
///
/// It replaces the bars that used to sit above the conversation (waiting,
/// the live earnings strip, the ended summary, the follow-up notice): the
/// customer's room moved all of that into the thread, and the two sides now
/// read the same way.
///
/// * asked for, not yet answered — who is waiting;
/// * live — how long, at what rate, how much of the customer's balance is
///   left, what has been earned, and a warning when they are running low or
///   topping up (the session is held then, not billed);
/// * over — what it earned and the rating, the follow-up window, or that the
///   thread has closed;
/// * blocked — which side did it, and the way back for the one who did.
class AstroThreadCard extends StatefulWidget {
  const AstroThreadCard({required this.consultation, super.key});

  final Consultation consultation;

  @override
  State<AstroThreadCard> createState() => _AstroThreadCardState();
}

class _AstroThreadCardState extends State<AstroThreadCard> {
  Timer? _tick;
  String? _problem;

  Consultation get c => widget.consultation;

  @override
  void initState() {
    super.initState();
    // The live clock and the accept countdown are the only things that move.
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && (c.isLive || c.isRequested)) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChatCubit>().state;
    if (state.window.isBlocked) return _blocked(context, state);
    if (c.isRequested) return _waiting(context);
    if (c.isLive) return _live(context, state);
    if (c.isTerminal) return _wrapUp(context, state);
    return const SizedBox.shrink();
  }

  /// The customer is asking, and the astrologer is already in their room: the
  /// request is answered here, not in a sheet over the conversation. Accept
  /// starts the session in place (a call turns the room into the call
  /// screen); Decline answers without waiting out the timer.
  Widget _waiting(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final since = c.requestedAt;
    final left = since == null
        ? null
        : math.max(
            0,
            kAcceptTimeout.inSeconds - DateTime.now().difference(since).inSeconds,
          );
    return _Card(
      color: brand.tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                c.isCall ? Icons.call_rounded : Icons.forum_rounded,
                size: 18,
                color: brand.onTint,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l.astroRequestInRoom(
                    c.customerName,
                    _session(context, c.channel),
                  ),
                  style: TextStyle(
                    color: brand.onTint,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (left != null)
                Text(
                  l.requestsExpiresIn(left),
                  style: TextStyle(
                    color: brand.onTint.withValues(alpha: .8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(
                // Bounded: a Row hands its non-flex children unbounded width,
                // and the app's button theme asks for all of it.
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  foregroundColor: brand.onTint,
                ),
                onPressed: _busy ? null : _decline,
                child: Text(l.requestsDecline),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                  onPressed: _busy ? null : _accept,
                  icon: _busy
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(c.isCall ? Icons.call_rounded : Icons.check_rounded),
                  label: Text(l.requestsAccept),
                ),
              ),
            ],
          ),
          if (_problem != null) ...[
            const SizedBox(height: 8),
            Text(
              _problem!,
              textAlign: TextAlign.center,
              style: TextStyle(color: brand.onTint, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  bool _busy = false;

  Future<void> _accept() async {
    setState(() {
      _busy = true;
      _problem = null;
    });
    final requests = getIt<RequestsCubit>();
    final ok = await context.read<ChatCubit>().acceptPending(requests.accept);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!ok) _problem = context.l10n.requestsActionFailed;
    });
  }

  Future<void> _decline() async {
    setState(() {
      _busy = true;
      _problem = null;
    });
    final requests = getIt<RequestsCubit>();
    final ok = await context.read<ChatCubit>().declinePending(
      (id) => requests.reject(id, 'declined'),
    );
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!ok) _problem = context.l10n.requestsActionFailed;
    });
  }

  Widget _live(BuildContext context, ChatState state) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;
    final rate = double.tryParse(c.rateSnapshot) ?? 0;
    final earned = double.tryParse(c.astrologerAmount) ?? 0;
    final runway = state.clientRunwaySeconds ?? c.runwaySeconds;
    final started = c.startedAt;
    final secs = started == null
        ? c.billedSeconds
        : math.max(0, DateTime.now().difference(started).inSeconds);

    return _Card(
      color: scheme.surfaceContainerLow,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Row(
              children: [
                const LiveDot(),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.roomLiveNow(_session(context, c.channel)),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  _clock(secs),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: scheme.primary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Row(
              children: [
                Text(
                  l.dashPerMin(Money.format(rate, c.currency)),
                  style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
                ),
                if (runway > 0 && !state.clientLowBalance) ...[
                  Text(
                    '  ·  ',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                  Text(
                    l.roomRunway((runway / 60).floor()),
                    style: TextStyle(
                      fontSize: 12.5,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  l.astroEarnedSoFar(Money.format(earned, c.currency)),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: brand.online,
                  ),
                ),
              ],
            ),
          ),
          // The hold beats the warning: by then the customer is past being
          // warned and is actually paying.
          if (state.customerToppingUp)
            _Strip(
              color: scheme.tertiaryContainer,
              foreground: scheme.onTertiaryContainer,
              icon: Icons.hourglass_top_rounded,
              text: l.roomCustomerToppingUp,
            )
          else if (state.clientLowBalance)
            _Strip(
              color: brand.live,
              foreground: Colors.white,
              icon: Icons.warning_amber_rounded,
              text: runway > 0
                  ? '${l.roomLowBalance} · ${l.roomRunway((runway / 60).ceil())}'
                  : l.roomLowBalance,
            ),
        ],
      ),
    );
  }

  Widget _wrapUp(BuildContext context, ChatState state) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final window = state.window;
    final earned = double.tryParse(c.astrologerAmount) ?? 0;
    return _Card(
      color: scheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (c.isEnded && c.billedSeconds > 0) ...[
            _Line(
              icon: Icons.payments_outlined,
              color: context.brand.online,
              text: l.astroEndedEarned(
                Money.format(earned, c.currency),
                c.billedMinutes,
              ),
              bold: true,
            ),
            const SizedBox(height: 8),
            _Line(
              icon: c.rating == null
                  ? Icons.star_border_rounded
                  : Icons.star_rounded,
              color: const Color(0xFFF2A93B),
              text: c.rating == null
                  ? l.astroNotRatedYet
                  : l.astroCustomerRated(c.customerName, c.rating!),
            ),
            const SizedBox(height: 8),
          ],
          if (window.isFollowUp)
            _Line(
              icon: Icons.chat_bubble_outline_rounded,
              color: scheme.tertiary,
              text: _followUp(context, window.followUpUntil),
            )
          else
            _Line(
              icon: Icons.lock_clock_outlined,
              color: scheme.onSurfaceVariant,
              text: l.astroThreadClosed(c.customerName),
            ),
        ],
      ),
    );
  }

  Widget _blocked(BuildContext context, ChatState state) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final mine = state.conversation?.blockedByMe ?? false;
    return _Card(
      color: scheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Line(
            icon: Icons.block_rounded,
            color: scheme.onSurfaceVariant,
            text: mine
                ? l.chatBlockedByMe(c.customerName)
                : l.chatBlockedByThem,
          ),
          if (mine) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
              onPressed: () async {
                final error = await context.read<ChatCubit>().setPreferences(
                  blocked: false,
                );
                if (mounted) setState(() => _problem = error);
              },
              child: Text(l.chatUnblock(c.customerName)),
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

  String _followUp(BuildContext context, DateTime? until) {
    final l = context.l10n;
    final left = until?.difference(DateTime.now());
    if (left == null || left.isNegative) return l.roomFollowUpOpen;
    return left.inHours >= 1
        ? l.roomFollowUpHours(left.inHours)
        : l.roomFollowUpMinutes(left.inMinutes.clamp(1, 59));
  }

  static String _clock(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    String two(int v) => v.toString().padLeft(2, '0');
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }
}

String _session(BuildContext context, String? channel) {
  final l = context.l10n;
  return switch (channel) {
    'voice' => l.sessionVoice,
    'video' => l.sessionVideo,
    _ => l.sessionChat,
  };
}

/// The astrologer's wording for the session lines in the thread — localised,
/// and from their side ("You declined the request"). The ended line gives the
/// length only: the amount on it is what the customer paid, not what the
/// astrologer earned, and the card above says that properly.
String? astroSystemLabel(
  BuildContext context,
  ChatMessage m, {
  required String customerName,
}) {
  final l = context.l10n;
  final session = _session(context, m.meta['channel'] as String?);
  return switch (m.systemEvent) {
    'requested' => l.sysRequested(session),
    'accepted' => l.sysAccepted,
    'started' => l.sysStarted(session),
    'ended' => _ended(l, m, session),
    'rejected' => l.sysRejected,
    'cancelled' => l.sysCancelled(customerName),
    'expired' => l.sysExpired,
    'no_show' => l.sysNoShow(session),
    'ending_soon' => l.sysEndingSoon(customerName),
    _ => null,
  };
}

String _ended(AppLocalizations l, ChatMessage m, String session) {
  final secs = (m.meta['billed_seconds'] as num?)?.toInt() ?? 0;
  if (secs <= 0) return l.sysEndedPlain(session);
  return l.sysEnded(session, (secs / 60).ceil());
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
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(6, 10, 6, 6),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: .6),
      ),
    ),
    child: Padding(padding: padding, child: child),
  );
}

class _Strip extends StatelessWidget {
  const _Strip({
    required this.color,
    required this.foreground,
    required this.icon,
    required this.text,
  });

  final Color color;
  final Color foreground;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    color: color,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    child: Row(
      children: [
        Icon(icon, size: 16, color: foreground),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: foreground,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
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
            color: bold ? Theme.of(context).colorScheme.onSurface : color,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}
