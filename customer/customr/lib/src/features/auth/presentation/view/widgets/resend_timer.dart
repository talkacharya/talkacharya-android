import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../../core/l10n/l10n.dart';

/// "Resend code" control with a cooldown. Pass a new [resetToken] (e.g. the
/// challenge expiry) to restart the countdown after a fresh code is sent.
class ResendTimer extends StatefulWidget {
  const ResendTimer({
    required this.onResend,
    required this.resetToken,
    this.seconds = 45,
    this.enabled = true,
    super.key,
  });

  final VoidCallback onResend;
  final Object resetToken;
  final int seconds;
  final bool enabled;

  @override
  State<ResendTimer> createState() => _ResendTimerState();
}

class _ResendTimerState extends State<ResendTimer> {
  Timer? _timer;
  int _remaining = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(covariant ResendTimer old) {
    super.didUpdateWidget(old);
    if (old.resetToken != widget.resetToken) _start();
  }

  void _start() {
    _timer?.cancel();
    setState(() => _remaining = widget.seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _remaining -= 1);
      if (_remaining <= 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;

    if (_remaining > 0) {
      return Text(
        l.authResendIn('0:${_remaining.toString().padLeft(2, '0')}'),
        style: TextStyle(color: brand.inkMuted, fontSize: 13),
      );
    }

    return TextButton(
      onPressed: widget.enabled
          ? () {
              widget.onResend();
              _start();
            }
          : null,
      child: Text(
        l.authResendCode,
        style: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
