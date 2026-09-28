import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/payments/razorpay_service.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/models/auto_recharge.dart';
import '../../data/wallet_repository.dart';
import '../cubit/wallet_cubit.dart';

/// Turn on automatic top-ups, or turn them off.
///
/// This asks someone to let us take money while they are not looking, so the
/// sheet says exactly what will happen, how much, and how often — and the
/// switch only goes on after their bank has agreed, never before.
Future<void> showAutoRechargeSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => const _AutoRechargeSheet(),
  );
}

class _AutoRechargeSheet extends StatefulWidget {
  const _AutoRechargeSheet();

  @override
  State<_AutoRechargeSheet> createState() => _AutoRechargeSheetState();
}

class _AutoRechargeSheetState extends State<_AutoRechargeSheet> {
  WalletRepository get _repo => getIt<WalletRepository>();

  AutoRecharge? _current;
  bool _loading = true;
  bool _busy = false;
  String? _error;

  int _amount = 500;
  int _threshold = 150;

  static const _amounts = [200, 500, 1000, 2000];
  static const _thresholds = [100, 150, 300];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final row = await _repo.autoRecharge();
      if (!mounted) return;
      setState(() {
        _current = row;
        if (row.amount > 0) _amount = row.amount.round();
        if (row.thresholdAmount > 0) _threshold = row.thresholdAmount.round();
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyError(e);
          _loading = false;
        });
      }
    }
  }

  /// Save the amounts, then send the customer to their bank to authorise the
  /// mandate. Nothing can be charged until that second step comes back.
  Future<void> _turnOn() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final user = getIt<AuthBloc>().state.user;
    try {
      await _repo.setAutoRecharge(
        amount: _amount,
        thresholdAmount: _threshold,
        // A day's ceiling, so a bad day costs a known amount.
        dailyCap: _amount * 4,
      );
      final order = await _repo.beginAutoRechargeMandate();
      final result = await getIt<RazorpayService>().checkout(
        order: order,
        appName: 'TalkAcharya',
        description: context.mounted
            ? context.l10n.walletAutoRechargeTitle
            : 'Auto top-up',
        contact: user?.phone,
        email: user?.email,
        recurring: true,
      );

      if (result is! RazorpaySuccess) {
        if (mounted) {
          setState(() {
            _busy = false;
            if (result is RazorpayFailure && !result.cancelled) {
              _error = result.message;
            }
          });
        }
        return;
      }

      // Razorpay returns the mandate under the payment id for UPI Autopay and
      // eMandate alike; the server treats it as opaque.
      final row = await _repo.completeAutoRechargeMandate(
        token: result.paymentId,
      );
      if (!mounted) return;
      await context.read<WalletCubit>().refreshBalance();
      if (!mounted) return;
      setState(() {
        _current = row;
        _busy = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = friendlyError(e);
        });
      }
    }
  }

  Future<void> _turnOff() async {
    setState(() => _busy = true);
    try {
      await _repo.disableAutoRecharge();
      if (mounted) {
        setState(() {
          _current = const AutoRecharge();
          _busy = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = friendlyError(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final armed = _current?.armed ?? false;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        4,
        20,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.walletAutoRechargeTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.walletAutoRechargeBody,
            style: theme.textTheme.bodyMedium?.copyWith(color: brand.inkMuted),
          ),
          const SizedBox(height: 16),

          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (armed) ...[
            _OnCard(row: _current!),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _busy ? null : _turnOff,
              child: Text(l.walletAutoRechargeTurnOff),
            ),
          ] else ...[
            if (_current?.stoppedByBank ?? false) ...[
              _Notice(text: l.walletAutoRechargeBankStopped),
              const SizedBox(height: 14),
            ],
            _Choice(
              label: l.walletAutoRechargeAmount,
              options: _amounts,
              selected: _amount,
              onPick: (v) => setState(() => _amount = v),
            ),
            const SizedBox(height: 14),
            _Choice(
              label: l.walletAutoRechargeWhen,
              options: _thresholds,
              selected: _threshold,
              onPick: (v) => setState(() => _threshold = v),
            ),
            const SizedBox(height: 16),
            // Said plainly, before they agree to it — not in a tooltip after.
            _Notice(
              text: l.walletAutoRechargeSummary(
                '₹$_amount',
                '₹$_threshold',
                '₹${_amount * 4}',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy ? null : _turnOn,
              style: FilledButton.styleFrom(minimumSize: const Size(0, 50)),
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l.walletAutoRechargeTurnOn),
            ),
          ],

          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12.5),
            ),
          ],
        ],
      ),
    );
  }
}

class _OnCard extends StatelessWidget {
  const _OnCard({required this.row});
  final AutoRecharge row;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: theme.colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l.walletAutoRechargeOn(
                '₹${row.amount.round()}',
                '₹${row.thresholdAmount.round()}',
              ),
              style: TextStyle(
                color: theme.colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.options,
    required this.selected,
    required this.onPick,
  });

  final String label;
  final List<int> options;
  final int selected;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final v in options)
              ChoiceChip(
                label: Text('₹$v'),
                selected: v == selected,
                onSelected: (_) => onPick(v),
              ),
          ],
        ),
      ],
    );
  }
}
