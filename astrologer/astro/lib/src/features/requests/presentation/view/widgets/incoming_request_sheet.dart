import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_sounds/talkacharya_sounds.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../core/util/money.dart';
import '../../../../../shared/widgets/cosmic.dart';
import '../../../../../shared/widgets/hue_widgets.dart';
import '../../../../consultations/data/consultation_api.dart';
import '../../../../consultations/data/models/consultation.dart';
import '../../../../consultations/presentation/widgets/consultation_style.dart';
import '../../../../consultations/presentation/widgets/shared_details.dart';
import '../../cubit/requests_cubit.dart';
import 'decline_reason_sheet.dart';
import 'request_card.dart';
import '../../../../../core/notifications/local_notifications.dart';
import '../../../../../core/utils/haptic_service.dart';

/// Full-width sheet shown when an `astro:` `consultation.requested` frame
/// arrives: countdown ring, who's asking, and Accept / Decline. Accept opens
/// the consultation room.
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
    backgroundColor: Colors.transparent,
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
  final _total = kAcceptTimeout.inSeconds;
  late int _left = _total;
  Timer? _timer;
  bool _ringing = true;
  bool _busy = false;
  Consultation? _detail;

  @override
  void initState() {
    super.initState();
    _alert();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _loadDetail();
  }

  void _tick() {
    if (!mounted) return;
    final at = _detail?.requestedAt;
    setState(() {
      // Prefer the server timestamp once known; otherwise count down locally.
      _left = at != null
          ? at.add(kAcceptTimeout).difference(DateTime.now()).inSeconds
          : _left - 1;
    });
    if (_left <= 0) {
      _timer?.cancel();
      context.read<RequestsCubit>().expireLocally(widget.consultationId);
      Navigator.of(context).pop();
    }
  }

  void _alert() {
    // The phone's ringtone + vibration (silent/vibrate mode respected) until the
    // astrologer acts or the request expires — like an incoming call.
    HapticService.heavy();
    AppSounds.startRinging();
    // If a push got here first and is ringing in the tray, this sheet is now
    // the one asking — two ringtones at once is worse than none.
    unawaited(getIt<LocalNotifications>().cancelIncomingCall());
  }

  void _stopAlert() {
    if (_ringing) AppSounds.stop();
    _ringing = false;
    unawaited(getIt<LocalNotifications>().cancelIncomingCall());
  }

  Future<void> _loadDetail() async {
    try {
      final c = await getIt<ConsultationApi>().detail(widget.consultationId);
      if (mounted) setState(() => _detail = c);
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopAlert();
    super.dispose();
  }

  Future<void> _accept() async {
    _stopAlert();
    setState(() => _busy = true);
    final router = GoRouter.of(context);
    final navigator = Navigator.of(context);
    final c = await context.read<RequestsCubit>().accept(widget.consultationId);
    if (!mounted) return;
    if (c == null) {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.requestsActionFailed)),
      );
      return;
    }
    navigator.pop();
    // Chat, voice and video all open the consultation room.
    unawaited(router.push<void>(Routes.chatRoom(c.id)));
  }

  Future<void> _decline() async {
    _stopAlert();
    final reason = await showDeclineReasonSheet(context);
    if (reason == null || !mounted) return;
    setState(() => _busy = true);
    await context.read<RequestsCubit>().reject(widget.consultationId, reason);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final ch = channelStyle(context, widget.channel);
    final name = _detail?.customerName ?? l.requestsCustomerFallback;
    final rate = double.tryParse(_detail?.rateSnapshot ?? '') ?? 0;
    final left = _left.clamp(0, _total);
    final urgent = left <= 20;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Stack(
        children: [
          const Positioned.fill(child: CosmicBackdrop()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox.square(
                    dimension: 112,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(end: left / _total),
                            duration: const Duration(milliseconds: 950),
                            builder: (_, v, _) => CircularProgressIndicator(
                              value: v,
                              strokeWidth: 5,
                              strokeCap: StrokeCap.round,
                              color: urgent ? brand.live : brand.glowAccent,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.10,
                              ),
                            ),
                          ),
                        ),
                        HueAvatar(name: name, hue: ch.hue, size: 76),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.requestsExpiresIn(left),
                    style: TextStyle(
                      color: urgent ? brand.live : brand.onCosmicMuted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.requestsNewTitle(ch.label.toLowerCase()),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: brand.onCosmicMuted,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: brand.onCosmic,
                    ),
                  ),
                  if (_detail?.shares.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SharedBadges(consultation: _detail!),
                    ),
                  if (rate > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(ch.icon, size: 14, color: brand.glowAccent),
                            const SizedBox(width: 6),
                            Text(
                              l.dashPerMin(
                                Money.format(rate, _detail!.currency),
                              ),
                              style: TextStyle(
                                color: brand.onCosmic,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.question.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Text(
                        widget.question,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: brand.onCosmic,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: brand.onCosmic,
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _busy ? null : _decline,
                          child: Text(l.requestsDecline),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: brand.online,
                          ),
                          onPressed: _busy ? null : _accept,
                          icon: _busy
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(ch.icon),
                          label: Text(l.requestsAccept),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
