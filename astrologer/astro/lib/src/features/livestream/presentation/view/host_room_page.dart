import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import 'go_live_page.dart';
import 'widgets/live_chat_image.dart';
import '../../../../core/l10n/l10n.dart';

/// The broadcast screen: our own camera full-bleed, the chat and viewer count
/// over it, and the controls that matter while on air.
///
/// Going live happens here rather than on the previous screen so the astrologer
/// sees themselves the moment the camera opens.
class HostRoomPage extends StatefulWidget {
  const HostRoomPage({required this.streamId, required this.title, super.key});

  final String streamId;
  final String title;

  @override
  State<HostRoomPage> createState() => _HostRoomPageState();
}

class _HostRoomPageState extends State<HostRoomPage> {
  late final LiveHostCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = buildHostCubit(context, widget.streamId);
    unawaited(_cubit.goLive());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<bool> _confirmEnd() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End the session?'),
        content: const Text(
          'Everyone watching will be disconnected and the stream closes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Stay live'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('End session'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocProvider.value(
        value: _cubit,
        child: BlocConsumer<LiveHostCubit, LiveState>(
          listenWhen: (a, b) =>
              a.phase != b.phase && b.phase == LivePhase.ended,
          listener: (context, state) {
            if (state.endReason == LiveEndReason.hostEnded &&
                Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return PopScope(
              canPop: !state.phase.isOn,
              onPopInvokedWithResult: (didPop, _) async {
                if (didPop || !state.phase.isOn) return;
                if (await _confirmEnd()) {
                  await _cubit.endStream();
                  if (context.mounted) Navigator.of(context).pop();
                }
              },
              child: Scaffold(
                backgroundColor: const Color(0xFF12102A),
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (state.showLocalVideo)
                      LiveVideoView(
                        track: state.localVideo,
                        mirror: state.frontCamera,
                      )
                    else
                      const ColoredBox(color: Color(0xFF12102A)),
                    SafeArea(
                      child: switch (state.phase) {
                        LivePhase.permissionDenied => _PermissionView(
                          blocked: state.permanentlyDenied,
                          onSettings: _cubit.openSettings,
                          onRetry: _cubit.retry,
                          onClose: () => Navigator.of(context).pop(),
                        ),
                        LivePhase.failed => _FailedView(
                          message: state.error,
                          onRetry: _cubit.retry,
                          onClose: () => Navigator.of(context).pop(),
                        ),
                        LivePhase.ended => _EndedView(
                          state: state,
                          onClose: () => Navigator.of(context).pop(),
                        ),
                        _ => _OnAirView(
                          state: state,
                          title: widget.title,
                          onEnd: () async {
                            if (await _confirmEnd()) {
                              await _cubit.endStream();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                        ),
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OnAirView extends StatelessWidget {
  const _OnAirView({
    required this.state,
    required this.title,
    required this.onEnd,
  });

  final LiveState state;
  final String title;
  final Future<void> Function() onEnd;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LiveHostCubit>();
    return Column(
      children: [
        _HostHeader(state: state, title: title, onEnd: onEnd),
        const Spacer(),
        if (state.gifts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _GiftStrip(gifts: state.gifts),
          ),
        _HostChat(messages: state.messages),
        _HostControls(
          state: state,
          onCamera: cubit.toggleCamera,
          onMic: cubit.toggleMic,
          onFlip: cubit.switchCamera,
          onModerate: () => _showModerationSheet(context, cubit, state),
        ),
      ],
    );
  }
}

class _HostHeader extends StatelessWidget {
  const _HostHeader({
    required this.state,
    required this.title,
    required this.onEnd,
  });

  final LiveState state;
  final String title;
  final Future<void> Function() onEnd;

  @override
  Widget build(BuildContext context) {
    final live = state.phase == LivePhase.live;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC000000), Color(0x00000000)],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: live ? const Color(0xFFE5484D) : const Color(0xFFFFC53D),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              live ? 'LIVE' : 'CONNECTING',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (state.startedAt != null) _Elapsed(since: state.startedAt!),
              ],
            ),
          ),
          const Icon(Icons.visibility_rounded, size: 16, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            '${state.viewerCount}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(width: 6),
          TextButton(
            onPressed: onEnd,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF8A8A),
            ),
            child: const Text('End'),
          ),
        ],
      ),
    );
  }
}

/// How long we have been on air — the one number a host keeps glancing at.
class _Elapsed extends StatefulWidget {
  const _Elapsed({required this.since});
  final DateTime since;

  @override
  State<_Elapsed> createState() => _ElapsedState();
}

class _ElapsedState extends State<_Elapsed> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => mounted ? setState(() {}) : null,
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = DateTime.now().difference(widget.since);
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final text = d.inHours > 0 ? '${d.inHours}:$m:$s' : '$m:$s';
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 12,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }
}

class _HostChat extends StatelessWidget {
  const _HostChat({required this.messages});
  final List<LiveChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          'Questions from viewers appear here.',
          style: TextStyle(color: Colors.white38, fontSize: 13),
        ),
      );
    }
    final recent = messages.length > 30
        ? messages.sublist(messages.length - 30)
        : messages;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.3,
      ),
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        itemCount: recent.length,
        itemBuilder: (context, i) {
          final message = recent[recent.length - 1 - i];
          return InkWell(
            onLongPress: () => _showMessageActions(context, message),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 13, height: 1.3),
                      children: [
                        TextSpan(
                          text: '${message.name}  ',
                          style: TextStyle(
                            color: message.isHost
                                ? const Color(0xFFFFC53D)
                                : Colors.white70,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (message.text.isEmpty && message.hasImage)
                          TextSpan(
                            text: context.l10n.livePhotoLabel,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else
                          TextSpan(
                            text: message.text,
                            style: const TextStyle(color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                  if (message.hasImage) LiveChatImage(url: message.imageUrl!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GiftStrip extends StatelessWidget {
  const _GiftStrip({required this.gifts});
  final List<LiveGiftEvent> gifts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final gift in gifts)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB02E).withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '🎁  ${gift.senderName} sent ${gift.quantity > 1 ? '${gift.quantity}× ' : ''}'
                '${gift.giftName.isEmpty ? 'a gift' : gift.giftName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HostControls extends StatefulWidget {
  const _HostControls({
    required this.state,
    required this.onCamera,
    required this.onMic,
    required this.onFlip,
    required this.onModerate,
  });

  final LiveState state;
  final VoidCallback onCamera;
  final VoidCallback onMic;
  final VoidCallback onFlip;
  final VoidCallback onModerate;

  @override
  State<_HostControls> createState() => _HostControlsState();
}

class _HostControlsState extends State<_HostControls> {
  final _controller = TextEditingController();

  /// Picked but not yet sent.
  String? _imagePath;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    final image = _imagePath;
    if (text.isEmpty && image == null) return;
    _controller.clear();
    setState(() => _imagePath = null);
    await context.read<LiveHostCubit>().sendChat(text, imagePath: image);
  }

  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked != null && mounted) setState(() => _imagePath = picked.path);
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.livePhotoFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        4,
        12,
        10 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        children: [
          if (_imagePath != null)
            LiveChatImagePreview(
              path: _imagePath!,
              onRemove: () => setState(() => _imagePath = null),
            ),
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: context.l10n.liveSendPhoto,
                onPressed: _pickImage,
                icon: const Icon(Icons.image_rounded),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: InputDecoration(
                    hintText: 'Answer your viewers…',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.12),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: s.sending ? null : _send,
                icon: const Icon(Icons.send_rounded),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ControlButton(
                icon: s.micOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                label: 'Mic',
                off: !s.micOn,
                onTap: widget.onMic,
              ),
              _ControlButton(
                icon: s.cameraOn
                    ? Icons.videocam_rounded
                    : Icons.videocam_off_rounded,
                label: 'Camera',
                off: !s.cameraOn,
                onTap: widget.onCamera,
              ),
              _ControlButton(
                icon: Icons.flip_camera_ios_rounded,
                label: 'Flip',
                onTap: s.cameraOn ? widget.onFlip : null,
              ),
              _ControlButton(
                icon: Icons.shield_rounded,
                label: 'Moderate',
                onTap: widget.onModerate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.off = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool off;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: off
                ? const Color(0xFFE5484D)
                : Colors.white.withValues(alpha: 0.14),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox(
                width: 52,
                height: 52,
                child: Icon(icon, color: Colors.white, size: 22),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

/// Slow mode is the one moderation control worth having one tap away; removing a
/// viewer starts from their message.
Future<void> _showModerationSheet(
  BuildContext context,
  LiveHostCubit cubit,
  LiveState state,
) async {
  await showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text('Slow mode'),
            subtitle: Text('How long a viewer must wait between messages'),
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final seconds in const [0, 5, 15, 30, 60])
                ChoiceChip(
                  label: Text(seconds == 0 ? 'Off' : '${seconds}s'),
                  selected: state.slowModeSeconds == seconds,
                  onSelected: (_) {
                    cubit.setSlowMode(seconds);
                    Navigator.pop(ctx);
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          const ListTile(
            dense: true,
            leading: Icon(Icons.info_outline_rounded, size: 18),
            title: Text(
              'Long-press a message to pin it or remove the viewer.',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _showMessageActions(
  BuildContext context,
  LiveChatMessage message,
) async {
  final cubit = context.read<LiveHostCubit>();
  await showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(message.name), subtitle: Text(message.text)),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.push_pin_rounded),
            title: const Text('Pin this message'),
            onTap: () {
              cubit.pinMessage(message.id);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.visibility_off_rounded),
            title: const Text('Hide this message'),
            onTap: () {
              cubit.hideMessage(message.id);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.block_rounded, color: Color(0xFFE5484D)),
            title: const Text('Remove this viewer'),
            subtitle: const Text('They cannot rejoin or chat on this stream'),
            onTap: () {
              cubit.removeViewer(message.userId);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    ),
  );
}

class _PermissionView extends StatelessWidget {
  const _PermissionView({
    required this.blocked,
    required this.onSettings,
    required this.onRetry,
    required this.onClose,
  });

  final bool blocked;
  final VoidCallback onSettings;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return _Message(
      icon: Icons.videocam_off_rounded,
      title: 'Camera and microphone needed',
      body: blocked
          ? 'Camera or microphone access is turned off for TalkAcharya. Turn it '
                'on in Settings to go live.'
          : 'Allow camera and microphone access so your viewers can see and hear '
                'you.',
      primaryLabel: blocked ? 'Open settings' : 'Try again',
      onPrimary: blocked ? onSettings : onRetry,
      onClose: onClose,
    );
  }
}

class _FailedView extends StatelessWidget {
  const _FailedView({
    required this.message,
    required this.onRetry,
    required this.onClose,
  });

  final String? message;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return _Message(
      icon: Icons.signal_wifi_bad_rounded,
      title: "Couldn't go live",
      body: message?.isNotEmpty == true
          ? message!
          : 'Check your connection and try again.',
      primaryLabel: 'Try again',
      onPrimary: onRetry,
      onClose: onClose,
    );
  }
}

class _EndedView extends StatelessWidget {
  const _EndedView({required this.state, required this.onClose});
  final LiveState state;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return _Message(
      icon: Icons.check_circle_rounded,
      title: 'Session ended',
      body:
          'Peak ${state.viewerCount} watching. Your earnings from gifts appear '
          'under Earnings.',
      primaryLabel: 'Done',
      onPrimary: onClose,
      onClose: null,
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    required this.onClose,
  });

  final IconData icon;
  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.white70),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: onPrimary, child: Text(primaryLabel)),
            if (onClose != null)
              TextButton(
                onPressed: onClose,
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
