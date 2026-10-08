import '../../data/models/consultation.dart';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import '../../../../core/utils/haptic_service.dart';

import '../../../../core/l10n/l10n.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/app_snack.dart';
import '../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../data/consultation_api.dart';
import '../../data/consultation_repository.dart';
import 'waitlist_sheets.dart';
import '../../data/pending_share.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/money.dart';
import '../../../wallet/presentation/cubit/wallet_cubit.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Bottom sheet to start a consultation (text chat, voice or video call) with an
/// astrologer.
Future<void> showBookConsultationSheet(
  BuildContext context, {
  required String astrologerId,
  required String astrologerName,
  required double ratePerMinute,
  required String currency,
  String channel = 'chat',
  int offerPercent = 0,
  ValueChanged<Consultation>? onStarted,
}) {
  context.read<BirthProfilesCubit>().load();
  final l = context.l10n;
  return showAppSheet<void>(
    context: context,
    title: switch (channel) {
      'voice' => l.callBookTitle(astrologerName),
      'video' => l.callVideoBookTitle(astrologerName),
      _ => 'Chat with $astrologerName',
    },
    builder: (context) => _BookForm(
      astrologerId: astrologerId,
      astrologerName: astrologerName,
      ratePerMinute: ratePerMinute,
      currency: currency,
      channel: channel,
      offerPercent: offerPercent,
      onStarted: onStarted,
    ),
  );
}

class _BookForm extends StatefulWidget {
  const _BookForm({
    required this.astrologerId,
    required this.astrologerName,
    required this.ratePerMinute,
    required this.currency,
    required this.channel,
    this.offerPercent = 0,
    this.onStarted,
  });
  final String astrologerId;
  final String astrologerName;
  final double ratePerMinute;
  final String currency;
  final String channel;

  /// The astrologer's running offer, already taken off [ratePerMinute].
  final int offerPercent;

  /// Where the new session goes. Null means open the room for it; a room that
  /// is already showing this thread passes a handler instead and takes the
  /// session on in place.
  final ValueChanged<Consultation>? onStarted;

  bool get isCall => channel != 'chat';
  bool get isVideo => channel == 'video';

  @override
  State<_BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<_BookForm> {
  final _question = TextEditingController();
  final _confetti = ConfettiController(
    duration: const Duration(milliseconds: 1200),
  );
  String? _birthProfileId;
  bool _submitting = false;

  /// Minutes the welcome offer gives back on this booking; 0 when it is not
  /// this customer's first.
  int _welcomeMinutes = 0;

  @override
  void initState() {
    super.initState();
    final pending = getIt<PendingShare>();
    _birthProfileId =
        pending.birthProfileId ??
        context.read<BirthProfilesCubit>().state.activeProfileId;
    getIt<ConsultationRepository>().welcomeOfferMinutes().then((minutes) {
      if (mounted && minutes > 0) setState(() => _welcomeMinutes = minutes);
    });
  }

  @override
  void dispose() {
    _question.dispose();
    _confetti.dispose();
    super.dispose();
  }

  /// Shows why we stopped, with a shortcut to Settings when the answer is final.
  bool _allowed(MediaPermission result, String body) {
    if (result == MediaPermission.granted) return true;
    AppSnack.showTop(
      context,
      body,
      type: SnackType.warning,
      actionLabel: result == MediaPermission.permanentlyDenied
          ? context.l10n.callOpenSettings
          : null,
      onAction: result == MediaPermission.permanentlyDenied
          ? const PermissionHandlerCallPermissions().openSettings
          : null,
    );
    return false;
  }

  Future<void> _start() async {
    final router = GoRouter.of(context);
    final l = context.l10n;
    if (widget.isCall) {
      // ask BEFORE paging the astrologer — no silent calls, no blind video ones
      const permissions = PermissionHandlerCallPermissions();
      final mic = await permissions.requestMicrophone();
      if (!mounted) return;
      if (!_allowed(mic, l.callMicBody)) return;

      if (widget.isVideo) {
        final camera = await permissions.requestCamera();
        if (!mounted) return;
        if (!_allowed(camera, l.callCameraBody)) return;
      }
    }
    setState(() => _submitting = true);
    final repo = getIt<ConsultationRepository>();
    final pending = getIt<PendingShare>();
    try {
      final c = await repo.request(
        astrologerId: widget.astrologerId,
        channel: widget.channel,
        birthProfileId: pending.matchId != null ? null : _birthProfileId,
        matchId: pending.matchId,
        question: _question.text.trim(),
      );
      pending.clear();
      if (!mounted) return;

      HapticService.heavy();
      _confetti.play();
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;

      Navigator.pop(context);
      final started = widget.onStarted;
      if (started != null) {
        started(c);
      } else {
        router.push('/consultations/${c.id}').ignore();
      }
    } on InsufficientBalance catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showRecharge(e);
    } on AstrologerBusy {
      if (!mounted) return;
      setState(() => _submitting = false);
      await _offerWaitlist();
    } on AstrologerOffline catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      AppSnack.showTop(
        context,
        e.message ?? 'This astrologer is offline. Please try again later.',
        type: SnackType.warning,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      AppSnack.showTop(context, friendlyError(e), type: SnackType.error);
    }
  }

