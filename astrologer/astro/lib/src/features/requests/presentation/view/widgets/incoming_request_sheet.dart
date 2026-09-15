import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../consultations/data/consultation_api.dart';

/// Full-width sheet shown when an `astro:` `consultation.requested` frame arrives.
/// Countdown ring + Accept / Decline. Accept routes into the session.
Future<void> showIncomingRequestSheet(
  BuildContext context, {
  required String consultationId,
  required String channel,
  required String question,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    builder: (_) => _IncomingRequestSheet(
      consultationId: consultationId,
      channel: channel,
      question: question,
    ),
  );
}

class _IncomingRequestSheet extends StatefulWidget {
  const _IncomingRequestSheet({
    required this.consultationId,
    required this.channel,
    required this.question,
  });
  final String consultationId;
  final String channel;
  final String question;

  @override
  State<_IncomingRequestSheet> createState() => _IncomingRequestSheetState();
}

class _IncomingRequestSheetState extends State<_IncomingRequestSheet> {
  static const _timeout = 90;
  int _left = _timeout;
  Timer? _timer;
  bool _busy = false;
  String _customer = 'A customer';

  Timer? _buzz;

  @override
  void initState() {
    super.initState();
    _alert();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _left -= 1);
      if (_left <= 0) {
        t.cancel();
        if (mounted) Navigator.of(context).pop();
      }
    });
    _loadDetail();
  }

  void _alert() {
    // A short repeating buzz + alert tone until the astrologer acts, so an
    // incoming request is impossible to miss when the app is foregrounded.
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
    var beats = 0;
    _buzz = Timer.periodic(const Duration(milliseconds: 1400), (t) {
      if (!mounted || beats++ >= 6) {
        t.cancel();
        return;
      }
      HapticFeedback.mediumImpact();
      SystemSound.play(SystemSoundType.alert);
    });
  }

  Future<void> _loadDetail() async {
    try {
      final c = await getIt<ConsultationApi>().detail(widget.consultationId);
      if (mounted) setState(() => _customer = c.customerName);
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    _buzz?.cancel();
    super.dispose();
  }

  Future<void> _accept() async {
    _buzz?.cancel();
    setState(() => _busy = true);
    try {
      await getIt<ConsultationApi>().accept(widget.consultationId);
      if (!mounted) return;
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      // chat and voice both open the consultation room; it renders the call
      // screen for voice and connects as soon as the client picks up
      context.go('/chats/${widget.consultationId}');
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
        Navigator.of(context).maybePop();
      }
    }
  }

  Future<void> _decline() async {
    _buzz?.cancel();
    setState(() => _busy = true);
    try {
      await getIt<ConsultationApi>().reject(
        widget.consultationId,
        'unavailable',
      );
    } catch (_) {}
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    value: _left / _timeout,
                    strokeWidth: 4,
                  ),
                ),
                Text('$_left', style: theme.textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'New ${widget.channel} request',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(_customer, style: theme.textTheme.bodyMedium),
            if (widget.question.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(widget.question),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _busy ? null : _decline,
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _busy ? null : _accept,
                    child: _busy
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Accept'),
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
