import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/routes.dart';
import '../../../performance/presentation/cubit/performance_cubit.dart';
import '../../../profile/presentation/view/call_setup_page.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/tool_counts_cubit.dart';
import 'widgets/dash_shared.dart';
import 'widgets/home_header.dart';
import 'widgets/profile_strength_card.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/score_row.dart';
import 'widgets/session_cards.dart';
import 'widgets/today_card.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Astrologer dashboard, compact: a plain app bar, the online switch, what
/// needs them now (waiting requests, ongoing sessions, a call-setup problem),
/// today in one card, the scorecard in one row, and the main tools.
/// Conditional sections are left out of the list (not just hidden) so the
/// spacing stays even.
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

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardCubit>().state;
    final incoming = state.incoming.value ?? const [];
    final active = state.active.value ?? const [];

    final sections = <Widget>[
      const PresenceStrip(),
      if (incoming.isNotEmpty) IncomingRequestsCard(requests: incoming),
      if (active.isNotEmpty) ActiveSessionsSection(sessions: active),
      // Only while something on this phone would keep a request from
      // ringing it with the screen off.
      Padding(
        padding: DashGaps.sidePad,
        child: CallSetupHomeCard(onOpen: () => context.push(Routes.callSetup)),
      ),
      TodayCard(payout: state.payouts.value),
      const ScoreRow(),
      const QuickActionsGrid(),
    ];

    return Scaffold(
      appBar: homeAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          context.read<DashboardCubit>().load(),
          context.read<PerformanceCubit>().load(),
          context.read<ToolCountsCubit>().load(),
        ]),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          children: [
            for (var i = 0; i < sections.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: DashGaps.section),
                child: FadeSlideIn(
                  // Keyed by type so re-emits / refreshes don't replay it.
                  key: ValueKey(sections[i].runtimeType),
                  delay: Duration(milliseconds: 50 * i),
                  child: sections[i],
                ),
              ),
            // Removes itself when the profile is complete.
            const ProfileStrengthCard(),
          ],
        ),
      ),
    );
  }
}
