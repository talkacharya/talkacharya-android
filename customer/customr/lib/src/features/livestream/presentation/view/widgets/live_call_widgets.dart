import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/util/money.dart';
import '../../../../consultations/data/consultation_repository.dart';

/// Voice calls during a live stream, viewer side: the sheet that asks for one,
/// the bar for the caller's own place / call, the banner everyone sees while a
/// call is on air, and the rating once it is over. See `LiveViewerCubit`.

String _price(BuildContext context, String? rate, String currency) {
  final l = context.l10n;
  final amount = double.tryParse(rate ?? '');
  if (amount == null) return l.liveCallNotOffered;
  final locale = Localizations.localeOf(context).toLanguageTag();
  return l.liveCallPerMinute(Money.format(amount, currency, locale: locale));
}

/// Public or private — both prices side by side. Returns the mode picked.
Future<LiveCallMode?> showLiveCallSheet(
  BuildContext context, {
  required LiveCallQuote quote,
  required String hostName,
}) {
  return showModalBottomSheet<LiveCallMode>(
    context: context,
    showDragHandle: true,
    backgroundColor: const Color(0xFF1B0F3B),
    builder: (sheetContext) {
      final l = sheetContext.l10n;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.liveCallSheetTitle(hostName),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l.liveCallSheetBody,
                style: const TextStyle(color: Colors.white70, height: 1.35),
              ),
              const SizedBox(height: 16),
              _ModeTile(
                icon: Icons.campaign_rounded,
                title: l.liveCallPublic,
                hint: l.liveCallPublicHint,
                price: _price(sheetContext, quote.public, quote.currency),
                colors: const [Color(0xFF7C5CFF), Color(0xFF4F8BFF)],
                onTap: quote.public == null
                    ? null
                    : () => Navigator.pop(sheetContext, LiveCallMode.public),
              ),
              const SizedBox(height: 10),
              _ModeTile(
                icon: Icons.lock_rounded,
                title: l.liveCallPrivate,
                hint: l.liveCallPrivateHint,
                price: _price(sheetContext, quote.private, quote.currency),
                colors: const [Color(0xFFFFB02E), Color(0xFFF07B16)],
                onTap: quote.private == null
                    ? null
                    : () => Navigator.pop(sheetContext, LiveCallMode.private),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.icon,
    required this.title,
    required this.hint,
    required this.price,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String hint;
  final String price;
  final List<Color> colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: colors),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hint,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  price,
                  style: TextStyle(
                    color: colors.first,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// What every viewer sees while a call is on air: who (public), or that a
/// private call is on — and how many wait to call.
class LiveOnAirBanner extends StatelessWidget {
  const LiveOnAirBanner({required this.state, super.key});

  final LiveState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final onAir = state.onAir;
    if (onAir == null && state.callsWaiting == 0)
      return const SizedBox.shrink();
    final private = onAir?.mode == LiveCallMode.private;
    final label = onAir == null
        ? l.liveCallWaitingCount(state.callsWaiting)
        : private
        ? l.liveCallBannerPrivate
        : l.liveCallBannerPublic(onAir.callerName ?? '');
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: private
                  ? const Color(0xFFFFB02E)
                  : const Color(0xFF7C5CFF),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                onAir == null
                    ? Icons.people_alt_rounded
                    : private
                    ? Icons.lock_rounded
                    : (onAir.muted
                          ? Icons.mic_off_rounded
                          : Icons.graphic_eq_rounded),
                size: 15,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (onAir != null && state.callsWaiting > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '· ${l.liveCallWaitingCount(state.callsWaiting)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The caller's own place in the line, or their call: where it stands, their
/// microphone, and the way out.
class LiveMyCallBar extends StatelessWidget {
  const LiveMyCallBar({required this.state, required this.cubit, super.key});

  final LiveState state;
  final LiveViewerCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final mine = state.myCall;
    if (mine == null) return const SizedBox.shrink();
    final private = mine.mode == LiveCallMode.private;
    final mutedByHost = mine.muted && mine.status == LiveCallStatus.active;
    final (icon, text) = switch (mine.status) {
      LiveCallStatus.waiting => (
        Icons.hourglass_top_rounded,
        state.callsAhead == 0
            ? l.liveCallWaitingNext
            : l.liveCallWaiting(state.callsAhead),
      ),
      LiveCallStatus.connecting => (
        Icons.wifi_calling_3_rounded,
        l.liveCallConnecting,
      ),
      _ =>
        mutedByHost
            ? (Icons.mic_off_rounded, l.liveCallMutedByHost)
            : (
                private ? Icons.lock_rounded : Icons.graphic_eq_rounded,
                private ? l.liveCallOnAirPrivate : l.liveCallOnAirPublic,
              ),
    };
    final active = mine.status == LiveCallStatus.active;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: private
                ? const [Color(0xCCF07B16), Color(0xCCFFB02E)]
                : const [Color(0xCC4F3BCB), Color(0xCC7C5CFF)],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            if (active && !mutedByHost)
              IconButton(
                onPressed: cubit.toggleCallMic,
                icon: Icon(
                  state.callMicOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                  color: Colors.white,
                ),
              ),
            TextButton(
              onPressed: state.callBusy ? null : cubit.endMyCall,
              style: TextButton.styleFrom(
                backgroundColor: active
                    ? const Color(0xFFE5484D)
                    : Colors.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              child: Text(
                active ? l.liveCallEnd : l.liveCallLeaveLine,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stars, and an optional line, for the call that just ended.
Future<void> showLiveCallRating(BuildContext context, String consultationId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: const Color(0xFF1B0F3B),
    builder: (_) => _RatingSheet(consultationId: consultationId),
  );
}

class _RatingSheet extends StatefulWidget {
  const _RatingSheet({required this.consultationId});
  final String consultationId;

  @override
  State<_RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<_RatingSheet> {
  int _stars = 0;
  bool _sending = false;
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_stars == 0 || _sending) return;
    setState(() => _sending = true);
    final messenger = ScaffoldMessenger.of(context);
    final thanks = context.l10n.liveCallRateThanks;
    try {
      await getIt<ConsultationRepository>().review(
        widget.consultationId,
        rating: _stars,
        text: _text.text.trim(),
      );
      messenger.showSnackBar(SnackBar(content: Text(thanks)));
    } catch (_) {}
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.liveCallRateTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _stars = i),
                  icon: Icon(
                    i <= _stars
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: const Color(0xFFFFC53D),
                    size: 36,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _text,
            maxLines: 3,
            maxLength: 500,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l.liveCallRateSkip,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: _stars == 0 || _sending ? null : _send,
                  child: Text(l.liveCallRateSend),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Watches the cubit for the things that need a sheet or a message: a call that
/// ended (rating), and a microphone that was refused.
class LiveCallListener extends StatefulWidget {
  const LiveCallListener({required this.cubit, required this.child, super.key});

  final LiveViewerCubit cubit;
  final Widget child;

  @override
  State<LiveCallListener> createState() => _LiveCallListenerState();
}

class _LiveCallListenerState extends State<LiveCallListener> {
  StreamSubscription<LiveState>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.cubit.stream.listen(_onState);
  }

  @override
  void didUpdateWidget(covariant LiveCallListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.cubit, widget.cubit)) {
      unawaited(_sub?.cancel());
      _sub = widget.cubit.stream.listen(_onState);
    }
  }

  void _onState(LiveState s) {
    if (!mounted) return;
    final ended = s.endedCall?.consultationId;
    if (ended != null) {
      widget.cubit.clearEndedCall();
      unawaited(showLiveCallRating(context, ended));
    }
    if (s.error == 'microphone') {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(context.l10n.liveCallMicNeeded)));
    }
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
