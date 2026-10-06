import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../../wallet/data/wallet_repository.dart';
import '../../../../wallet/presentation/cubit/recharge_cubit.dart';
import '../../../../wallet/presentation/cubit/wallet_cubit.dart';
import '../../../../wallet/presentation/view/recharge_sheet.dart';
import '../../../data/models/consultation.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';
/// Two amounts and a way out, right where the warning is.
///
/// Mid-consultation the clock is running and the customer is trying to listen
/// to someone at the same time. Asking them to open a sheet and type a number
/// is how a call ends while they are still doing arithmetic — so the amounts
/// are precomputed from the rate and say what they buy, in minutes.
class QuickTopUp extends StatelessWidget {
  const QuickTopUp({required this.consultation, super.key});

  final Consultation consultation;

  /// Amounts worth roughly [minutes] of this consultation, rounded to
  /// something a person would actually choose.
  static int amountFor(double ratePerMinute, int minutes, {int minimum = 50}) {
    final raw = ratePerMinute * minutes;
    final step = raw <= 200 ? 50 : 100;
    final rounded = (raw / step).ceil() * step;
    return math.max(rounded, minimum);
  }

  @override
  Widget build(BuildContext context) {
    final rate = double.tryParse(consultation.rateSnapshot) ?? 0;
    if (rate <= 0) return const SizedBox.shrink();

    final min = getIt<WalletRepository>().minRecharge.round();
    final options = <int>{
      amountFor(rate, 10, minimum: min),
      amountFor(rate, 25, minimum: min),
    }.toList()..sort();

    return BlocProvider(
      create: (_) => RechargeCubit(
        repo: getIt<WalletRepository>(),
        razorpay: getIt(),
        wallet: context.read<WalletCubit>(),
      ),
      child: _QuickTopUpBar(
        consultation: consultation,
        rate: rate,
        options: options,
      ),
    );
  }
}

class _QuickTopUpBar extends StatelessWidget {
  const _QuickTopUpBar({
    required this.consultation,
    required this.rate,
    required this.options,
  });

  final Consultation consultation;
  final double rate;
  final List<int> options;

  Future<void> _pay(BuildContext context, int amount) async {
    final l10n = context.l10n;
    final user = getIt<AuthBloc>().state.user;
    final messenger = ScaffoldMessenger.of(context);
    await context.read<RechargeCubit>().start(
      amount: amount,
      currency: consultation.currency,
      appName: 'TalkAcharya',
      description: l10n.roomAddMoney,
      contact: user?.phone,
      email: user?.email,
    );
    if (!context.mounted) return;
    final state = context.read<RechargeCubit>().state;
    if (state.status == RechargeStatus.failed && !state.cancelled) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(state.message ?? l10n.commonSomethingWentWrong),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final l10n = context.l10n;
    final busy = context.select(
      (RechargeCubit c) =>
          c.state.status == RechargeStatus.creatingOrder ||
          c.state.status == RechargeStatus.checkout ||
          c.state.status == RechargeStatus.confirming,
    );

    return Material(
      color: brand.tint,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: Row(
          children: [
            for (final amount in options) ...[
              Expanded(
                child: FilledButton(
                  onPressed: busy ? null : () => _pay(context, amount),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  ),
                  child: FittedBox(
                    child: Text(
                      // "₹200 · 10 min" — the minutes are the reason anyone
                      // taps this, so they are not the small print.
                      l10n.roomTopUpOption(
                        consultation.currency,
                        amount,
                        (amount / rate).floor(),
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            TextButton(
              onPressed: busy ? null : () => showRechargeSheet(context),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                foregroundColor: brand.onTint,
              ),
              child: Text(l10n.roomTopUpMore),
            ),
          ],
        ),
      ),
    );
  }
}
