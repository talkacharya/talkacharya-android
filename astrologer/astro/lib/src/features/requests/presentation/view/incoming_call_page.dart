import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/notifications/local_notifications.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../cubit/requests_cubit.dart';

/// The whole screen for a consultation that is ringing: who is asking, for
/// what, and Accept / Decline — what a locked phone opens onto when a request
/// wakes it, instead of the app's last page with a notification over it.
///
/// It rides on the ringing notification rather than replacing it: the
/// notification keeps the ringtone going, and this screen closes itself the
/// moment that notification is gone (answered elsewhere, withdrawn, timed out).
class IncomingCallPage extends StatefulWidget {
  const IncomingCallPage({required this.data, super.key});

  /// The ringing push's data: `consultation_id`, `channel`, `customer_name`,
  /// and `test` for a ring from the call setup page.
  final Map<String, dynamic> data;

  /// The request this screen is up for, so nothing rings for it twice.
  static String? showingFor;

  @override
  State<IncomingCallPage> createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage> {
  Timer? _watch;
  bool _busy = false;
  bool _closed = false;

  String get _id => '${widget.data['consultation_id'] ?? ''}';
  String get _channel => '${widget.data['channel'] ?? 'chat'}';
  bool get _isTest => widget.data['test'] == '1';

  LocalNotifications get _local => getIt<LocalNotifications>();

  @override
  void initState() {
    super.initState();
    IncomingCallPage.showingFor = _id;
    if (_id.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _close());
      return;
    }
    _watch = Timer.periodic(const Duration(seconds: 1), (_) => _stillRinging());
  }

  @override
  void dispose() {
    _watch?.cancel();
    if (IncomingCallPage.showingFor == _id) IncomingCallPage.showingFor = null;
    super.dispose();
  }

  Future<void> _stillRinging() async {
    if (_busy) return;
    final ringing = await _local.ringingCall();
    if ('${ringing?['consultation_id'] ?? ''}' != _id) _close();
  }

  void _close() {
    if (_closed || !mounted) return;
    _closed = true;
    _watch?.cancel();
    Navigator.of(context).pop();
  }

  Future<void> _accept() async {
    if (_busy) return;
    setState(() => _busy = true);
    unawaited(HapticFeedback.mediumImpact());
    final router = GoRouter.of(context);
    if (_isTest) {
      // Nobody is calling: it reached the phone, which was the question.
      unawaited(_local.cancelIncomingCall());
      unawaited(CallTelecom.declineIncoming(_id));
      _close();
      router.go(Routes.callSetupTested);
      return;
    }
    final cubit = getIt<RequestsCubit>();
    final accepted = await cubit.accept(_id);
    unawaited(_local.cancelIncomingCall());
    if (!mounted) return;
    if (accepted == null) {
      // Withdrawn or expired while it rang.
      final error = cubit.state.error;
      if (error != null && error.isNotEmpty) showToast(context, error);
      _close();
      return;
    }
    _close();
    unawaited(router.push<void>(Routes.chatRoom(accepted.id)));
  }

  Future<void> _decline() async {
    if (_busy) return;
    setState(() => _busy = true);
    unawaited(HapticFeedback.mediumImpact());
    unawaited(_local.cancelIncomingCall());
    if (_isTest) {
      unawaited(CallTelecom.declineIncoming(_id));
    } else {
      await getIt<RequestsCubit>().reject(_id, 'declined');
    }
    _close();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final ch = channelStyle(context, _channel);
    final name = '${widget.data['customer_name'] ?? ''}'.trim();
    final who = _isTest
        ? l.incomingCallTest
        : name.isEmpty
        ? l.incomingCallCustomer
        : name;

    return PopScope(
      // It goes away by being answered, declined or expiring — not by Back.
      canPop: _closed,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: Stack(
            children: [
              const Positioned.fill(child: CosmicBackdrop()),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(ch.icon, size: 18, color: brand.onCosmicMuted),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              l.incomingCallKind(ch.label),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: brand.onCosmicMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: BrandColors.goldGradient,
                          ),
                        ),
                        child: HueAvatar(
                          name: who,
                          hue: AstroPalette.forId(who),
                          size: 128,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        who,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: brand.onCosmic,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isTest ? l.incomingCallTestHint : l.incomingCallHint,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: brand.onCosmicMuted,
                        ),
                      ),
                      const Spacer(flex: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _RoundAction(
                            label: l.incomingCallDecline,
                            icon: Icons.call_end_rounded,
                            color: const Color(0xFFE5484D),
                            onTap: _busy ? null : _decline,
                          ),
                          _RoundAction(
                            label: l.incomingCallAccept,
                            icon: _channel == 'chat'
                                ? Icons.chat_bubble_rounded
                                : _channel == 'video'
                                ? Icons.videocam_rounded
                                : Icons.call_rounded,
                            color: const Color(0xFF30A46C),
                            busy: _busy,
                            onTap: _busy ? null : _accept,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.busy = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color,
          shape: const CircleBorder(),
          elevation: 6,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox.square(
              dimension: 76,
              child: Center(
                child: busy
                    ? const SizedBox.square(
                        dimension: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : Icon(icon, size: 34, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(color: brand.onCosmic, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
