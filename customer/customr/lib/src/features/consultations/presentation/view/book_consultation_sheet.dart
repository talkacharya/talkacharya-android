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

/// Bottom sheet to start a consultation (text chat or voice call) with an astrologer.
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
    title: channel == 'voice'
        ? l.callBookTitle(astrologerName)
        : 'Chat with $astrologerName',
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
    _birthProfileId = context.read<BirthProfilesCubit>().state.activeProfileId;
  }

  @override
  void dispose() {
    _question.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    if (widget.isCall) {
      // ask for the mic BEFORE paging the astrologer — no silent calls
      final mic = await const PermissionHandlerCallPermissions()
          .requestMicrophone();
      if (!mounted) return;
      if (mic != MicPermission.granted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l.callMicBody),
            action: mic == MicPermission.permanentlyDenied
                ? SnackBarAction(
                    label: l.callOpenSettings,
                    onPressed:
                        const PermissionHandlerCallPermissions().openSettings,
                  )
                : null,
          ),
        );
        return;
      }
    }
    setState(() => _submitting = true);
    final repo = getIt<ConsultationRepository>();
    try {
      final c = await repo.request(
        astrologerId: widget.astrologerId,
        channel: widget.channel,
        birthProfileId: _birthProfileId,
        question: _question.text.trim(),
      );
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
      messenger.showSnackBar(SnackBar(content: Text('Could not start: $e')));
    }
  }

  void _showRecharge(InsufficientBalance e) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Low balance'),
        content: Text(
          'You need at least ${e.currency} ${e.required} to start '
          '(you have ${e.currency} ${e.available}). Add money to your wallet '
          'and try again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // close the sheet too
              context.push('/wallet');
            },
            child: const Text('Recharge'),
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
                        ? context.l10n.callBookBilling
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
