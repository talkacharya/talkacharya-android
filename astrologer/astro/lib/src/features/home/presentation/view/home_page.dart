import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/availability/availability_coordinator.dart';
import '../../../../core/di/service_locator.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../availability/presentation/widgets/availability_chip.dart';
import '../../../notifications/presentation/view/notification_bell.dart';
import '../cubit/dashboard_cubit.dart';

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
    final name = context.select((AuthBloc b) => b.state.user?.shortName ?? '');
    final coord = getIt<AvailabilityCoordinator>();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Text('Namaste, $name'),
        actions: const [
          AvailabilityChip(),
          NotificationBell(),
          SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<DashboardCubit>().load(),
        child: BlocBuilder<DashboardCubit, DashboardData>(
          builder: (context, d) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AnimatedBuilder(
                  animation: coord,
                  builder: (context, _) => Card(
                    color: coord.enabled
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    child: ListTile(
                      leading: Icon(
                        coord.enabled
                            ? Icons.podcasts_rounded
                            : Icons.power_settings_new_rounded,
                      ),
                      title: Text(
                        coord.enabled
                            ? "You're ${coord.presence}"
                            : "You're offline",
                      ),
                      subtitle: Text(
                        coord.enabled
                            ? 'Receiving consultation requests'
                            : 'Go online to receive requests',
                      ),
                      trailing: Switch(
                        value: coord.enabled,
                        onChanged: coord.setEnabled,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (d.incomingCount > 0)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.notifications_active_rounded),
                      title: Text(
                        '${d.incomingCount} request${d.incomingCount == 1 ? '' : 's'} waiting',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.go('/requests'),
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _Stat('This week', '${d.completed}', 'completed'),
                    const SizedBox(width: 12),
                    _Stat(
                      'Acceptance',
                      '${d.acceptanceRate.toStringAsFixed(0)}%',
                      '',
                    ),
                    const SizedBox(width: 12),
                    _Stat(
                      'Rating',
                      d.ratingAvg.toStringAsFixed(1),
                      '${d.ratingCount}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.account_balance_wallet_rounded),
                    title: const Text('Available to pay out'),
                    subtitle: Text('${d.currency} ${d.availableToPay}'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.go('/earnings'),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.insights_rounded),
                    title: const Text('Prediction queue'),
                    subtitle: const Text('Write forecasts customers requested'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/predictions'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, this.sub);
  final String label, value, sub;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            children: [
              Text(value, style: Theme.of(context).textTheme.titleLarge),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              if (sub.isNotEmpty)
                Text(sub, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
