import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../cubit/dashboard_cubit.dart';
import 'widgets/dash_shared.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/earnings_card.dart';
import 'widgets/performance_grid.dart';
import 'widgets/profile_strength_card.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/session_cards.dart';

/// Astrologer dashboard: cosmic header with presence, then waiting requests,
/// ongoing sessions, earnings, KPIs, shortcuts and profile tips. Conditional
/// sections are left out of the list (not just hidden) so spacing stays even.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardCubit>()..load(),
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
      if (incoming.isNotEmpty) IncomingRequestsCard(requests: incoming),
      if (active.isNotEmpty) ActiveSessionsSection(sessions: active),
      const EarningsCard(),
      const PerformanceGrid(),
      const QuickActionsGrid(),
    ];

    return Scaffold(
      body: RefreshIndicator(
        edgeOffset: 120,
        onRefresh: context.read<DashboardCubit>().load,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: DashboardHeader()),
            const SliverToBoxAdapter(child: SizedBox(height: DashGaps.section)),
            SliverList.list(
              children: [
                for (var i = 0; i < sections.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: DashGaps.section),
                    child: FadeSlideIn(
                      // Keyed by type so re-emits / refreshes don't replay it.
                      key: ValueKey(sections[i].runtimeType),
                      delay: Duration(milliseconds: 60 * i),
                      child: sections[i],
                    ),
                  ),
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
