import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_call/talkacharya_call.dart';

import '../../../../core/l10n/l10n.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../data/consultation_api.dart';
import '../../data/consultation_repository.dart';
import '../../data/pending_share.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/money.dart';
import '../../../wallet/presentation/cubit/wallet_cubit.dart';

/// Bottom sheet to start a consultation (text chat, voice or video call) with an
/// astrologer.
Future<void> showBookConsultationSheet(
  BuildContext context, {
  required String astrologerId,
  required String astrologerName,
  required double ratePerMinute,
  required String currency,
  String channel = 'chat',
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
      ratePerMinute: ratePerMinute,
      currency: currency,
      channel: channel,
    ),
  );
}

class _BookForm extends StatefulWidget {
  const _BookForm({
    required this.astrologerId,
    required this.ratePerMinute,
    required this.currency,
    required this.channel,
  });
  final String astrologerId;
  final double ratePerMinute;
  final String currency;
  final String channel;

  bool get isCall => channel != 'chat';
  bool get isVideo => channel == 'video';

  @override
  State<_BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<_BookForm> {
  final _question = TextEditingController();
  String? _birthProfileId;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final pending = getIt<PendingShare>();
    _birthProfileId =
        pending.birthProfileId ??
        context.read<BirthProfilesCubit>().state.activeProfileId;
  }

  @override
  void dispose() {
    _question.dispose();
    super.dispose();
  }

  /// Shows why we stopped, with a shortcut to Settings when the answer is final.
  bool _allowed(
    ScaffoldMessengerState messenger,
    MediaPermission result,
    String body,
  ) {
    if (result == MediaPermission.granted) return true;
    messenger.showSnackBar(
      SnackBar(
        content: Text(body),
        action: result == MediaPermission.permanentlyDenied
            ? SnackBarAction(
                label: context.l10n.callOpenSettings,
                onPressed:
                    const PermissionHandlerCallPermissions().openSettings,
              )
            : null,
      ),
    );
    return false;
  }

  Future<void> _start() async {
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    if (widget.isCall) {
      // ask BEFORE paging the astrologer — no silent calls, no blind video ones
      const permissions = PermissionHandlerCallPermissions();
      final mic = await permissions.requestMicrophone();
      if (!mounted) return;
      if (!_allowed(messenger, mic, l.callMicBody)) return;

      if (widget.isVideo) {
        final camera = await permissions.requestCamera();
        if (!mounted) return;
        if (!_allowed(messenger, camera, l.callCameraBody)) return;
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
      Navigator.pop(context);
      router.push('/consultations/${c.id}').ignore();
    } on InsufficientBalance catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showRecharge(e);
    } on AstrologerBusy {
      if (!mounted) return;
      setState(() => _submitting = false);
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'This astrologer is busy right now. Try again shortly.',
          ),
        ),
      );
    } on AstrologerOffline catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'This astrologer is offline. Please try again later.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      messenger.showSnackBar(SnackBar(content: Text(friendlyError(e))));
    }
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
    return SingleChildScrollView(
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
                      onSelected: (_) => setState(() => _birthProfileId = p.id),
                    ),
                  ChoiceChip(
                    label: const Text('Don’t share'),
                    selected: _birthProfileId == null,
                    onSelected: (_) => setState(() => _birthProfileId = null),
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
