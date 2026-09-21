import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../cubit/chats_list_cubit.dart';
import '../../room_presence.dart';

/// Green strip above every screen while a consultation is live and its room is
/// not on top — one tap goes back to it, so a session is never "lost" behind
/// other pages.
class LiveSessionBanner extends StatelessWidget {
  const LiveSessionBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final presence = getIt<RoomPresence>();
    return ListenableBuilder(
      listenable: presence,
      builder: (context, _) {
        return BlocBuilder<ChatsListCubit, ChatsListState>(
          buildWhen: (a, b) => a.live != b.live,
          builder: (context, state) {
            // Not for the room on screen, and not for a call already riding
            // above the app on its own mini bar — one "return here" at a time.
            final hub = getIt<CallHub>();
            final live = state.live
                .where((c) => c.id != presence.openId && !hub.isFor(c.id))
                .toList();
            return Column(
              children: [
                if (live.isNotEmpty)
                  _Bar(name: live.first.astrologerName, id: live.first.id),
                Expanded(child: child),
              ],
            );
          },
        );
      },
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.name, required this.id});

  final String name;
  final String id;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return Material(
      color: brand.online,
      child: SafeArea(
        bottom: false,
        child: InkWell(
          onTap: () => context.push(Routes.consultation(id)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            child: Row(
              children: [
                const Icon(
                  Icons.graphic_eq_rounded,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.sessionLiveBanner(name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  l.sessionReturn,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
