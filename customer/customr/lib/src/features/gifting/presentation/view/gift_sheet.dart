import 'dart:async';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/api_error_l10n.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../wallet/presentation/cubit/wallet_cubit.dart';
import '../../../wallet/presentation/view/recharge_sheet.dart';
import '../../data/gifting_repository.dart';
import '../../data/models/gift.dart';
import '../cubit/send_gift_cubit.dart';
import '../widgets/gift_art.dart';

/// Opens the gift picker for [target]. Resolves with the last gift sent, or
/// `null` if the sheet was dismissed without sending.
///
/// One sheet serves every entry point — astrologer profile, live consultation,
/// post-session thank-you and (later) live streams — only the target differs.
Future<GiftTransaction?> showGiftSheet(
  BuildContext context, {
  required GiftTarget target,
}) async {
  final wallet = context.read<WalletCubit>();
  final cubit = SendGiftCubit(
    repo: getIt<GiftingRepository>(),
    target: target,
    onSent: wallet.refreshBalance,
  );
  unawaited(cubit.load());
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => BlocProvider.value(value: cubit, child: const _GiftSheet()),
  );
  final sent = cubit.state.sent;
  await cubit.close();
  return sent;
}

class _GiftSheet extends StatefulWidget {
  const _GiftSheet();

  @override
  State<_GiftSheet> createState() => _GiftSheetState();
}

class _GiftSheetState extends State<_GiftSheet> {
  final _note = TextEditingController();
  final _confetti = ConfettiController(
    duration: const Duration(milliseconds: 900),
  );
  bool _showNote = false;

  static const _quantities = [1, 5, 11, 21];

  @override
  void dispose() {
    _note.dispose();
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendGiftCubit, SendGiftState>(
      listenWhen: (a, b) =>
          a.status != b.status || (a.error != b.error && b.error != null),
      listener: (context, state) {
        if (state.status == SendGiftStatus.sent) {
          HapticFeedback.mediumImpact();
          _confetti.play();
        } else if (state.error != null &&
            state.status == SendGiftStatus.ready) {
          HapticFeedback.heavyImpact();
        }
      },
      builder: (context, state) {
        final size = MediaQuery.sizeOf(context);
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: size.height * 0.88),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 4,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOut,
                  child: switch (state.status) {
                    SendGiftStatus.loading => const _LoadingGrid(),
                    SendGiftStatus.failed => _LoadFailed(state: state),
                    SendGiftStatus.sent => _SentFace(state: state),
                    _ => _picker(context, state),
                  },
                ),
                ConfettiWidget(
                  confettiController: _confetti,
                  blastDirection: math.pi / 2,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.06,
                  numberOfParticles: 16,
                  maxBlastForce: 14,
                  minBlastForce: 6,
                  gravity: 0.25,
                  colors: const [
                    Color(0xFFEA6A1E),
                    Color(0xFFF2A93B),
                    Color(0xFFE63E9B),
                    Color(0xFF2E9E4F),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _picker(BuildContext context, SendGiftState state) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final cubit = context.read<SendGiftCubit>();
    final locale = Localizations.localeOf(context).toLanguageTag();
    final total = state.total;

    return SingleChildScrollView(
      key: const ValueKey('picker'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.giftSheetTitle(state.target.astrologerName),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.giftSheetSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(color: brand.inkMuted),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.gifts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, i) {
              final g = state.gifts[i];
              return _GiftTile(
                gift: g,
                currency: state.target.currency,
                locale: locale,
                selected: state.selected?.slug == g.slug,
                onTap: () => cubit.select(g),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            l.giftQuantity,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < _quantities.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: _QuantityPill(
                    quantity: _quantities[i],
                    selected: state.quantity == _quantities[i],
                    onTap: () => cubit.setQuantity(_quantities[i]),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: _showNote
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: TextField(
                      controller: _note,
                      maxLength: 200,
                      minLines: 1,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(hintText: l.giftNoteHint),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => setState(() => _showNote = true),
                      icon: const Icon(Icons.edit_note_rounded, size: 20),
                      label: Text(l.giftAddNote),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
          ),
          if (state.lowBalance) ...[
            const SizedBox(height: 8),
            _LowBalanceBanner(currency: state.target.currency),
          ] else if (state.error != null) ...[
            const SizedBox(height: 8),
            Text(
              localizedError(context, state.error),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: brand.live),
            ),
          ],
          const SizedBox(height: 12),
          _SendButton(
            label: state.selected == null || total == null
                ? l.giftChoose
                : l.giftSendCta(
                    state.quantity > 1
                        ? '${state.selected!.name} ×${state.quantity}'
                        : state.selected!.name,
                    '${total.estimate ? '≈ ' : ''}'
                    '${Money.format(total.amount, total.currency, locale: locale)}',
                  ),
            busy: state.isSending,
            onTap: state.selected == null
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                    cubit.send(message: _note.text);
                  },
          ),
          const SizedBox(height: 10),
          _BalanceLine(currency: state.target.currency),
        ],
      ),
    );
  }
}

// --- pieces -----------------------------------------------------------------

class _QuantityPill extends StatelessWidget {
  const _QuantityPill({
    required this.quantity,
    required this.selected,
    required this.onTap,
  });

