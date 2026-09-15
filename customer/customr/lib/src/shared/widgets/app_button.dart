import 'package:flutter/material.dart';
import 'pressable.dart';
import '../../core/utils/haptic_service.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.haptic = HapticLevel.medium,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final HapticLevel haptic;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      haptic: loading ? HapticLevel.none : haptic,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Text(label),
      ),
    );
  }
}
