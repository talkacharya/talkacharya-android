import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../engine/call_controller.dart';
import '../models/call_state.dart';

/// All user-facing call copy. English defaults; apps pass localised values.
class CallStrings {
  const CallStrings({
    this.calling = 'Calling…',
    this.ringing = 'Ringing…',
    this.connecting = 'Connecting…',
    this.reconnecting = 'Reconnecting…',
    this.callEnded = 'Call ended',
    this.poorConnection = 'Weak connection',
    this.mute = 'Mute',
    this.speaker = 'Speaker',
    this.endCall = 'End',
    this.encrypted = 'Encrypted call',
    this.micTitle = 'Microphone needed',
    this.micBody = 'Allow microphone access so the other person can hear you.',
    this.micBlockedBody =
        'Microphone access is turned off for this app. Turn it on in Settings.',
    this.openSettings = 'Open settings',
    this.tryAgain = 'Try again',
    this.failedTitle = "Couldn't start the call",
    this.endConfirmTitle = 'End this call?',
    this.endConfirmBody = 'Billing stops as soon as the call ends.',
    this.endConfirmYes = 'End call',
    this.endConfirmNo = 'Stay',
  });

  final String calling;
  final String ringing;
  final String connecting;
  final String reconnecting;
  final String callEnded;
  final String poorConnection;
  final String mute;
  final String speaker;
  final String endCall;
  final String encrypted;
  final String micTitle;
  final String micBody;
  final String micBlockedBody;
  final String openSettings;
  final String tryAgain;
  final String failedTitle;
  final String endConfirmTitle;
  final String endConfirmBody;
  final String endConfirmYes;
  final String endConfirmNo;
}

/// Full-screen voice call UI driven by the nearest [CallController].
///
/// [statusOverride] replaces the status line (e.g. "Waiting for Acharya to accept"
/// before the call exists); [top] sits under the header (billing HUD / low-balance
/// banner); [accent] tints the avatar halo.
class CallScreen extends StatelessWidget {
  const CallScreen({
    required this.peerName,
    this.peerAvatarUrl,
    this.strings = const CallStrings(),
    this.statusOverride,
    this.top,
    this.accent,
    this.onEnded,
    this.confirmEnd = true,
    super.key,
  });

  final String peerName;
  final String? peerAvatarUrl;
  final CallStrings strings;
  final String? statusOverride;
  final Widget? top;
  final Color? accent;

  /// Called once when the call reaches [CallPhase.ended].
  final VoidCallback? onEnded;
  final bool confirmEnd;

  static const _bgTop = Color(0xFF140B2E);
  static const _bgBottom = Color(0xFF2A1454);

  @override
  Widget build(BuildContext context) {
    final halo = accent ?? const Color(0xFFFFB347);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocConsumer<CallController, CallState>(
        listenWhen: (a, b) => a.phase != b.phase && b.phase == CallPhase.ended,
        listener: (_, _) => onEnded?.call(),
        builder: (context, state) {
          final controller = context.read<CallController>();
          return PopScope(
            canPop: !state.phase.isLive,
            onPopInvokedWithResult: (didPop, _) async {
              if (didPop || !state.phase.isLive) return;
              if (await _confirmEnd(context)) await controller.hangUp();
            },
            child: Scaffold(
              backgroundColor: _bgTop,
              body: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_bgTop, _bgBottom],
                  ),
                ),
                child: SafeArea(
                  child: switch (state.phase) {
                    CallPhase.permissionDenied => _PermissionView(
                      strings: strings,
                      blocked: state.permanentlyDenied,
                      onSettings: controller.openSettings,
                      onRetry: controller.retry,
                    ),
                    CallPhase.failed => _FailedView(
                      strings: strings,
                      message: state.error,
                      onRetry: controller.retry,
                    ),
                    _ => _LiveView(
                      state: state,
                      peerName: state.peerName.isNotEmpty
                          ? state.peerName
                          : peerName,
                      avatarUrl: peerAvatarUrl,
                      strings: strings,
                      statusOverride: statusOverride,
                      top: top,
                      halo: halo,
                      onMute: controller.toggleMute,
                      onSpeaker: controller.toggleSpeaker,
                      onEnd: () async {
                        if (!confirmEnd ||
                            state.phase != CallPhase.connected ||
                            await _confirmEnd(context)) {
                          await controller.hangUp();
                        }
                      },
                    ),
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _confirmEnd(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.endConfirmTitle),
        content: Text(strings.endConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(strings.endConfirmNo),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _endRed),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(strings.endConfirmYes),
          ),
        ],
      ),
    );
    return ok ?? false;
  }
}

