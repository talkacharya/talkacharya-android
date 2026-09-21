import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/cosmic_header.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../consultations/data/models/consultation.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../../notifications/presentation/view/notification_bell.dart';
import '../cubit/chats_cubit.dart';

/// Chats tab: live conversations first, then recent ones, searchable by
/// customer name. Backed by the app-level [ChatsCubit]; polls while visible.
class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late final ChatsCubit _cubit = context.read<ChatsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit
      ..load()
      ..startPolling();
  }

  @override
  void dispose() {
    // App-level singleton: only pause the poll.
    _cubit.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return Scaffold(
      body: BlocBuilder<ChatsCubit, ChatsState>(
        builder: (context, state) {
          return Column(
            children: [
              CosmicTabHeader(
                title: l.navChats,
                subtitle: l.chatsSubtitle(state.totalUnread),
                actions: [NotificationBell(color: brand.onCosmic)],
                bottom: CosmicSearchField(
                  hint: l.chatsSearch,
                  onChanged: _cubit.search,
                ),
              ),
              Expanded(child: _body(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, ChatsState state) {
    final l = context.l10n;
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.all.isEmpty && state.error != null) {
      return ErrorView(message: l.chatsLoadError, onRetry: _cubit.load);
    }
    final live = state.live;
    final recent = state.recent;
    final Widget? empty = state.all.isEmpty
        ? EmptyState(
            icon: Icons.chat_bubble_outline_rounded,
            title: l.chatsEmptyTitle,
            message: l.chatsEmptyBody,
          )
        : (live.isEmpty && recent.isEmpty)
        ? EmptyState(
            icon: Icons.search_off_rounded,
            hue: AstroPalette.air,
            title: l.chatsNoMatch(state.query.trim()),
          )
        : null;

    return RefreshIndicator(
      onRefresh: _cubit.load,
      child: LayoutBuilder(
        builder: (context, box) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
          children: empty != null
              ? [SizedBox(height: box.maxHeight - 36, child: empty)]
              : [
                  if (live.isNotEmpty)
                    _Section(title: l.requestsLiveNow, items: live, live: true),
                  if (recent.isNotEmpty)
                    _Section(title: l.chatsRecent, items: recent),
                ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items, this.live = false});

  final String title;
  final List<Consultation> items;
  final bool live;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
          child: Row(
            children: [
              if (live) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: brand.online,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: live ? brand.online : brand.inkMuted,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0)
                    Divider(height: 1, indent: 76, color: brand.hairline),
                  ConsultationTile(
                    consultation: items[i],
                    onTap: () => context.push(Routes.chatRoom(items[i].id)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
