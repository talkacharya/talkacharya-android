import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart'
    show DeviceSttEngine, SttEngine;

import '../../../../core/l10n/l10n.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// The listing form's building blocks: a label above every field (never a
/// floating one crowding the next box), even spacing, a counter where there is
/// a limit, and a mic on text fields so the astrologer can speak instead of
/// type — in Hindi or English, remembered between fields.

/// Space between one field and the next.
const kFieldGap = 20.0;

/// A label, the field under it, and an optional hint below.
class FieldBlock extends StatelessWidget {
  const FieldBlock({
    required this.label,
    required this.child,
    this.hint,
    this.trailing,
    this.optional = false,
    super.key,
  });

  final String label;
  final Widget child;
  final String? hint;
  final Widget? trailing;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Padding(
      padding: const EdgeInsets.only(bottom: kFieldGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: label,
                    children: [
                      if (optional)
                        TextSpan(
                          text: '  ·  optional',
                          style: TextStyle(
                            color: brand.inkMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 8),
          child,
          if (hint != null) ...[
            const SizedBox(height: 6),
            Text(
              hint!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: brand.inkMuted,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The look every box in the form shares.
InputDecoration fieldDecoration(
  BuildContext context, {
  String? hint,
  String? prefix,
  String? suffix,
  Widget? suffixIcon,
  String? error,
}) {
  final brand = context.brand;
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: brand.hairline),
  );
  return InputDecoration(
    hintText: hint,
    prefixText: prefix,
    suffixText: suffix,
    suffixIcon: suffixIcon,
    errorText: error,
    errorMaxLines: 3,
    filled: true,
    fillColor: brand.tint,
    isDense: false,
    counterText: '',
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: border,
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 1.6,
      ),
    ),
  );
}

/// A text field kept in step with the draft: [value] in, [onChanged] out. Its
/// own controller, so typing is never fought by a rebuild.
class DraftTextField extends StatefulWidget {
  const DraftTextField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
    this.help,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 1,
    this.optional = false,
    this.voice = true,
    this.number = false,
    this.decimal = false,
    this.prefix,
    this.suffix,
    this.error,
    super.key,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? hint;
  final String? help;
  final int? maxLength;
  final int minLines;
  final int maxLines;
  final bool optional;

  /// Show the mic (text fields).
  final bool voice;
  final bool number;
  final bool decimal;
  final String? prefix;
  final String? suffix;
  final String? error;

  @override
  State<DraftTextField> createState() => _DraftTextFieldState();
}

class _DraftTextFieldState extends State<DraftTextField> {
  late final _controller = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(covariant DraftTextField old) {
    super.didUpdateWidget(old);
    // a change from outside (restored draft, dictation elsewhere)
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _append(String spoken) {
    final now = _controller.text.trimRight();
    final next = now.isEmpty ? spoken : '$now $spoken';
    final limited = widget.maxLength == null
        ? next
        : next.substring(0, next.length.clamp(0, widget.maxLength!));
    _controller.text = limited;
    widget.onChanged(limited);
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final multi = widget.maxLines > 1;
    final count = widget.maxLength == null
        ? null
        : Text(
            '${_controller.text.length}/${widget.maxLength}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: brand.inkMuted),
          );
    return FieldBlock(
      label: widget.label,
      optional: widget.optional,
      hint: widget.help,
      trailing: count,
      child: TextField(
        controller: _controller,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        textCapitalization: widget.number
            ? TextCapitalization.none
            : TextCapitalization.sentences,
        keyboardType: widget.number
            ? TextInputType.numberWithOptions(decimal: widget.decimal)
            : (multi ? TextInputType.multiline : TextInputType.text),
        inputFormatters: widget.number
            ? [
                FilteringTextInputFormatter.allow(
                  RegExp(widget.decimal ? r'[0-9.]' : r'[0-9]'),
                ),
              ]
            : null,
        onChanged: (v) {
          setState(() {}); // the counter
          widget.onChanged(v);
        },
        decoration: fieldDecoration(
          context,
          hint: widget.hint,
          prefix: widget.prefix,
          suffix: widget.suffix,
          error: widget.error,
          suffixIcon: widget.voice && !widget.number
              ? DictateButton(onText: _append)
              : null,
        ),
      ),
    );
  }
}

/// The mic: speak, and the words are added to the field. A long-press switches
/// between Hindi and English; the choice is remembered for every field.
class DictateButton extends StatefulWidget {
  const DictateButton({required this.onText, super.key});

  final ValueChanged<String> onText;

  /// One engine for the whole form (the device allows one listener at a time).
  static final SttEngine engine = DeviceSttEngine();

  @override
  State<DictateButton> createState() => _DictateButtonState();
}

const _langKey = 'listing_dictation_lang';

class _DictateButtonState extends State<DictateButton> {
  bool _mine = false;
  String _lang = 'hi';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      if (mounted) setState(() => _lang = p.getString(_langKey) ?? 'hi');
    });
  }

  Future<void> _toggle() async {
    final engine = DictateButton.engine;
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    if (_mine && engine.listening.value) {
      await engine.stop();
      return;
    }
    if (!await engine.available()) {
      messenger.showSnackBar(SnackBar(content: Text(l.lwVoiceUnavailable)));
      return;
    }
    if (engine.listening.value) await engine.stop();
    HapticFeedback.lightImpact();
    setState(() => _mine = true);
    await engine.start(
      language: _lang,
      onResult: (text, isFinal) {
        if (isFinal && text.trim().isNotEmpty) widget.onText(text.trim());
      },
    );
  }

  Future<void> _switchLang() async {
    final next = _lang == 'hi' ? 'en' : 'hi';
    setState(() => _lang = next);
    HapticFeedback.selectionClick();
    final p = await SharedPreferences.getInstance();
    await p.setString(_langKey, next);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return ValueListenableBuilder<bool>(
      valueListenable: DictateButton.engine.listening,
      builder: (context, listening, _) {
        final on = listening && _mine;
        if (!listening && _mine) _mine = false;
        return Tooltip(
          message: on ? l.lwListening : l.lwVoiceHint,
          child: GestureDetector(
            onLongPress: _switchLang,
            child: IconButton(
              onPressed: _toggle,
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    on ? Icons.mic_rounded : Icons.mic_none_rounded,
                    color: on ? brand.live : brand.inkMuted,
                  ),
                  Positioned(
                    right: -8,
                    bottom: -6,
                    child: Text(
                      _lang == 'hi' ? 'हि' : 'EN',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: on ? brand.live : brand.inkMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A big choice card: Product or Service, or a category tile.
class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.hue,
    this.dense = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final AstroHue? hue;
  final bool selected;
  final bool dense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return Material(
      color: selected ? accent.withValues(alpha: 0.08) : brand.tint,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.all(dense ? 14 : 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? accent : brand.hairline,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                HueIcon(
                  hue: hue ?? AstroPalette.career,
                  icon: icon,
                  size: dense ? 38 : 48,
                  iconSize: dense ? 18 : 24,
                ),
                SizedBox(width: dense ? 12 : 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          (dense
                                  ? theme.textTheme.titleSmall
                                  : theme.textTheme.titleMedium)
                              ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: brand.inkMuted,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: selected ? 1 : 0,
                child: Icon(Icons.check_circle_rounded, color: accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A "−  4  +" stepper (names in a sankalp).
class CountStepper extends StatelessWidget {
  const CountStepper({
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 50,
    super.key,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      decoration: BoxDecoration(
        color: brand.tint,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: brand.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
          IconButton(
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

/// What still needs doing on a step, from the server's check.
class ProblemBox extends StatelessWidget {
  const ProblemBox({required this.messages, super.key});

  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) return const SizedBox.shrink();
    final color = AstroPalette.fire.end;
    return Container(
      margin: const EdgeInsets.only(bottom: kFieldGap),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final m in messages)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline_rounded, size: 18, color: color),
                  const SizedBox(width: 8),
                  Expanded(child: Text(m)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