  /// The astrologer is with someone else: offer a place in line instead of a
  /// dead end.
  Future<void> _offerWaitlist() async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final entry = await showJoinWaitlistSheet(
      context,
      astrologerId: widget.astrologerId,
      astrologerName: widget.astrologerName,
      channels: [
        (
          channel: widget.channel,
          priceLabel: context.l10n.astroPerMinute(
            Money.format(widget.ratePerMinute, widget.currency, locale: locale),
          ),
        ),
      ],
    );
    // In line now: there is nothing left to book here.
    if (entry != null && mounted) Navigator.pop(context);
  }

  void _showRecharge(InsufficientBalance e) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    String money(String raw) =>
        Money.format(double.tryParse(raw) ?? 0, e.currency, locale: locale);

    // The server's `available` is balance minus live reservations and can come
    // back negative; show the floor, and name the reservation separately rather
    // than asking someone to make sense of "you have −₹1,472".
    final available = double.tryParse(e.available) ?? 0;
    final held = context.read<WalletCubit>().state.primaryFor(e.currency)?.held;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.bookLowBalanceTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.bookLowBalanceBody(
                money(e.required),
                Money.format(
                  available > 0 ? available : 0,
                  e.currency,
                  locale: locale,
                ),
              ),
            ),
            if (held != null && held > 0.005) ...[
              const SizedBox(height: 8),
              Text(
                l.bookLowBalanceHeld(
                  Money.format(held, e.currency, locale: locale),
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.commonNotNow),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // close the sheet too
              context.push('/wallet');
            },
            child: Text(l.walletAddMoney),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.isCall
                          ? Icons.phone_in_talk_rounded
                          : Icons.chat_bubble_outline_rounded,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.isCall
                            ? (widget.isVideo
                                  ? context.l10n.callVideoBookBilling
                                  : context.l10n.callBookBilling)
                            : 'Text chat · billed per minute',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      '${widget.currency} ${widget.ratePerMinute.toStringAsFixed(0)}/min',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              if (_welcomeMinutes > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.card_giftcard_rounded,
                        size: 20,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.bookWelcomeTitle(_welcomeMinutes),
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              context.l10n.bookWelcomeBody,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (widget.offerPercent > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.local_offer_rounded,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        context.l10n.bookOfferApplied(widget.offerPercent),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              if (getIt<PendingShare>().label.isNotEmpty) ...[
                _SharingHint(label: getIt<PendingShare>().label),
                const SizedBox(height: 12),
              ],
              Text('Birth profile', style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              BlocBuilder<BirthProfilesCubit, BirthProfilesState>(
                builder: (context, state) {
                  if (state.profiles.isEmpty) {
                    return OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/select-profile/new');
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add a birth profile first'),
                    );
                  }
                  return Wrap(
                    spacing: 8,
                    children: [
                      for (final p in state.profiles)
                        ChoiceChip(
                          label: Text(p.displayName),
                          selected: _birthProfileId == p.id,
                          onSelected: (_) =>
                              setState(() => _birthProfileId = p.id),
                        ),
                      ChoiceChip(
                        label: const Text('Don’t share'),
                        selected: _birthProfileId == null,
                        onSelected: (_) =>
                            setState(() => _birthProfileId = null),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _question,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Your question (optional)',
                  hintText: 'What would you like guidance on?',
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _submitting ? null : _start,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: _submitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : Text(
                        widget.isCall
                            ? context.l10n.callBookCta(
                                '${widget.currency} ${widget.ratePerMinute.toStringAsFixed(0)}',
                              )
                            : 'Start chat · ${widget.currency} ${widget.ratePerMinute.toStringAsFixed(0)}/min',
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                'You’re only charged for the minutes you talk. End anytime.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -20,
          child: ConfettiWidget(
            confettiController: _confetti,
            blastDirection: math.pi / 2,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 15,
            minBlastForce: 8,
            gravity: 0.2,
            colors: const [
              Color(0xFFEA6A1E),
              Color(0xFFF2A93B),
              Color(0xFFE63E9B),
              Color(0xFF2E9E4F),
            ],
          ),
        ),
      ],
    );
  }
}

/// "Sharing X with the astrologer" hint, shown when the customer came here from
/// a birth profile or a kundali match.
class _SharingHint extends StatelessWidget {
  const _SharingHint({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 18,
            color: scheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${context.l10n.shareWithAstrologer}: $label',
              style: TextStyle(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
