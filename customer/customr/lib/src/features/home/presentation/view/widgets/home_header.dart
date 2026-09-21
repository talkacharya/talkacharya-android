import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../core/util/async_value.dart';
import '../../../../../core/util/money.dart';
import '../../../../../shared/widgets/language_quick_button.dart';
import '../../../../../shared/widgets/cosmic.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../../astrologers/data/models/astrologer.dart';
import '../../../../auth/data/models/auth_user.dart';
import '../../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../../notifications/presentation/view/notification_bell.dart';
import '../../../../wallet/data/models/wallet_balance.dart';
import '../../../../wallet/presentation/cubit/wallet_cubit.dart';
import '../../cubit/home_cubit.dart';
import 'home_shared.dart';

/// Height the quick-actions dock tucks up into the hero.
const double kHeroDockOverlap = 36;

/// Height of the scrolling hero panel below the pinned top bar.
const double kHeroPanelHeight = 238;

const double _kTopBarHeight = 64;

/// Pinned cosmic top bar: avatar + greeting, wallet, language, notifications.
/// Its nebula is the top slice of the same canvas the [HomeHeroPanel] continues.
class HomeTopBar extends StatefulWidget {
  const HomeTopBar({super.key});

  @override
  State<HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<HomeTopBar> {
  @override
  void initState() {
    super.initState();
    final wallet = context.read<WalletCubit>();
    final balances = wallet.state.balances;
    if (balances.status == AsyncStatus.idle ||
        (balances.value == null && !balances.isLoading)) {
      wallet.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final user = context.select((AuthBloc b) => b.state.user);
    final name = (user?.shortName.isNotEmpty ?? false)
        ? user!.shortName
        : l.homeGreetingFallbackName;

    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      toolbarHeight: _kTopBarHeight,
      titleSpacing: 16,
      backgroundColor: brand.cosmicStart,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      scrolledUnderElevation: 0,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: const _NebulaSlice(top: true),
      title: Row(
        children: [
          _UserAvatar(user: user, name: name),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.homeGreeting('').replaceAll(RegExp(r'[,\s]+$'), ''),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: const [
        _WalletPill(),
        LanguageQuickButton(),
        NotificationBell(),
        SizedBox(width: 6),
      ],
    );
  }
}

/// The scrolling hero: tagline, who's online, Chat / Call — with the quick-actions
/// [dock] floating over its rounded bottom edge.
class HomeHeroPanel extends StatelessWidget {
  const HomeHeroPanel({required this.dock, super.key});

  final Widget dock;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: kHeroPanelHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _NebulaSlice(top: false),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    4,
                    20,
                    kHeroDockOverlap + 18,
                  ),
                  child: _HeroContent(),
                ),
              ],
            ),
          ),
        ),
        PullUp(by: kHeroDockOverlap, child: dock),
      ],
    );
  }
}

/// One continuous nebula spanning status bar + top bar + hero panel; each part
/// shows its own slice so the seam is invisible.
class _NebulaSlice extends StatelessWidget {
  const _NebulaSlice({required this.top});
  final bool top;

