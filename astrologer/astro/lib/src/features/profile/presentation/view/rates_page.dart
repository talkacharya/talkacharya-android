import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/astro/onboarding_store.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../data/profile_api.dart';
import '../../data/profile_models.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

const _currency = 'INR';

/// What customers pay per minute. TalkAcharya sets these from the
/// astrologer's performance; the astrologer reads them here and asks support
/// for a change.
class RatesPage extends StatefulWidget {
  const RatesPage({super.key});
  @override
  State<RatesPage> createState() => _RatesPageState();
}

class _RatesPageState extends State<RatesPage> {
  final _api = getIt<ProfileApi>();

  Map<String, double> _rates = {};
  bool _loading = true;
  bool _failed = false;

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
      if (!mounted) return;
      setState(() {
        _rates = rates;
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

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fee = double.tryParse(
      getIt<OnboardingStore>().profile?.commission?.platformPercentage ?? '',
    );
    return SubPageScaffold(
      title: l.profileRates,
      subtitle: l.ratesSubtitle,
      onRefresh: _load,
      bottomBar: StickyActionBar(
        child: BusyButton(
          label: l.ratesRequestChange,
          icon: Icons.support_agent_rounded,
          onPressed: () => context.push(Routes.feedbackRates),
        ),
      ),
      children: [
        const _SetByPlatformCard(),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_failed)
          ErrorView(message: l.commonLoadFailed, onRetry: _load)
        else
          for (final ch in kChannels)
            _RateCard(channel: ch, rate: _rates[ch], feePercent: fee),
      ],
    );
  }
}

class _SetByPlatformCard extends StatelessWidget {
  const _SetByPlatformCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: brand.tint,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HueIcon(
              hue: AstroPalette.money,
              icon: Icons.workspace_premium_rounded,
              size: 40,
              iconSize: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.ratesSetByPlatformTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: brand.onTint,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.ratesSetByPlatformBody,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.onTint,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RateCard extends StatelessWidget {
  const _RateCard({
    required this.channel,
    required this.rate,
    required this.feePercent,
  });

  final String channel;
  final double? rate;
  final double? feePercent;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final ch = channelStyle(context, channel);
    final r = rate;
    String m(double v) => Money.format(v, _currency);

    return SettingsCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                  r == null
                      ? l.ratesNotSetYet
                      : feePercent != null
                      ? l.ratesYouEarn(
                          m(r * (1 - feePercent! / 100)),
                          _trim(feePercent!),
                        )
                      : '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: r == null ? brand.inkMuted : brand.online,
                    fontWeight: r == null ? null : FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (r != null)
            Text(
              l.dashPerMin(m(r)),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}