const _endRed = Color(0xFFE5484D);

class _LiveView extends StatelessWidget {
  const _LiveView({
    required this.state,
    required this.peerName,
    required this.avatarUrl,
    required this.strings,
    required this.statusOverride,
    required this.top,
    required this.halo,
    required this.onMute,
    required this.onSpeaker,
    required this.onEnd,
  });

  final CallState state;
  final String peerName;
  final String? avatarUrl;
  final CallStrings strings;
  final String? statusOverride;
  final Widget? top;
  final Color halo;
  final VoidCallback onMute;
  final VoidCallback onSpeaker;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pulsing =
        state.phase != CallPhase.connected && state.phase != CallPhase.ended;
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_rounded,
              size: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
            Text(
              strings.encrypted,
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        if (top != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: top,
          ),
        const Spacer(flex: 2),
        _Avatar(
          name: peerName,
          url: avatarUrl,
          halo: state.phase == CallPhase.reconnecting
              ? const Color(0xFFFFC53D)
              : halo,
          pulsing: pulsing,
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            peerName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _StatusLine(
          state: state,
          strings: strings,
          overrideText: statusOverride,
        ),
        if (state.phase == CallPhase.connected && state.quality == 1) ...[
          const SizedBox(height: 10),
          _Pill(
            icon: Icons.signal_cellular_alt_1_bar_rounded,
            text: strings.poorConnection,
            color: const Color(0xFFFFC53D),
          ),
        ],
        const Spacer(flex: 3),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _RoundButton(
                icon: state.muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                label: strings.mute,
                active: state.muted,
                onTap: onMute,
              ),
              _RoundButton(
                icon: Icons.call_end_rounded,
                label: strings.endCall,
                background: _endRed,
                size: 76,
                onTap: onEnd,
              ),
              _RoundButton(
                icon: state.speakerOn
                    ? Icons.volume_up_rounded
                    : Icons.volume_down_rounded,
                label: strings.speaker,
                active: state.speakerOn,
                onTap: onSpeaker,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusLine extends StatefulWidget {
  const _StatusLine({
    required this.state,
    required this.strings,
    required this.overrideText,
  });
  final CallState state;
  final CallStrings strings;
  final String? overrideText;

  @override
  State<_StatusLine> createState() => _StatusLineState();
}

class _StatusLineState extends State<_StatusLine> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && widget.state.connectedAt != null) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _clock(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final strings = widget.strings;
    final text =
        widget.overrideText ??
        switch (s.phase) {
          CallPhase.idle || CallPhase.preparing || CallPhase.joining =>
            strings.calling,
          CallPhase.waitingPeer => strings.ringing,
          CallPhase.connecting => strings.connecting,
          CallPhase.connected =>
            s.connectedAt == null
                ? strings.connecting
                : _clock(DateTime.now().difference(s.connectedAt!)),
          CallPhase.reconnecting => strings.reconnecting,
          CallPhase.ended => strings.callEnded,
          _ => '',
        };
    final connected = s.phase == CallPhase.connected;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (connected) ...[
          _QualityBars(quality: s.quality),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white.withValues(alpha: connected ? 0.95 : 0.75),
            fontFeatures: const [FontFeature.tabularFigures()],
            letterSpacing: connected ? 1.2 : 0,
          ),
        ),
      ],
    );
  }
}

class _QualityBars extends StatelessWidget {
  const _QualityBars({required this.quality});
  final int quality;

