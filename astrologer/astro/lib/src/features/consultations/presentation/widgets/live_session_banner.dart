import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../requests/presentation/cubit/requests_cubit.dart';
import '../room_presence.dart';

/// Strip above every screen while a session is live and its room isn't on top,
/// so the astrologer can always get back to it in one tap.
class LiveSessionBanner extends StatelessWidget {
  const LiveSessionBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final presence = getIt<RoomPresence>();
    return ListenableBuilder(
      listenable: presence,
      builder: (context, _) => BlocBuilder<RequestsCubit, RequestsState>(
        buildWhen: (a, b) => a.active != b.active,
        builder: (context, state) {
          final live = state.active
              .where((c) => c.id != presence.openId)
              .toList();
          return Column(
            children: [
              if (live.isNotEmpty)
                _Bar(name: live.first.customerName, id: live.first.id),
              Expanded(child: child),
            ],
          );
        },
      ),
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
    return Material(
      color: context.brand.online,
      child: SafeArea(
        bottom: false,
        child: InkWell(
          onTap: () => context.push(Routes.chatRoom(id)),
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
