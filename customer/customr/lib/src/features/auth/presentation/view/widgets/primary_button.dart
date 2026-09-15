import 'package:flutter/material.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../../../core/utils/haptic_service.dart';

const _gold = Color(0xFFC5A358);

/// Gold gradient CTA for the auth screens. Disabled + loading states dim it.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final active = onPressed != null && !loading;

    return Pressable(
      haptic: active ? HapticLevel.medium : HapticLevel.none,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 56,
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(colors: [Color(0xFFF6D695), _gold])
              : const LinearGradient(colors: [Colors.white10, Colors.white10]),
          borderRadius: BorderRadius.circular(28),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: loading ? null : onPressed,
            borderRadius: BorderRadius.circular(28),
            child: Center(
              child: loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.black87,
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: active ? Colors.black87 : Colors.white38,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
