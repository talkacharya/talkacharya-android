import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../engine/chat_controller.dart';
import '../ports/chat_ports.dart';

/// Text field + send. For a participant who [ChatIdentity.canDictate] (the
/// astrologer), a mic button runs on-device speech-to-text into the field — the
/// astrologer reviews the text and sends it as a normal message.
class ChatComposer extends StatefulWidget {
  const ChatComposer({
    required this.controller,
    this.enabled = true,
    this.hint = 'Message',
    this.above,
    this.holdToTalkText = 'Hold to record a voice message',
    this.micDeniedText = 'Microphone permission is needed for voice messages',
    super.key,
  });

  final ChatController controller;
  final bool enabled;
  final String hint;

  /// An optional strip directly above the input row (the astrologer's quick
  /// replies). It is handed an `insert` callback that drops text into the
  /// field, ready to edit, rather than sending it.
  final Widget Function(BuildContext context, void Function(String) insert)?
  above;

  final String holdToTalkText;
  final String micDeniedText;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _field = TextEditingController();
  final _focus = FocusNode();
  bool _dictating = false;
  String _preDictationText = '';

  ChatController get c => widget.controller;

  StreamSubscription<ChatSessionState>? _replies;

  @override
  void initState() {
    super.initState();
    // Choosing a reply — a swipe or the long-press menu — means "I am about to
    // type": bring the keyboard up with the quote, the way every messenger
    // does, rather than leaving a reply bar over a closed field.
    var quoting = c.state.replyingTo;
    _replies = c.stream.listen((s) {
      final next = s.replyingTo;
      if (next != null && next != quoting && widget.enabled && mounted) {
        _focus.requestFocus();
      }
      quoting = next;
    });
  }

  @override
  void dispose() {
    _replies?.cancel();
    _field.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _send() {
    final text = _field.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    c.sendText(text);
    _field.clear();
    setState(() {});
  }

  Future<void> _attach() async {
    final source = await showModalBottomSheet<PickSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, PickSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, PickSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) await c.attachImages(source);
  }

  /// Put [text] in the field, after whatever is already there, and leave the
  /// cursor at the end so it can be edited before sending.
  void _insert(String text) {
    final existing = _field.text.trimRight();
    _field.text = existing.isEmpty ? text : '$existing $text';
    _field.selection = TextSelection.collapsed(offset: _field.text.length);
    c.onComposerChanged(_field.text);
    _focus.requestFocus();
    setState(() {});
  }

  Future<void> _startVoice() async {
    if (!widget.enabled) return;
    final ok = await c.startVoiceNote();
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(widget.micDeniedText)));
    }
  }

  Future<void> _endVoice({required bool send}) async {
    if (!c.state.recording) return;
    if (send) {
      await c.sendVoiceNote();
    } else {
      await c.cancelVoiceNote();
    }
  }

  /// A tap, not a hold. Says what to do instead of silently doing nothing.
  void _voiceHint() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(widget.holdToTalkText)));
  }

  Future<void> _toggleDictation() async {
    if (_dictating) {
      await c.endDictation();
      setState(() => _dictating = false);
      return;
    }
    _preDictationText = _field.text.isEmpty ? '' : '${_field.text} ';
    setState(() => _dictating = true);
    await c.beginDictation((transcript) {
      _field.text = '$_preDictationText$transcript';
      _field.selection = TextSelection.collapsed(offset: _field.text.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(top: BorderSide(color: scheme.outlineVariant)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (c.state.recording) _RecordingStrip(controller: c),
            if (widget.above != null && widget.enabled)
              widget.above!(context, _insert),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (c.canAttachImages)
                  IconButton(
                    onPressed: widget.enabled ? _attach : null,
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    color: scheme.primary,
                    tooltip: 'Send a photo',
                  ),
                Expanded(
                  child: TextField(
                    controller: _field,
                    focusNode: _focus,
                    enabled: widget.enabled,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    onChanged: (v) {
                      c.onComposerChanged(v);
                      // Rebuild so the mic ↔ send toggle reacts immediately.
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: _dictating ? 'Listening…' : widget.hint,
                      filled: true,
                      fillColor: scheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                if (c.identity.canDictate) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: widget.enabled ? _toggleDictation : null,
                    icon: Icon(
                      _dictating
                          ? Icons.stop_circle_rounded
                          : Icons.mic_rounded,
                    ),
                    color: _dictating ? scheme.error : scheme.primary,
                    tooltip: _dictating ? 'Stop' : 'Dictate',
                  ),
                ],
                const SizedBox(width: 2),
                // AnimatedSwitcher gives a smooth crossfade between the
                // mic (empty field) and send (has text) buttons. Without
                // it the swap is a hard frame-cut that looks like a jhatka.
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(scale: anim, child: child),
                  ),
                  child: (c.canRecordVoice && _field.text.trim().isEmpty)
                      ? GestureDetector(
                          key: const ValueKey('mic'),
                          onLongPressStart: (_) => _startVoice(),
                          onLongPressEnd: (_) => _endVoice(send: true),
                          onLongPressCancel: () => _endVoice(send: false),
                          child: IconButton.filled(
                            onPressed: widget.enabled ? _voiceHint : null,
                            icon: Icon(
                              c.state.recording
                                  ? Icons.stop_rounded
                                  : Icons.graphic_eq_rounded,
                              size: 20,
                            ),
                          ),
                        )
                      : IconButton.filled(
                          key: const ValueKey('send'),
                          onPressed: widget.enabled ? _send : null,
                          icon: const Icon(Icons.send_rounded, size: 20),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown while the microphone is open: how long, and how to stop.
class _RecordingStrip extends StatefulWidget {
  const _RecordingStrip({required this.controller});
  final ChatController controller;

  @override
  State<_RecordingStrip> createState() => _RecordingStripState();
}

class _RecordingStripState extends State<_RecordingStrip> {
  late final DateTime _since = DateTime.now();
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
    final scheme = Theme.of(context).colorScheme;
    final secs = DateTime.now().difference(_since).inSeconds;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 8),
      child: Row(
        children: [
          Icon(
            Icons.fiber_manual_record_rounded,
            size: 12,
            color: scheme.error,
          ),
          const SizedBox(width: 8),
          Text(
            '${(secs ~/ 60).toString().padLeft(2, '0')}:'
            '${(secs % 60).toString().padLeft(2, '0')}',
            style: TextStyle(
              color: scheme.error,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => widget.controller.cancelVoiceNote(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
