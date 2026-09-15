import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _gold = Color(0xFFC5A358);

/// Clean phone-number field for the dark auth theme: a fixed 🇮🇳 +91 prefix and
/// a 10-digit entry. Fully self-styled so it never inherits the app's light
/// input theme. The [controller] holds the raw digits.
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
    final complete = widget.controller.text.length == 10;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.only(left: 16, right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _focused ? _gold : Colors.white.withValues(alpha: 0.12),
          width: _focused ? 1.5 : 1,
        ),
        boxShadow: _focused
            ? [BoxShadow(color: _gold.withValues(alpha: 0.15), blurRadius: 14)]
            : null,
      ),
      child: Row(
        children: [
          const Text('🇮🇳', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          const Text(
            '+91',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            width: 1,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: Colors.white.withValues(alpha: 0.12),
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
              cursorColor: _gold,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                counterText: '',
                filled: false,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 18),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: '98765 43210',
                hintStyle: TextStyle(
                  color: Colors.white24,
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
            child: const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.check_circle_rounded, color: _gold, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
