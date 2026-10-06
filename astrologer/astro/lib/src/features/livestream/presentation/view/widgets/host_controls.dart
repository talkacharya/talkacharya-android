import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../../../core/l10n/l10n.dart';
import 'live_chat_image.dart';

class HostControls extends StatefulWidget {
  const HostControls({
    required this.state,
    required this.onCamera,
    required this.onMic,
    required this.onFlip,
    required this.onModerate,
    super.key,
  });

  final LiveState state;
  final VoidCallback onCamera;
  final VoidCallback onMic;
  final VoidCallback onFlip;
  final VoidCallback onModerate;

  @override
  State<HostControls> createState() => _HostControlsState();
}

class _HostControlsState extends State<HostControls> {
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
    final l = context.l10n;
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
                    hintText: l.hostChatHint,
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
              ControlButton(
                icon: s.micOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                label: 'Mic',
                off: !s.micOn,
                onTap: widget.onMic,
              ),
              ControlButton(
                icon: s.cameraOn
                    ? Icons.videocam_rounded
                    : Icons.videocam_off_rounded,
                label: 'Camera',
                off: !s.cameraOn,
                onTap: widget.onCamera,
              ),
              ControlButton(
                icon: Icons.flip_camera_ios_rounded,
                label: 'Flip',
                onTap: s.cameraOn ? widget.onFlip : null,
              ),
              ControlButton(
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

class ControlButton extends StatelessWidget {
  const ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.off = false,
    super.key,
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
Future<void> showModerationSheet(
  BuildContext context,
  LiveHostCubit cubit,
  LiveState state,
) async {
  final l = context.l10n;
  await showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(l.hostSlowMode),
            subtitle: Text(l.hostSlowModeBody),
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
