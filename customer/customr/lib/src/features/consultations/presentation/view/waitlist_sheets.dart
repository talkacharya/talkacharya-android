import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/app_snack.dart';
import '../../../astrologers/presentation/channel_availability.dart';
import '../../data/consultation_repository.dart';
import '../../data/models/queue_entry.dart';

const _goldInk = Color(0xFF3A1703);

/// The gold button the app's main actions wear.
class _GoldButton extends StatelessWidget {
  const _GoldButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.busy = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Pressable(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: BrandColors.goldGradient.last.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: Ink(
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: BrandColors.goldGradient),
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: busy ? null : onTap,
              child: Center(
                child: busy
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: _goldInk,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(icon, size: 20, color: _goldInk),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: _goldInk,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The astrologer's face in their colour, with a small mark on the rim saying
/// what this sheet is about.
class _Portrait extends StatelessWidget {
  const _Portrait({
    required this.name,
    required this.avatar,
    required this.hue,
    required this.badge,
    required this.badgeColor,
  });

  final String name;
  final String? avatar;
  final AstroHue hue;
  final IconData badge;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(colors: [hue.start, hue.end, hue.start]),
            boxShadow: [
              BoxShadow(
                color: hue.start.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(shape: BoxShape.circle, color: surface),
            child: HueAvatar(name: name, url: avatar, hue: hue, size: 76),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
              border: Border.all(color: surface, width: 3),
            ),
            child: Icon(badge, size: 15, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// --- joining -------------------------------------------------------------

/// One way of consulting the customer can queue for, with what it costs.
typedef WaitlistChannel = ({String channel, String priceLabel});

/// Offers a place in a busy astrologer's line: who they are with, how many are
/// ahead, what waiting costs (nothing), and which kind of consultation to
/// queue for. Returns the place taken, or null when they walked away.
Future<QueueEntry?> showJoinWaitlistSheet(
  BuildContext context, {
  required String astrologerId,
  required String astrologerName,
  required List<WaitlistChannel> channels,
  String? avatar,
  String? initialChannel,
  int waiting = 0,
}) {
  return showAppSheet<QueueEntry>(
    context: context,
    builder: (_) => _JoinSheet(
      astrologerId: astrologerId,
      astrologerName: astrologerName,
      avatar: avatar,
      channels: channels,
      initialChannel: initialChannel,
      waiting: waiting,
    ),
  );
}

class _JoinSheet extends StatefulWidget {
  const _JoinSheet({
    required this.astrologerId,
    required this.astrologerName,
    required this.avatar,
    required this.channels,
    required this.initialChannel,
    required this.waiting,
  });

  final String astrologerId;
  final String astrologerName;
  final String? avatar;
  final List<WaitlistChannel> channels;
  final String? initialChannel;
  final int waiting;

  @override
  State<_JoinSheet> createState() => _JoinSheetState();
}

class _JoinSheetState extends State<_JoinSheet> {
  late String _channel =
      widget.channels.any((c) => c.channel == widget.initialChannel)
      ? widget.initialChannel!
      : widget.channels.first.channel;
  bool _joining = false;
  QueueEntry? _joined;

  Future<void> _join() async {
    setState(() => _joining = true);
    try {
      final entry = await getIt<ConsultationRepository>().joinQueue(
        astrologerId: widget.astrologerId,
        channel: _channel,
      );
      if (mounted) setState(() => _joined = entry);
    } catch (e) {
      if (mounted) {
        AppSnack.showTop(context, friendlyError(e), type: SnackType.error);
      }
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final hue = AstroPalette.forId(widget.astrologerId);
    final joined = _joined;

    return SingleChildScrollView(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: _Portrait(
                name: widget.astrologerName,
                avatar: widget.avatar,
                hue: hue,
                badge: joined == null
                    ? Icons.hourglass_top_rounded
                    : Icons.check_rounded,
                badgeColor: joined == null
                    ? AstroPalette.fire.end
                    : brand.online,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              joined == null
                  ? l.waitlistBusyTitle(widget.astrologerName)
                  : l.waitlistJoinedTitle(joined.position),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              joined == null ? l.waitlistBusyBody : l.waitlistJoinedBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: brand.inkMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            if (joined == null) ...[
              Row(
                children: [
                  Expanded(
                    child: _Fact(
                      icon: Icons.groups_rounded,
                      hue: AstroPalette.air,
                      value: '${widget.waiting}',
                      label: l.waitlistAhead,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Fact(
                      icon: Icons.schedule_rounded,
                      hue: AstroPalette.career,
                      // The server's own rule of thumb: ten minutes a person.
                      value: l.commonMinutesShort((widget.waiting + 1) * 10),
                      label: l.waitlistEstimate,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Fact(
                      icon: Icons.savings_rounded,
                      hue: AstroPalette.health,
                      value: l.waitlistFree,
                      label: l.waitlistToWait,
                    ),
                  ),
                ],
              ),
              if (widget.channels.length > 1) ...[
                const SizedBox(height: 18),
                Text(
                  l.waitlistQueueFor,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: brand.inkMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final (i, c) in widget.channels.indexed) ...[
                      if (i > 0) const SizedBox(width: 10),
                      Expanded(
                        child: _ChannelPick(
                          channel: c.channel,
                          priceLabel: c.priceLabel,
                          selected: c.channel == _channel,
                          onTap: _joining
                              ? null
                              : () => setState(() => _channel = c.channel),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              const SizedBox(height: 20),
              _GoldButton(
                label: l.waitlistJoin,
                icon: Icons.hourglass_top_rounded,
                busy: _joining,
                onTap: _join,
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: _joining ? null : () => Navigator.pop(context),
                child: Text(l.commonNotNow),
              ),
            ] else ...[
              _GoldButton(
                label: l.waitlistGotIt,
                onTap: () => Navigator.pop(context, joined),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

/// One number with its label, on a tinted tile.
class _Fact extends StatelessWidget {
  const _Fact({
    required this.icon,
    required this.hue,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final AstroHue hue;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: hue.tint(0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: hue.end),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: context.brand.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChannelPick extends StatelessWidget {
  const _ChannelPick({
    required this.channel,
    required this.priceLabel,
    required this.selected,
    required this.onTap,
  });

  final String channel;
  final String priceLabel;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final hue = channelHue(channel);
    return Pressable(
      child: Material(
        color: selected ? hue.tint(0.12) : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected ? hue.end : brand.hairline,
            width: selected ? 1.6 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: Column(
              children: [
                Icon(
                  channelIcon(channel),
                  size: 22,
                  color: selected ? hue.end : brand.inkMuted,
                ),
                const SizedBox(height: 6),
                Text(
                  channelVerb(l, channel),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  priceLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: brand.inkMuted,
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

// --- the turn ------------------------------------------------------------

String? _turnShowingFor;

/// "It is your turn": the astrologer the customer queued for is free, and
/// the turn lasts until [expiresAt]. Start takes them to that astrologer with
/// the booking already opening; letting it pass is theirs to choose too.
Future<void> showWaitlistTurnSheet(
  BuildContext context, {
  required String astrologerId,
  required String astrologerName,
  required String channel,
  DateTime? expiresAt,
}) async {
  // The same turn can arrive twice (socket and push): one sheet for it.
  if (_turnShowingFor == astrologerId) return;
  _turnShowingFor = astrologerId;
  try {
    final start = await showAppSheet<bool>(
      context: context,
      builder: (_) => _TurnSheet(
        astrologerId: astrologerId,
        astrologerName: astrologerName,
        channel: channel,
        expiresAt: expiresAt,
      ),
    );
    if (start == true && context.mounted) {
      unawaited(context.push(Routes.astrologerStarting(astrologerId, channel)));
    }
  } finally {
    _turnShowingFor = null;
  }
}

class _TurnSheet extends StatefulWidget {
  const _TurnSheet({
    required this.astrologerId,
    required this.astrologerName,
    required this.channel,
    required this.expiresAt,
  });

  final String astrologerId;
  final String astrologerName;
  final String channel;
  final DateTime? expiresAt;

  @override
  State<_TurnSheet> createState() => _TurnSheetState();
}

class _TurnSheetState extends State<_TurnSheet> {
  Timer? _tick;
  late final Duration _total =
      widget.expiresAt?.difference(DateTime.now()) ?? Duration.zero;

  Duration get _left {
    final at = widget.expiresAt;
    if (at == null) return Duration.zero;
    final d = at.difference(DateTime.now());
    return d.isNegative ? Duration.zero : d;
  }

  @override
  void initState() {
    super.initState();
    if (widget.expiresAt == null) return;
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_left == Duration.zero) {
        // The turn has passed on: nothing left here to act on.
        _tick?.cancel();
        Navigator.of(context).maybePop();
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  static String _clock(Duration d) {
    final s = d.inSeconds.clamp(0, 5999);
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final hue = AstroPalette.forId(widget.astrologerId);
    final left = _left;
    final timed = widget.expiresAt != null && _total.inSeconds > 0;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox.square(
              dimension: 116,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (timed)
                    SizedBox.square(
                      dimension: 116,
                      child: CircularProgressIndicator(
                        value: (left.inMilliseconds / _total.inMilliseconds)
                            .clamp(0.0, 1.0),
                        strokeWidth: 5,
                        strokeCap: StrokeCap.round,
                        color: brand.gold,
                        backgroundColor: brand.hairline,
                      ),
                    ),
                  HueAvatar(name: widget.astrologerName, hue: hue, size: 92),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.waitlistTurnTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.waitlistTurnWith(
              widget.astrologerName,
              channelLabel(l, widget.channel),
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: brand.inkMuted,
              height: 1.4,
            ),
          ),
          if (timed) ...[
            const SizedBox(height: 14),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AstroPalette.fire.tint(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_rounded,
                      size: 16,
                      color: AstroPalette.fire.end,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l.waitlistTurnBody(_clock(left)),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AstroPalette.fire.end,
                        fontWeight: FontWeight.w800,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          _GoldButton(
            label: l.waitlistStart,
            icon: channelIcon(widget.channel),
            onTap: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.commonNotNow),
          ),
        ],
      ),
    );
  }
}
