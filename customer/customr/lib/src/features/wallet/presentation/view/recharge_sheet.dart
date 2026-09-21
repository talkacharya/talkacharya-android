import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/payments/razorpay_service.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/wallet_repository.dart';
import '../cubit/recharge_cubit.dart';
import '../cubit/wallet_cubit.dart';
import '../../../../core/utils/haptic_service.dart';

/// Opens the recharge bottom sheet. Returns when it closes.
Future<void> showRechargeSheet(BuildContext context, {int? initialAmount}) {
  final walletCubit = context.read<WalletCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => BlocProvider(
      create: (_) => RechargeCubit(
        repo: getIt<WalletRepository>(),
        razorpay: getIt<RazorpayService>(),
        wallet: walletCubit,
      ),
      child: _RechargeSheet(initialAmount: initialAmount),
    ),
  );
}

class _RechargeSheet extends StatefulWidget {
  const _RechargeSheet({this.initialAmount});
  final int? initialAmount;

  @override
  State<_RechargeSheet> createState() => _RechargeSheetState();
}

class _RechargeSheetState extends State<_RechargeSheet> {
  late final TextEditingController _amount = TextEditingController(
    text: widget.initialAmount?.toString() ?? '',
  );
  final _confetti = ConfettiController(duration: const Duration(seconds: 1));
  int? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialAmount;
  }

  @override
  void dispose() {
    _amount.dispose();
    _confetti.dispose();
    super.dispose();
  }

  int get _value => int.tryParse(_amount.text.trim()) ?? 0;

  void _pay() {
    final l = context.l10n;
    final min = getIt<WalletRepository>().minRecharge.round();
    if (_value < min) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.rechargeMinAmount(Money.format(min, _currency))),
        ),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    final user = context.read<AuthBloc>().state.user;
    context.read<RechargeCubit>().start(
      amount: _value,
      currency: _currency,
      appName: l.appName,
      description: l.rechargeChooseAmount,
      contact: user?.phone,
      email: user?.email.isNotEmpty == true ? user?.email : null,
    );
  }

  String get _currency =>
      context.read<AuthBloc>().state.user?.preferredCurrency ?? 'INR';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RechargeCubit, RechargeState>(
      listener: (context, state) {
        if (state.status == RechargeStatus.success) {
          HapticService.medium();
          _confetti.play();
        } else if (state.status == RechargeStatus.failed && !state.cancelled) {
          HapticService.heavy();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 4,
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOut,
                child: _body(context, state),
              ),
              ConfettiWidget(
                confettiController: _confetti,
                blastDirection: math.pi / 2,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.05,
                numberOfParticles: 14,
                maxBlastForce: 14,
                minBlastForce: 6,
                gravity: 0.25,
                colors: const [
                  Color(0xFFEA6A1E),
                  Color(0xFFF2A93B),
                  Color(0xFF2E9E4F),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, RechargeState state) {
    return switch (state.status) {
      RechargeStatus.idle => _picker(context),
      RechargeStatus.creatingOrder || RechargeStatus.checkout => _pending(
        context,
        context.l10n.rechargeOpeningCheckout,
      ),
      RechargeStatus.confirming => _pending(
        context,
        context.l10n.rechargeConfirming,
      ),
      RechargeStatus.success => _success(context, state),
      RechargeStatus.failed => _failed(context, state),
    };
  }

  Widget _picker(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final packs = context.watch<WalletCubit>().state.packs.value?.packs ?? [];
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Column(
      key: const ValueKey('picker'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.rechargeChooseAmount, style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        TextField(
          controller: _amount,
          autofocus: widget.initialAmount == null,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            prefixText: '${Money.symbol(_currency)} ',
            prefixStyle: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            hintText: '0',
          ),
          onChanged: (_) => setState(() => _selected = null),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final p in packs)
              ChoiceChip(
                selected: _selected == p.amount,
                showCheckmark: false,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(Money.format(p.amount, _currency, locale: locale)),
                    if (p.hasBonus) ...[
                      const SizedBox(width: 4),
                      Text(
                        '+${Money.format(p.bonus, _currency, locale: locale)}',
                        style: const TextStyle(
                          color: Color(0xFF2E9E4F),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
                onSelected: (_) => setState(() {
                  _selected = p.amount;
                  _amount.text = '${p.amount}';
                }),
              ),
          ],
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _value > 0 ? _pay : null,
          child: Text(
            _value > 0
                ? l.rechargePayAmount(
                    Money.format(_value, _currency, locale: locale),
                  )
                : l.walletAddMoney,
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_rounded,
                size: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 5),
              Text(
                l.walletSecuredBy,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pending(BuildContext context, String message) {
    return Padding(
      key: ValueKey('pending$message'),
      padding: const EdgeInsets.symmetric(vertical: 44),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _success(BuildContext context, RechargeState state) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Padding(
      key: const ValueKey('success'),
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 420),
            curve: Curves.elasticOut,
            builder: (context, t, child) =>
                Transform.scale(scale: t.clamp(0.0, 1.2), child: child),
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFE4F0E7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF2E7D46),
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.rechargeSuccessTitle(
              Money.format(state.amount ?? 0, state.currency, locale: locale),
            ),
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            state.pendingWebhook || state.newBalance == null
                ? l.rechargeCreditedSoon
                : l.rechargeNewBalance(
                    Money.format(
                      state.newBalance!,
                      state.currency,
                      locale: locale,
                    ),
                  ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.commonDone),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(Routes.walletTransactions);
            },
            child: Text(l.rechargeViewTransaction),
          ),
        ],
      ),
    );
  }

  Widget _failed(BuildContext context, RechargeState state) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      key: const ValueKey('failed'),
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: context.brand.live.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close_rounded,
              color: context.brand.live,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(l.rechargeFailedTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            l.rechargeNotCharged,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (state.message != null && state.message!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              state.message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 22),
          FilledButton(onPressed: _pay, child: Text(l.rechargeTryAgain)),
          TextButton(
            onPressed: () => context.read<RechargeCubit>().reset(),
            child: Text(l.rechargeChangeAmount),
          ),
        ],
      ),
    );
  }
}
