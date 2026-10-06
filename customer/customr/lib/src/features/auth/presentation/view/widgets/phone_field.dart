import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Phone-number field for the sign-in screen: a fixed 🇮🇳 +91 prefix and a
/// 10-digit entry, drawn in the app's theme. The [controller] holds the raw
/// digits.
class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({
    required this.controller,
    required this.onSubmit,
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback? onSubmit;
  final bool enabled;

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) setState(() => _focused = _focusNode.hasFocus);
    });
    widget.controller.addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;
    final complete = widget.controller.text.length == 10;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.only(left: 16, right: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _focused ? scheme.primary : brand.hairline,
          width: _focused ? 1.5 : 1,
        ),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.14),
                  blurRadius: 14,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          const Text('🇮🇳', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Text(
            '+91',
            style: TextStyle(
              color: brand.ink,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            width: 1,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: brand.hairline,
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: true,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              maxLength: 10,
              cursorColor: scheme.primary,
              style: TextStyle(
                color: brand.ink,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                filled: false,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: '00000 00000',
                hintStyle: TextStyle(
                  color: brand.inkMuted.withValues(alpha: 0.5),
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onSubmitted: (_) => widget.onSubmit?.call(),
            ),
          ),
          AnimatedScale(
            scale: complete ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(
                Icons.check_circle_rounded,
                color: scheme.primary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
