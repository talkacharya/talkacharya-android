import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../data/workspace_api.dart';
import '../widgets/async_page.dart';

/// "3 hours" under a day, "2 days" from a day up.
String offerDurationLabel(AppLocalizations l, int hours) =>
    hours < 24 ? l.offerHours(hours) : l.offerDays(hours ~/ 24);

String offerChannelLabel(AppLocalizations l, String channel) =>
    switch (channel) {
      'voice' => l.offerChannelVoice,
      'video' => l.offerChannelVideo,
      _ => l.offerChannelChat,
    };

/// Who and what an offer covers, in one line: "New customers · Chat, Voice".
String offerScopeLabel(AppLocalizations l, AstroOffer offer) {
  final who = offer.audience == 'new' ? l.offerAudienceNew : l.offerAudienceAll;
  final what = offer.channels.isEmpty
      ? l.offerAllChannels
      : offer.channels.map((c) => offerChannelLabel(l, c)).join(', ');
  return '$who · $what';
}

/// The astrologer's own offer: a percentage off their rates for a while. One
/// runs at a time — this page shows it, or the form to start one, and what the
/// earlier ones brought in.
class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  int? _percent;
  int? _hours;
  String _audience = 'everyone';
  final _channels = <String>{};
  bool _busy = false;

  Future<void> _start(
    OffersOverview page,
    Future<void> Function() reload,
  ) async {
    final l = context.l10n;
    final percent = _percent ?? page.percentChoices.firstOrNull;
    final hours = _hours ?? page.hourChoices.firstOrNull;
    if (percent == null || hours == null) return;
    setState(() => _busy = true);
    try {
      await getIt<WorkspaceApi>().startOffer(
        percentOff: percent,
        hours: hours,
        audience: _audience,
        channels: _channels.toList(),
      );
      await reload();
      if (mounted) showToast(context, l.offerStarted);
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _end(AstroOffer offer, Future<void> Function() reload) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(l.offerEndTitle),
        content: Text(l.offerEndBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(l.offerEnd),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await getIt<WorkspaceApi>().endOffer(offer.id);
      await reload();
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<OffersOverview>(
      title: l.offerTitle,
      subtitle: l.offerSubtitle,
      load: getIt<WorkspaceApi>().offers,
      builder: (context, page, _, reload) {
        final theme = Theme.of(context);
        final live = page.live;
        return [
          if (live != null)
            _LiveOffer(
              offer: live,
              busy: _busy,
              onEnd: () => _end(live, reload),
            )
          else if (!page.enabled)
            WsEmpty(
              icon: Icons.local_offer_outlined,
              title: l.offerOffTitle,
              message: l.offerOffBody,
            )
          else ...[
            _Label(l.offerPickPercent),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in page.percentChoices)
                  ChoiceChip(
                    label: Text(l.offerPercentOff(p)),
                    selected: p == (_percent ?? page.percentChoices.first),
                    onSelected: (_) => setState(() => _percent = p),
                  ),
              ],
            ),
            _Label(l.offerPickDuration),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final h in page.hourChoices)
                  ChoiceChip(
                    label: Text(offerDurationLabel(l, h)),
                    selected: h == (_hours ?? page.hourChoices.first),
                    onSelected: (_) => setState(() => _hours = h),
                  ),
              ],
            ),
            _Label(l.offerPickAudience),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l.offerAudienceAll),
                  selected: _audience == 'everyone',
                  onSelected: (_) => setState(() => _audience = 'everyone'),
                ),
                ChoiceChip(
                  label: Text(l.offerAudienceNew),
                  selected: _audience == 'new',
                  onSelected: (_) => setState(() => _audience = 'new'),
                ),
              ],
            ),
            _Label(l.offerPickChannels),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in const ['chat', 'voice', 'video'])
                  FilterChip(
                    label: Text(offerChannelLabel(l, c)),
                    selected: _channels.contains(c),
                    onSelected: (on) => setState(
                      () => on ? _channels.add(c) : _channels.remove(c),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l.offerChannelsHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            WsCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l.offerWhoPays,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            BusyButton(
              label: l.offerStart,
              icon: Icons.local_offer_rounded,
              busy: _busy,
              onPressed: () => _start(page, reload),
            ),
          ],
          if (page.past.isNotEmpty) ...[
            const SizedBox(height: 24),
            _Label(l.offerEarlier),
            for (final offer in page.past) _PastOffer(offer: offer),
          ],
        ];
      },
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 8),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

String _when(AppLocalizations l, DateTime? at) => at == null
    ? ''
    : DateFormat.MMMd(l.localeName).add_jm().format(at.toLocal());

class _LiveOffer extends StatelessWidget {
  const _LiveOffer({
    required this.offer,
    required this.busy,
    required this.onEnd,
  });

  final AstroOffer offer;
  final bool busy;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    const onDark = Color(0xFFF1EEFB);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [brand.cosmicStart, brand.cosmicEnd],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF30A46C),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l.offerLiveBadge,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l.offerPercentOff(offer.percentOff),
                style: theme.textTheme.displaySmall?.copyWith(
                  color: const Color(0xFFF6D695),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                offerScopeLabel(l, offer),
                style: theme.textTheme.bodyMedium?.copyWith(color: onDark),
              ),
              const SizedBox(height: 2),
              Text(
                l.offerEndsAt(_when(l, offer.endsAt)),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onDark.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _Figure(
                      value: '${offer.sessions}',
                      label: l.offerSessions,
                    ),
                  ),
                  Expanded(
                    child: _Figure(
                      value: Money.format(offer.earned, 'INR'),
                      label: l.offerEarned,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: busy ? null : onEnd,
          icon: const Icon(Icons.stop_circle_outlined),
          label: Text(l.offerEnd),
        ),
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFFF1EEFB).withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}

class _PastOffer extends StatelessWidget {
  const _PastOffer({required this.offer});

  final AstroOffer offer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final quiet = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return WsCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.offerPercentOff(offer.percentOff),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(offerScopeLabel(l, offer), style: quiet),
                Text(
                  '${_when(l, offer.startsAt)} – ${_when(l, offer.endsAt)}',
                  style: quiet,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Money.format(offer.earned, 'INR'),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(l.offerSessionCount(offer.sessions), style: quiet),
            ],
          ),
        ],
      ),
    );
  }
}