  @override
  Widget build(BuildContext context) {
    final color = switch (quality) {
      3 => const Color(0xFF3DD68C),
      2 => const Color(0xFFFFC53D),
      1 => const Color(0xFFFF6B6B),
      _ => Colors.white54,
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 1; i <= 3; i++)
          Container(
            width: 4,
            height: 5.0 + i * 4,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              color: i <= math.max(quality, 0) ? color : Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}

class _Avatar extends StatefulWidget {
  const _Avatar({
    required this.name,
    required this.url,
    required this.halo,
    required this.pulsing,
  });
  final String name;
  final String? url;
  final Color halo;
  final bool pulsing;

  @override
  State<_Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<_Avatar> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(covariant _Avatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (widget.pulsing && !reduce) {
      if (!_c.isAnimating) _c.repeat();
    } else {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  String get _initials {
    final parts = widget.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty);
    final letters = parts
        .take(2)
        .map((p) => String.fromCharCode(p.runes.first).toUpperCase());
    return letters.isEmpty ? '?' : letters.join();
  }

  @override
  Widget build(BuildContext context) {
    const size = 132.0;
    return SizedBox(
      width: size * 1.9,
      height: size * 1.9,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) => Stack(
          alignment: Alignment.center,
          children: [
            if (widget.pulsing)
              for (var i = 0; i < 3; i++)
                Builder(
                  builder: (_) {
                    final t = (_c.value + i / 3) % 1.0;
                    return Container(
                      width: size * (1 + 0.9 * t),
                      height: size * (1 + 0.9 * t),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.halo.withValues(alpha: 0.22 * (1 - t)),
                      ),
                    );
                  },
                ),
            child!,
          ],
        ),
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [widget.halo, const Color(0xFFE8364F), widget.halo],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.halo.withValues(alpha: 0.45),
                blurRadius: 30,
              ),
            ],
          ),
          child: ClipOval(
            child: Container(
              color: const Color(0xFF23133F),
              alignment: Alignment.center,
              child: widget.url != null && widget.url!.isNotEmpty
                  ? Image.network(
                      widget.url!,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _initialsText(),
                    )
                  : _initialsText(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _initialsText() => Text(
    _initials,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 42,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
    this.background,
    this.size = 62,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;
  final Color? background;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bg =
        background ??
        (active ? Colors.white : Colors.white.withValues(alpha: 0.14));
    final fg = background != null
        ? Colors.white
        : (active ? const Color(0xFF23133F) : Colors.white);
    return Semantics(
      button: true,
      toggled: background == null ? active : null,
      label: label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: bg,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                HapticFeedback.selectionClick();
                onTap();
              },
              child: SizedBox(
                width: size,
                height: size,
                child: Icon(icon, color: fg, size: size * 0.42),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _PermissionView extends StatelessWidget {
  const _PermissionView({
    required this.strings,
    required this.blocked,
    required this.onSettings,
    required this.onRetry,
  });
  final CallStrings strings;
  final bool blocked;
  final VoidCallback onSettings;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => _MessageView(
    icon: Icons.mic_off_rounded,
    title: strings.micTitle,
    body: blocked ? strings.micBlockedBody : strings.micBody,
    primaryLabel: blocked ? strings.openSettings : strings.tryAgain,
    onPrimary: blocked ? onSettings : onRetry,
    secondaryLabel: blocked ? strings.tryAgain : null,
    onSecondary: blocked ? onRetry : null,
  );
}

class _FailedView extends StatelessWidget {
  const _FailedView({
    required this.strings,
    required this.message,
    required this.onRetry,
  });
  final CallStrings strings;
  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => _MessageView(
    icon: Icons.phone_disabled_rounded,
    title: strings.failedTitle,
    body: message ?? '',
    primaryLabel: strings.tryAgain,
    onPrimary: onRetry,
  );
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });
  final IconData icon;
  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 56, color: Colors.white70),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: onPrimary,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF23133F),
                    minimumSize: const Size(200, 48),
                  ),
                  child: Text(primaryLabel),
                ),
                if (secondaryLabel != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onSecondary,
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: Text(secondaryLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