  final int quantity;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final accent = theme.colorScheme.primary;
    return Material(
      color: selected ? accent.withValues(alpha: 0.1) : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? accent : brand.hairline,
          width: selected ? 1.4 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: Center(
            child: Text(
              '×$quantity',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: selected ? accent : brand.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GiftTile extends StatelessWidget {
  const _GiftTile({
    required this.gift,
    required this.currency,
    required this.locale,
    required this.selected,
    required this.onTap,
  });

  final Gift gift;
  final String currency;
  final String locale;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final price = gift.displayPrice(currency);
    final accent = GiftArt.gradientFor(gift.category).last;

    return Pressable(
      child: Material(
        color: selected ? accent.withValues(alpha: 0.08) : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected ? accent : brand.hairline,
            width: selected ? 1.6 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: selected ? 1.08 : 1,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutBack,
                  child: GiftArt(
                    slug: gift.slug,
                    category: gift.category,
                    size: 44,
                    glow: selected,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  gift.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${price.estimate ? '≈' : ''}'
                  '${Money.format(price.amount, price.currency, locale: locale)}',
                  maxLines: 1,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: selected ? accent : brand.inkMuted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Gold gradient CTA — the one gradient on this sheet.
class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.label,
    required this.busy,
    required this.onTap,
  });

  final String label;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !busy;
    const fg = Color(0xFF3A1703);
    return Pressable(
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: BrandColors.goldGradient),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: BrandColors.goldGradient.last.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: InkWell(
              onTap: enabled ? onTap : null,
              child: Center(
                child: busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: fg,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.card_giftcard_rounded,
                            size: 20,
                            color: fg,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: fg,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceLine extends StatelessWidget {
  const _BalanceLine({required this.currency});
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final wallet = context.watch<WalletCubit>().state.primaryFor(currency);
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(
          Icons.account_balance_wallet_outlined,
          size: 14,
          color: context.brand.inkMuted,
        ),
        const SizedBox(width: 6),
        Text(
          l.giftWalletBalance(
            Money.format(
              wallet?.available ?? 0,
              wallet?.currency ?? currency,
              locale: locale,
            ),
          ),
          style: theme.textTheme.labelMedium?.copyWith(
            color: context.brand.inkMuted,
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () => showRechargeSheet(context),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: const Size(0, 28),
          ),
          child: Text(
            l.giftAddMoney,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _LowBalanceBanner extends StatelessWidget {
  const _LowBalanceBanner({required this.currency});
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      decoration: BoxDecoration(
        color: brand.live.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: brand.live.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_wallet_rounded,
            color: brand.live,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.giftLowBalanceTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  l.giftLowBalanceBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => showRechargeSheet(context),
            style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
            child: Text(l.giftAddMoney),
          ),
        ],
      ),
    );
  }
}

class _SentFace extends StatelessWidget {
  const _SentFace({required this.state});
  final SendGiftState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final txn = state.sent!;
    final gift = state.selected;
    final wallet = context.watch<WalletCubit>().state.primaryFor(txn.currency);

    return Padding(
      key: const ValueKey('sent'),
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 560),
            curve: Curves.elasticOut,
            builder: (context, t, child) =>
                Transform.scale(scale: t.clamp(0.0, 1.25), child: child),
            child: GiftArt(
              slug: txn.gift,
              category: gift?.category ?? 'sticker',
              size: 96,
              glow: true,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l.giftSentTitle(
              txn.quantity > 1
                  ? '${txn.giftName} ×${txn.quantity}'
                  : txn.giftName,
              state.target.astrologerName,
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.giftSentBody,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.brand.inkMuted,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: context.brand.tint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Money.format(txn.grossAmount, txn.currency, locale: locale),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.brand.onTint,
                  ),
                ),
                if (wallet != null) ...[
                  Container(
                    width: 1,
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: context.brand.hairline,
                  ),
                  Text(
                    l.giftWalletBalance(
                      Money.format(
                        wallet.available,
                        wallet.currency,
                        locale: locale,
                      ),
                    ),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: context.brand.onTint,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l.commonDone),
            ),
          ),
          TextButton(
            onPressed: () => context.read<SendGiftCubit>().again(),
            child: Text(l.giftSendAnother),
          ),
        ],
      ),
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      key: const ValueKey('loading'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 220, height: 22),
          const SizedBox(height: 8),
          const SkeletonBox(width: 260),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.72,
            children: [
              for (var i = 0; i < 8; i++) const SkeletonBox(radius: 16),
            ],
          ),
          const SizedBox(height: 18),
          const SkeletonBox(height: 52, radius: 14),
        ],
      ),
    );
  }
}

class _LoadFailed extends StatelessWidget {
  const _LoadFailed({required this.state});
  final SendGiftState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      key: const ValueKey('failed'),
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.card_giftcard_rounded,
            size: 44,
            color: context.brand.inkMuted,
          ),
          const SizedBox(height: 12),
          Text(l.giftLoadError, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            localizedError(context, state.error),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.brand.inkMuted,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: () => context.read<SendGiftCubit>().load(),
            icon: const Icon(Icons.refresh_rounded),
            label: Text(l.commonRetry),
          ),
        ],
      ),
    );
  }
}