  @override
  Widget build(BuildContext context) {
    final total =
        MediaQuery.paddingOf(context).top + _kTopBarHeight + kHeroPanelHeight;
    return ClipRect(
      child: OverflowBox(
        alignment: top ? Alignment.topCenter : Alignment.bottomCenter,
        minHeight: total,
        maxHeight: total,
        child: const CosmicBackdrop(),
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final online = context.select((HomeCubit c) => c.state.online);
    final people = online.value ?? const <Astrologer>[];
    final available = people.where((a) => a.isAvailable).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          l.homeGuidanceTagline,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontSize: 26,
            height: 1.15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        _OnlineRow(available: available),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _HeroCta(
                label: l.homeChatNow,
                icon: Icons.chat_bubble_rounded,
                filled: true,
                onTap: () => context.go(
                  Routes.astrologersWith(channel: 'chat', sort: 'recommended'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _HeroCta(
                label: l.homeCallNow,
                icon: Icons.phone_in_talk_rounded,
                filled: false,
                onTap: () => context.go(
                  Routes.astrologersWith(channel: 'voice', sort: 'recommended'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Pulsing dot + "N online" + a stack of the first few online faces.
class _OnlineRow extends StatelessWidget {
  const _OnlineRow({required this.available});
  final List<Astrologer> available;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final faces = available.take(4).toList();
    return InkWell(
      onTap: () => context.go(Routes.astrologersWith(sort: 'recommended')),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 12, 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (faces.isNotEmpty) ...[
              SizedBox(
                width: 22.0 + (faces.length - 1) * 15,
                height: 22,
                child: Stack(
                  children: [
                    for (var i = 0; i < faces.length; i++)
                      Positioned(
                        left: i * 15,
                        child: _MiniFace(astrologer: faces[i], index: i),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
            const LiveDot(),
            const SizedBox(width: 6),
            Text(
              available.isEmpty
                  ? l.homeOnlineNow
                  : l.homeOnlineCount(available.length),
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniFace extends StatelessWidget {
  const _MiniFace({required this.astrologer, required this.index});
  final Astrologer astrologer;
  final int index;

  @override
  Widget build(BuildContext context) {
    const hues = [
      AstroPalette.love,
      AstroPalette.career,
      AstroPalette.health,
      AstroPalette.money,
    ];
    final hue = hues[index % hues.length];
    final url = astrologer.avatar;
    final initial = astrologer.name.trim().isEmpty
        ? '★'
        : astrologer.name.trim().characters.first.toUpperCase();
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hue.linear(),
        border: Border.all(color: context.brand.cosmicStart, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: (url != null && url.isNotEmpty)
          ? Image.network(
              url,
              fit: BoxFit.cover,
              width: 22,
              height: 22,
              errorBuilder: (_, _, _) => _initialText(initial),
            )
          : _initialText(initial),
    );
  }

  Widget _initialText(String s) => Text(
    s,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.w800,
    ),
  );
}

class _HeroCta extends StatelessWidget {
  const _HeroCta({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = filled ? const Color(0xFF3A1703) : Colors.white;
    return Pressable(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: BrandColors.goldGradient.last.withValues(
                      alpha: 0.45,
                    ),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: filled
                  ? const LinearGradient(colors: BrandColors.goldGradient)
                  : null,
              color: filled ? null : Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: filled
                  ? null
                  : Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 19, color: fg),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
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

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.user, required this.name});

  final AuthUser? user;
  final String name;

  @override
  Widget build(BuildContext context) {
    const size = 38.0;
    final url = user?.avatar;
    final fallback = Center(
      child: Text(
        name.isNotEmpty ? name.characters.first.toUpperCase() : '?',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 15,
        ),
      ),
    );
    return InkWell(
      onTap: () => context.go(Routes.profile),
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(
            colors: [
              Color(0xFFFFB02E),
              Color(0xFFFF5C8A),
              Color(0xFF7B3FE4),
              Color(0xFF5EC8FF),
              Color(0xFFFFB02E),
            ],
          ),
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AstroPalette.career.linear(),
            border: Border.all(color: context.brand.cosmicStart, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: (url != null && url.isNotEmpty)
              ? Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => fallback,
                )
              : fallback,
        ),
      ),
    );
  }
}

/// Glass wallet pill — balance + "Add".
class _WalletPill extends StatelessWidget {
  const _WalletPill();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currency = context.select(
      (AuthBloc b) => b.state.user?.preferredCurrency ?? 'INR',
    );
    final balances = context.watch<WalletCubit>().state.balances;
    final balance = balances.value?.primary(currency);
    final isError = balances.isError && balance == null;
    final label = balance == null
        ? null
        : Money.format(balance.spendable, currency, locale: locale);

    return Center(
      child: Material(
        color: Colors.white.withValues(alpha: 0.12),
        shape: StadiumBorder(
          side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(Routes.wallet),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 6, 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AstroPalette.money.linear(),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 7),
                if (balances.isLoading && balance == null)
                  Container(
                    width: 22,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                else if (isError)
                  const Icon(
                    Icons.refresh_rounded,
                    size: 14,
                    color: Colors.white,
                  )
                else
                  Text(
                    label ?? '—',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                const SizedBox(width: 6),
                Semantics(
                  label: l.walletAddShort,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AstroPalette.money.start.withValues(alpha: 0.25),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: 14,
                      color: AstroPalette.money.start,
                    ),
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
