import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../data/referrals_api.dart';

/// Deep-link target for `talkacharya://referrals`. Backed by `GET /app/referrals`.
class ReferralsPage extends StatefulWidget {
  const ReferralsPage({super.key});

  @override
  State<ReferralsPage> createState() => _ReferralsPageState();
}

class _ReferralsPageState extends State<ReferralsPage> {
  late Future<ReferralOverview> _future = getIt<ReferralsApi>().overview();

  void _reload() => setState(() => _future = getIt<ReferralsApi>().overview());

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.referTitle)),
      body: FutureBuilder<ReferralOverview>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || !snap.hasData) {
            return ErrorView(
              message: l.commonSomethingWentWrong,
              onRetry: _reload,
            );
          }
          return _Content(data: snap.data!, onRefresh: _reload);
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.data, required this.onRefresh});

  final ReferralOverview data;
  final VoidCallback onRefresh;

  String _money(BuildContext context, double v) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Money.format(v, data.currency, locale: locale);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final friendBonus = _money(context, data.refereeBonus);
    final myBonus = _money(context, data.referrerBonus);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          FadeSlideIn(
            child: _Hero(
              title: l.referHeroTitle(friendBonus, myBonus),
              body: l.referHeroBody(friendBonus, myBonus),
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 60),
            child: _CodeCard(
              code: data.code,
              link: data.inviteLink,
              shareText: l.referShareText(
                data.code,
                friendBonus,
                data.inviteLink,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 120),
            child: _StatsRow(
              invited: data.invited,
              joined: data.pending + data.rewarded,
              earned: _money(context, data.earned),
            ),
          ),
          const SizedBox(height: 24),
          FadeSlideIn(
            delay: const Duration(milliseconds: 180),
            child: _HowItWorks(
              steps: [
                l.referStep1,
                l.referStep2(friendBonus),
                l.referStep3(myBonus),
              ],
            ),
          ),
          if (data.referrals.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l.referYourReferrals,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            ...FadeSlideIn.list(start: const Duration(milliseconds: 220), [
              for (final r in data.referrals)
                _ReferralTile(entry: r, money: _money(context, r.bonus)),
            ]),
          ],
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7E2C0C), Color(0xFFB4531B)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.volunteer_activism_rounded,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({
    required this.code,
    required this.link,
    required this.shareText,
  });

  final String code;
  final String link;
  final String shareText;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: brand.tint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: brand.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.referYourCode,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _copy(context, code, l.commonCopied),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      code,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  Icon(Icons.copy_rounded, size: 20, color: brand.onTint),
                  const SizedBox(width: 4),
                  Text(
                    l.commonCopy,
                    style: TextStyle(
                      color: brand.onTint,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => Share.share(shareText),
            icon: const Icon(Icons.share_rounded, size: 18),
            label: Text(l.referShareLink),
          ),
        ],
      ),
    );
  }

  void _copy(BuildContext context, String value, String toast) {
    Clipboard.setData(ClipboardData(text: value));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(toast)));
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.invited,
    required this.joined,
    required this.earned,
  });

  final int invited;
  final int joined;
  final String earned;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      children: [
        _stat(context, '$invited', l.referInvited),
        _divider(context),
        _stat(context, '$joined', l.referJoined),
        _divider(context),
        _stat(context, earned, l.referEarned),
      ],
    );
  }

  Widget _divider(BuildContext context) =>
      Container(width: 1, height: 34, color: context.brand.hairline);

  Widget _stat(BuildContext context, String value, String label) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.referHowItWorks,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: context.brand.tint,
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: context.brand.onTint,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      steps[i],
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ReferralTile extends StatelessWidget {
  const _ReferralTile({required this.entry, required this.money});

  final ReferralEntry entry;
  final String money;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final (label, color) = switch (entry.status) {
      'rewarded' => (l.referStatusRewarded, context.brand.online),
      'qualified' => (l.referStatusJoined, context.brand.gold),
      _ => (l.referStatusPending, theme.colorScheme.onSurfaceVariant),
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: context.brand.tint,
        child: Text(
          entry.name.isNotEmpty
              ? entry.name.characters.first.toUpperCase()
              : '?',
          style: TextStyle(
            color: context.brand.onTint,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(entry.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: color),
      ),
      trailing: entry.isRewarded
          ? Text(
              '+$money',
              style: TextStyle(
                color: context.brand.online,
                fontWeight: FontWeight.w800,
              ),
            )
          : null,
    );
  }
}
