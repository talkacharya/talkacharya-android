import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../performance/presentation/cubit/performance_cubit.dart';
import '../../../performance/presentation/widgets/loyal_card.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/tool_counts_cubit.dart';
import 'widgets/break_card.dart';
import 'widgets/dash_shared.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/earning_club_banner.dart';
import 'widgets/earnings_card.dart';
import 'widgets/performance_grid.dart';
import 'widgets/profile_strength_card.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/session_cards.dart';
import 'widgets/today_pulse_card.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Astrologer dashboard: cosmic header with presence, then waiting requests,
/// ongoing sessions, the month's earning club, today and the scorecard, a
/// break, earnings, KPIs, loyal customers, tools and profile tips. Conditional
/// sections are left out of the list (not just hidden) so spacing stays even.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<DashboardCubit>()..load()),
        BlocProvider(create: (_) => getIt<PerformanceCubit>()..load()),
      ],
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
  // The header's expanded height, as it last measured itself.
  double _headerBody = DashboardHeaderDelegate.initialBodyHeight;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardCubit>().state;
    final incoming = state.incoming.value ?? const [];
    final active = state.active.value ?? const [];

    final perfState = context.watch<PerformanceCubit>().state;
    final perf = perfState.performance.value;

    final sections = <Widget>[
      if (incoming.isNotEmpty) IncomingRequestsCard(requests: incoming),
      if (active.isNotEmpty) ActiveSessionsSection(sessions: active),
      if (EarningClubBanner.visibleFor(perfState)) const EarningClubBanner(),
      const TodayPulseCard(),
      const EarningsCard(),
      const PerformanceGrid(),
      if (perf != null && perf.loyal.customers > 0)
        Padding(
          padding: DashGaps.sidePad,
          child: LoyalCard(loyal: perf.loyal, windowDays: perf.windowDays),
        ),
      const QuickActionsGrid(),
    ];
    // The break card sits right under today's numbers; it pads itself, since
    // it is there only while online.
    final breakAt = sections.indexWhere((w) => w is TodayPulseCard) + 1;

    final header = DashboardHeaderDelegate(
      topPad: MediaQuery.paddingOf(context).top,
      bodyHeight: _headerBody,
      onBodyMeasured: (h) {
        if (mounted && (h - _headerBody).abs() > 0.5) {
          setState(() => _headerBody = h);
        }
      },
    );

    return Scaffold(
      body: RefreshIndicator(
        // Pull-to-refresh only fires at the top, where the header is fully
        // expanded — drop the spinner from its bottom edge, not over it.
        edgeOffset: header.maxExtent,
        onRefresh: () => Future.wait([
          context.read<DashboardCubit>().load(),
          context.read<PerformanceCubit>().load(),
          context.read<ToolCountsCubit>().load(),
        ]),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPersistentHeader(pinned: true, delegate: header),
            const SliverToBoxAdapter(child: SizedBox(height: DashGaps.section)),
            SliverList.list(
              children: [
                for (var i = 0; i < sections.length; i++) ...[
                  if (i == breakAt) const BreakCard(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: DashGaps.section),
                    child: FadeSlideIn(
                      // Keyed by type so re-emits / refreshes don't replay it.
                      key: ValueKey(sections[i].runtimeType),
                      delay: Duration(milliseconds: 60 * i),
                      child: sections[i],
                    ),
                  ),
                ],
                // Removes itself when the profile is complete.
                const ProfileStrengthCard(),
                const SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
