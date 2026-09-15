import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../data/models/home_consultation.dart';
import '../../cubit/home_cubit.dart';
import 'home_shared.dart';
import 'package:customr/src/core/l10n/l10n.dart';

/// Only renders when a session is active / paused. Sits just under the header —
/// nothing else matters while a paid consultation is open.
class ResumeCard extends StatelessWidget {
  const ResumeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final resume = context.select((HomeCubit c) => c.state.resume);
    final consultation = resume.when(
      idle: () => null,
      loading: () => null,
      error: (_) => null,
      data: (c) => c,
    );
    if (consultation == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Pressable(
      child: Padding(
        padding: HomeGaps.sidePad,
        child: Material(
          color: scheme.primaryContainer,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () => context.go(Routes.consultation(consultation.id)),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  _PulseDot(color: scheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _headline(consultation),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onPrimaryContainer.withValues(
                              alpha: 0.8,
                            ),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                        Text(
                          consultation.astrologerName.isEmpty
                              ? 'Your astrologer'
                              : consultation.astrologerName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: scheme.onPrimaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () =>
                        context.go(Routes.consultation(consultation.id)),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    child: Text(context.l10n.homeResumeBtn),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _headline(HomeConsultation c) {
    final channel = switch (c.channel) {
      'voice' => 'Voice call',
      'video' => 'Video call',
      _ => 'Chat',
    };
    return c.status == 'paused'
        ? '$channel · paused'
        : '$channel · in progress';
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot({required this.color});
  final Color color;

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.45, end: 1.0).animate(_c),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
