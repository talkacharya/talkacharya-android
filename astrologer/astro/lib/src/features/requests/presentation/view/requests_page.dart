import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../consultations/data/models/consultation.dart';
import '../cubit/requests_cubit.dart';
import 'widgets/incoming_request_sheet.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RequestsCubit>()..load(),
      child: _RequestsView(initialTab: initialTab),
    );
  }
}

class _RequestsView extends StatelessWidget {
  const _RequestsView({required this.initialTab});
  final int initialTab;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialTab.clamp(0, 2),
      child: AppScaffold(
        title: initialTab == 1 ? 'Chats' : 'Requests',
        child: Column(
          children: [
            const TabBar(tabs: [
              Tab(text: 'Incoming'),
              Tab(text: 'Active'),
              Tab(text: 'History'),
            ]),
            Expanded(
              child: BlocBuilder<RequestsCubit, RequestsState>(
                builder: (context, state) {
                  if (state.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return TabBarView(children: [
                    _IncomingList(state.incoming),
                    _SimpleList(
                      state.active,
                      empty: 'No active consultations',
                      onTap: (c) => context.push('/chats/${c.id}'),
                    ),
                    _SimpleList(
                      state.history,
                      empty: 'No past consultations',
                      onTap: (c) => context.push('/requests/${c.id}'),
                    ),
                  ]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomingList extends StatelessWidget {
  const _IncomingList(this.items);
  final List<Consultation> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.inbox_outlined,
        title: 'No requests right now',
        message: 'Go online to start receiving consultation requests.',
      );
    }
    final cubit = context.read<RequestsCubit>();
    return RefreshIndicator(
      onRefresh: cubit.load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final c = items[i];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${c.customerName} · ${c.channel}',
                      style: Theme.of(context).textTheme.titleMedium),
                  if (c.question.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(c.question,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => cubit.reject(c.id, 'unavailable'),
                        child: const Text('Decline'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          final accepted = await cubit.accept(c.id);
                          if (accepted != null && context.mounted) {
                            if (c.channel == 'chat') {
                              context.push('/chats/${c.id}');
                            } else {
                              showIncomingRequestSheet(
                                context,
                                consultationId: c.id,
                                channel: c.channel,
                                question: c.question,
                              );
                            }
                          }
                        },
                        child: const Text('Accept'),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SimpleList extends StatelessWidget {
  const _SimpleList(this.items, {required this.empty, required this.onTap});
  final List<Consultation> items;
  final String empty;
  final void Function(Consultation) onTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return EmptyState(icon: Icons.history_rounded, title: empty);
    }
    return RefreshIndicator(
      onRefresh: context.read<RequestsCubit>().load,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final c = items[i];
          return ListTile(
            title: Text(c.customerName),
            subtitle: Text(
              c.isEnded
                  ? '${c.billedMinutes} min · ${c.currency} ${c.astrologerAmount}'
                  : c.channel,
            ),
            trailing: c.rating != null
                ? Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('${c.rating}'),
                    const Icon(Icons.star_rounded, size: 16),
                  ])
                : const Icon(Icons.chevron_right_rounded),
            onTap: () => onTap(c),
          );
        },
      ),
    );
  }
}
