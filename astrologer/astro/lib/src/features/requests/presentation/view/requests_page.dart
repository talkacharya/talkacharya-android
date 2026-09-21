import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/availability/availability_coordinator.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/cosmic_header.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../consultations/data/models/consultation.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../../notifications/presentation/view/notification_bell.dart';
import '../cubit/requests_cubit.dart';
import 'widgets/decline_reason_sheet.dart';
import 'widgets/request_card.dart';

/// Requests tab: Incoming / Active / History behind gold pill tabs. Backed by
/// the app-level [RequestsCubit] (which also feeds the nav badge).
class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    context.read<RequestsCubit>().load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return BlocConsumer<RequestsCubit, RequestsState>(
      listenWhen: (a, b) => b.error != null && a.error != b.error,
      listener: (context, state) {
        // Load errors get a full-screen retry when there's nothing to show.
        if (state.isEmpty) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(l.requestsActionFailed),
            ),
          );
        context.read<RequestsCubit>().clearError();
      },
      builder: (context, state) {
        final cubit = context.read<RequestsCubit>();
        return Scaffold(
          body: Column(
            children: [
              CosmicTabHeader(
                title: l.navRequests,
                subtitle: l.requestsSubtitle,
                actions: [NotificationBell(color: brand.onCosmic)],
                bottom: PillTabBar(
                  controller: _tabs,
                  labels: [
                    l.requestsTabIncoming,
                    l.requestsTabActive,
                    l.requestsTabHistory,
                  ],
                  counts: [state.incoming.length, state.active.length, 0],
                ),
              ),
              Expanded(
                child: state.loading
                    ? const Center(child: CircularProgressIndicator())
                    : (state.isEmpty && state.error != null)
                    ? ErrorView(
                        message: l.requestsLoadError,
                        onRetry: cubit.load,
                      )
                    : TabBarView(
                        controller: _tabs,
                        children: [
                          _IncomingTab(state: state),
                          _ActiveTab(items: state.active),
                          _HistoryTab(items: state.history),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Pull-to-refresh list that still centres an empty state.
class _RefreshableList extends StatelessWidget {
  const _RefreshableList({required this.children, this.empty});

  final List<Widget> children;
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<RequestsCubit>().load,
      child: LayoutBuilder(
        builder: (context, box) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
          children: children.isEmpty && empty != null
              ? [SizedBox(height: box.maxHeight - 40, child: empty)]
              : children,
        ),
      ),
    );
  }
}

class _IncomingTab extends StatelessWidget {
  const _IncomingTab({required this.state});

  final RequestsState state;

  Future<void> _accept(BuildContext context, Consultation c) async {
    final accepted = await context.read<RequestsCubit>().accept(c.id);
    if (accepted != null && context.mounted) {
      // Chat, voice and video all open the consultation room.
      await context.push<void>(Routes.chatRoom(accepted.id));
    }
  }

  Future<void> _decline(BuildContext context, Consultation c) async {
    final reason = await showDeclineReasonSheet(context);
    if (reason != null && context.mounted) {
      await context.read<RequestsCubit>().reject(c.id, reason);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final coord = getIt<AvailabilityCoordinator>();
    final cubit = context.read<RequestsCubit>();
    return _RefreshableList(
      empty: ListenableBuilder(
        listenable: coord,
        builder: (context, _) => coord.enabled
            ? EmptyState(
                icon: Icons.podcasts_rounded,
                hue: AstroPalette.health,
                title: l.requestsEmptyOnlineTitle,
                message: l.requestsEmptyOnlineBody,
              )
            : EmptyState(
                icon: Icons.power_settings_new_rounded,
                hue: AstroPalette.money,
                title: l.presenceOffline,
                message: l.presenceOfflineHint,
                action: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(180, 48),
                  ),
                  onPressed: () => coord.setEnabled(true),
                  icon: const Icon(Icons.power_settings_new_rounded),
                  label: Text(l.presenceGoOnline),
                ),
              ),
      ),
      children: [
        for (var i = 0; i < state.incoming.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: FadeSlideIn(
              key: ValueKey(state.incoming[i].id),
              delay: Duration(milliseconds: 50 * i),
              child: IncomingRequestCard(
                consultation: state.incoming[i],
                busy: state.busy.contains(state.incoming[i].id),
                onAccept: () => _accept(context, state.incoming[i]),
                onDecline: () => _decline(context, state.incoming[i]),
                onTap: () =>
                    context.push(Routes.requestDetail(state.incoming[i].id)),
                onExpired: () => cubit.expireLocally(state.incoming[i].id),
              ),
            ),
          ),
      ],
    );
  }
}

class _ActiveTab extends StatelessWidget {
  const _ActiveTab({required this.items});

  final List<Consultation> items;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _RefreshableList(
      empty: EmptyState(
        icon: Icons.forum_outlined,
        title: l.requestsActiveEmptyTitle,
        message: l.requestsActiveEmptyBody,
      ),
      children: [
        if (items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (final c in items)
                    ConsultationTile(
                      consultation: c,
                      onTap: () => context.push(Routes.chatRoom(c.id)),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.items});

  final List<Consultation> items;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    // Group by day (list is already newest-first).
    final groups = <String, List<Consultation>>{};
    for (final c in items) {
      final at = c.endedAt ?? c.requestedAt;
      final key = at == null ? '' : TimeFormat.day(l, at);
      groups.putIfAbsent(key, () => []).add(c);
    }
    return _RefreshableList(
      empty: EmptyState(
        icon: Icons.history_rounded,
        hue: AstroPalette.air,
        title: l.requestsHistoryEmptyTitle,
        message: l.requestsHistoryEmptyBody,
      ),
      children: [
        for (final MapEntry(key: day, value: list) in groups.entries) ...[
          if (day.isNotEmpty) _DayHeader(day),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (final c in list)
                    ConsultationTile(
                      consultation: c,
                      showStatus: true,
                      onTap: () => context.push(Routes.requestDetail(c.id)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: context.brand.inkMuted,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
