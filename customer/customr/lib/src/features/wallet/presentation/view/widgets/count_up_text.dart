import 'package:flutter/material.dart';

import '../../../../../core/util/money.dart';

/// Animates a money value from its previous render to the new one — used on the
/// balance card so a recharge visibly "adds up".
class CountUpText extends StatelessWidget {
  const CountUpText({
    required this.amount,
    required this.currency,
    this.style,
    this.duration = const Duration(milliseconds: 750),
    super.key,
  });

  final double amount;
  final String currency;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: amount, end: amount),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) =>
          Text(Money.format(value, currency, locale: locale), style: style),
    );
  }
}
