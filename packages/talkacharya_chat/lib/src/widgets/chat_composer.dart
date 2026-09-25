import 'package:flutter/material.dart';

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

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _field = TextEditingController();
  final _focus = FocusNode();
  bool _dictating = false;
  String _preDictationText = '';

  ChatController get c => widget.controller;

  @override
  void dispose() {
    _field.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _send() {
    final text = _field.text.trim();
    if (text.isEmpty) return;
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
                    onChanged: c.onComposerChanged,
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
                IconButton.filled(
                  onPressed: widget.enabled ? _send : null,
                  icon: const Icon(Icons.send_rounded, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
