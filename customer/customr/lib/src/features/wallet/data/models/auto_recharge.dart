/// The customer's standing instruction to top up mid-consultation.
///
/// [enabled] is what they asked for; [armed] is whether we can actually act on
/// it. The two differ until a mandate has been authorised with their bank, and
/// showing "on" while nothing can be charged is how people lose calls they
/// thought were covered.
class AutoRecharge {
  const AutoRecharge({
    this.enabled = false,
    this.armed = false,
    this.currency = 'INR',
    this.amount = 0,
    this.thresholdAmount = 0,
    this.dailyCap,
    this.disabledReason = '',
  });

  final bool enabled;
  final bool armed;
  final String currency;
  final double amount;
  final double thresholdAmount;
  final double? dailyCap;

  /// Why it switched itself off — `repeated_failures` when the bank kept
  /// declining, which the customer needs to be told plainly.
  final String disabledReason;

  factory AutoRecharge.fromMap(Map<String, dynamic> j) => AutoRecharge(
    enabled: j['enabled'] == true,
    armed: j['armed'] == true,
    currency: j['currency'] as String? ?? 'INR',
    amount: double.tryParse('${j['amount']}') ?? 0,
    thresholdAmount: double.tryParse('${j['threshold_amount']}') ?? 0,
    dailyCap: j['daily_cap'] == null
        ? null
        : double.tryParse('${j['daily_cap']}'),
    disabledReason: j['disabled_reason'] as String? ?? '',
  );

  bool get stoppedByBank => !enabled && disabledReason == 'repeated_failures';
}
