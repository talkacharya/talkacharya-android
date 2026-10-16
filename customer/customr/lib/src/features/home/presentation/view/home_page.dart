import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/config/config_repository.dart';
import '../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../../store/presentation/widgets/store_home_rail.dart';
import '../cubit/home_cubit.dart';
import 'widgets/articles_rail.dart';
import 'widgets/concern_chips.dart';
import 'widgets/free_tools_grid.dart';
import 'widgets/home_header.dart';
import 'widgets/horoscope_card.dart';
import 'widgets/live_now_rail.dart';
import 'widgets/online_astrologers_rail.dart';
import 'widgets/online_now_strip.dart';
import 'widgets/panchang_strip.dart';
import 'widgets/promo_carousel.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recharge_packs_strip.dart';
import 'widgets/refer_earn_banner.dart';
import 'widgets/resume_card.dart';
import 'widgets/talk_again_rail.dart';
import 'widgets/trust_footer.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// The customer home feed: a collapsing cosmic hero, a floating tools dock, then
/// colour-coded sections. Every section is an independent [AsyncValue] slice on
/// [HomeCubit], so the feed renders and retries section-by-section — a slow or
/// dead endpoint never blanks the screen.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<BirthProfilesCubit>().load();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    if (!mounted) return;
    final profile = context.read<BirthProfilesCubit>().state.resolvedProfile;
    context.read<HomeCubit>().load(activeProfile: profile);
  }

  Future<void> _refresh() async {
    final profile = context.read<BirthProfilesCubit>().state.resolvedProfile;
    await context.read<HomeCubit>().refresh(activeProfile: profile);
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brand.canvas,
        body: Stack(
          children: [
            BlocListener<BirthProfilesCubit, BirthProfilesState>(
              // The resolved profile (explicit active, else the user's primary) drives
              // horoscope + panchang; reload when it lands or changes.
              listenWhen: (a, b) =>
                  a.activeProfileId != b.activeProfileId ||
                  a.resolvedProfile?.id != b.resolvedProfile?.id,
              listener: (context, _) => _load(),
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: AstroPalette.romance[1],
                edgeOffset: 64,
                child: BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (a, b) =>
                      (a.resume.value != null) != (b.resume.value != null) ||
                      (a.online.isLoading ||
                              (a.online.value?.isNotEmpty ?? false)) !=
                          (b.online.isLoading ||
                              (b.online.value?.isNotEmpty ?? false)) ||
                      (a.live.isLoading || (a.live.value?.isNotEmpty ?? false)) !=
                          (b.live.isLoading ||
                              (b.live.value?.isNotEmpty ?? false)) ||
                      (a.talkAgain.value?.isNotEmpty ?? false) !=
                          (b.talkAgain.value?.isNotEmpty ?? false) ||
                      (a.articles.isLoading ||
                              (a.articles.value?.isNotEmpty ?? false)) !=
                          (b.articles.isLoading ||
                              (b.articles.value?.isNotEmpty ?? false)),
                  builder: (context, state) => CustomScrollView(
                    cacheExtent: 400,
                    slivers: [
                      const HomeTopBar(),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(0, 14, 0, 110),
                        sliver: SliverList.list(children: _sections(state)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: HomeFloatingCtaBar(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _sections(HomeState state) {
    final hasResume = state.resume.value != null;
    final liveVisible =
        state.live.isLoading || (state.live.value?.isNotEmpty ?? false);
    final hasTalkAgain = state.talkAgain.value?.isNotEmpty ?? false;
    final hasArticles =
        state.articles.isLoading || (state.articles.value?.isNotEmpty ?? false);
    final hasOnline =
        state.online.isLoading || (state.online.value?.isNotEmpty ?? false);

    final sections = <Widget>[
      const QuickActionsRow(),
      if (hasResume) const ResumeCard(),
      if (hasOnline) const OnlineNowStrip(),
      const PromoCarousel(),
      if (liveVisible) const LiveNowRail(),
      const OnlineAstrologersRail(),
      const ConcernChips(),
      const HoroscopeCard(),
      const PanchangStrip(),
      const FreeToolsGrid(),
      if (getIt<ConfigRepository>().value.features.store) const StoreHomeRail(),
      if (hasTalkAgain) const TalkAgainRail(),
      if (hasArticles) const ArticlesRail(),
      const RechargePacksStrip(),
      const ReferEarnBanner(),
      const TrustFooter(),
    ];

    final children = <Widget>[];
    for (var i = 0; i < sections.length; i++) {
      if (i > 0) children.add(const SizedBox(height: 20));
      children.add(sections[i]);
    }
    return children;
  }
}
