import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/astro/onboarding_store.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../data/profile_api.dart';
import '../../data/profile_models.dart';
import '../../../../core/utils/haptic_service.dart';

const _currency = 'INR';

/// Per-channel per-minute pricing within the platform's allowed bands.
class RatesPage extends StatefulWidget {
  const RatesPage({super.key});
  @override
  State<RatesPage> createState() => _RatesPageState();
}

class _RatesPageState extends State<RatesPage> {
  final _api = getIt<ProfileApi>();

  /// Saved rates, and the values being edited.
  Map<String, double> _saved = {};
  final Map<String, double> _draft = {};

  /// `null` when the bands endpoint failed — fall back to free entry.
  Map<String, RateBand>? _bands;
  bool _loading = true;
  bool _failed = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final rates = await _api.rates(currency: _currency);
      Map<String, RateBand>? bands;
      try {
        bands = {
          for (final b in await _api.rateBands())
            if (b.currency == _currency) b.channel: b,
        };
      } catch (_) {
        bands = null;
      }
      if (!mounted) return;
      setState(() {
        _saved = rates;
        _bands = bands;
        _draft
          ..clear()
          ..addAll(rates);
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _failed = true;
        });
      }
    }
  }

  List<String> get _dirty => [
    for (final ch in kChannels)
      if (_draft[ch] != null && _draft[ch] != _saved[ch]) ch,
  ];

  Future<void> _save() async {
    final l = context.l10n;
    setState(() => _saving = true);
    try {
      for (final ch in _dirty) {
        await _api.setRate(ch, _currency, _draft[ch]!);
        _saved = {..._saved, ch: _draft[ch]!};
      }
      unawaited(getIt<OnboardingStore>().refresh());
      if (mounted) showToast(context, l.ratesUpdated);
    } on ApiException catch (e) {
      if (mounted) {
        showToast(context, e.isNetwork ? l.commonSaveFailed : e.message);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final dirty = _dirty;
    final fee = double.tryParse(
      getIt<OnboardingStore>().profile?.commission?.platformPercentage ?? '',
    );
    return SubPageScaffold(
      title: l.profileRates,
      subtitle: l.ratesSubtitle,
      canPop: dirty.isEmpty || _saving,
      onPopBlocked: () => _confirmDiscard(context),
      bottomBar: dirty.isEmpty
          ? null
          : StickyActionBar(
              child: BusyButton(
                label: l.ratesSaveCount(dirty.length),
                busy: _saving,
                onPressed: _save,
              ),
            ),
      children: [
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_failed)
          ErrorView(message: l.commonLoadFailed, onRetry: _load)
        else
          for (final ch in kChannels)
            _RateCard(
              channel: ch,
              band: _bands?[ch],
              bandsKnown: _bands != null,
              value: _draft[ch],
              saved: _saved[ch],
              feePercent: fee,
              onChanged: (v) => setState(() => _draft[ch] = v),
            ),
      ],
    );
  }

  Future<void> _confirmDiscard(BuildContext context) async {
    final l = context.l10n;
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.editDiscardTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.editKeepEditing),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.editDiscard),
          ),
        ],
      ),
    );
    if ((discard ?? false) && context.mounted) Navigator.of(context).pop();
  }
}

class _RateCard extends StatelessWidget {
  const _RateCard({
    required this.channel,
    required this.band,
    required this.bandsKnown,
    required this.value,
    required this.saved,
    required this.feePercent,
    required this.onChanged,
  });

  final String channel;
  final RateBand? band;

  /// Whether bands loaded; if not, the rate is typed freely.
  final bool bandsKnown;
  final double? value;
  final double? saved;
  final double? feePercent;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final ch = channelStyle(context, channel);
    final b = band;
    final offered = !bandsKnown || b != null;
    final current = value ?? b?.suggested;
    String m(double v) => Money.format(v, _currency);

    return SettingsCard(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Row(
              children: [
                HueIcon(hue: ch.hue, icon: ch.icon, size: 40, iconSize: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ch.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        !offered
                            ? l.ratesNotOffered
                            : b != null
                            ? l.ratesAllowed(m(b.min), m(b.max))
                            : '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (offered && current != null)
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: value != saved ? ch.hue.end : null,
                      fontWeight: FontWeight.w700,
                    ),
                    child: Text(l.dashPerMin(m(current))),
                  ),
              ],
            ),
          ),
          if (offered && b != null && current != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                _StepButton(
                  icon: Icons.remove_rounded,
                  onTap: current > b.min
                      ? () => onChanged(b.clamp(current - 1))
                      : null,
                ),
                Expanded(
                  child: Slider(
                    value: b.clamp(current),
                    min: b.min,
                    max: b.max,
                    divisions: (b.max - b.min).round().clamp(1, 500),
                    activeColor: ch.hue.end,
                    onChanged: (v) {
                      HapticService.selection();
                      onChanged(v.roundToDouble());
                    },
                  ),
                ),
                _StepButton(
                  icon: Icons.add_rounded,
                  onTap: current < b.max
                      ? () => onChanged(b.clamp(current + 1))
                      : null,
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (b.suggested > 0 && b.suggested != current)
                  ActionChip(
                    avatar: Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 16,
                      color: brand.gold,
                    ),
                    label: Text(l.ratesSuggested(m(b.suggested))),
                    onPressed: () => onChanged(b.suggested),
                  ),
                if (feePercent != null)
                  Text(
                    l.ratesYouEarn(
                      m(current * (1 - feePercent! / 100)),
                      _trim(feePercent!),
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.online,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ] else if (!bandsKnown)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextFormField(
                initialValue: value?.toStringAsFixed(0) ?? '',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  suffixText: '/min',
                  labelText: ch.label,
                ),
                onChanged: (s) {
                  final v = double.tryParse(s);
                  if (v != null && v > 0) onChanged(v);
                },
              ),
            ),
        ],
      ),
    );
  }

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    onPressed: onTap,
    icon: Icon(icon, size: 20),
    visualDensity: VisualDensity.compact,
  );
}
