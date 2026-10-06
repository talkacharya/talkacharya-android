import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../data/waitlist_api.dart';
import '../cubit/waitlist_cubit.dart';

/// Who is waiting for this astrologer, longest first. The line moves by
/// itself when a session ends; from here the astrologer can also call someone
/// in out of turn, or take them off the list.
class WaitlistPage extends StatefulWidget {
  const WaitlistPage({super.key});

  @override
  State<WaitlistPage> createState() => _WaitlistPageState();
}

class _WaitlistPageState extends State<WaitlistPage> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    context.read<WaitlistCubit>().load();
    // Waiting times and invite countdowns are read off the clock.
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<WaitlistCubit>();
    final state = context.watch<WaitlistCubit>().state;

    return SubPageScaffold(
      title: l.waitlistTitle,
      subtitle: l.waitlistSubtitle,
      onRefresh: cubit.load,
      children: state.entries.when(
        loading: () => const [_Skeleton()],
        error: (message) => [
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: ErrorView(message: message, onRetry: cubit.load),
          ),
        ],
        data: (entries) => entries.isEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: EmptyState(
                    icon: Icons.groups_rounded,
                    hue: AstroPalette.air,
                    title: l.waitlistEmptyTitle,
                    message: l.waitlistEmptyBody,
                  ),
                ),
              ]
            : [
                for (var i = 0; i < entries.length; i++)
                  _EntryCard(
                    key: ValueKey(entries[i].id),
                    entry: entries[i],
                    place: i + 1,
                    busy: state.busy.contains(entries[i].id),
                  ),
              ],
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.entry,
    required this.place,
    required this.busy,
    super.key,
  });

  final WaitlistEntry entry;
  final int place;
  final bool busy;

  Future<void> _invite(BuildContext context) async {
    final l = context.l10n;
    final error = await context.read<WaitlistCubit>().invite(entry.id);
    if (!context.mounted) return;
    showToast(context, error ?? l.waitlistInvited(_name(l)));
  }

  Future<void> _remove(BuildContext context) async {
    final l = context.l10n;
    final cubit = context.read<WaitlistCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(l.waitlistRemoveTitle(_name(l))),
        content: Text(l.waitlistRemoveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(l.waitlistRemove),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final error = await cubit.remove(entry.id);
    if (error != null && context.mounted) showToast(context, error);
  }

  String _name(AppLocalizations l) => entry.customerName.trim().isEmpty
      ? l.winBackCustomer
      : entry.customerName;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final e = entry;
    final ch = channelStyle(context, e.channel);
    final name = _name(l);
    final invited = e.invited;
    final left = invited
        ? e.offerExpiresAt!.difference(DateTime.now()).inSeconds.clamp(0, 5999)
        : 0;
    final clock = '${left ~/ 60}:${(left % 60).toString().padLeft(2, '0')}';
    final waited = e.joinedAt == null
        ? ''
        : l.waitlistWaiting(_waited(l, DateTime.now().difference(e.joinedAt!)));

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
        decoration: BoxDecoration(
          color: invited ? ch.hue.tint(0.10) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(
            color: invited ? ch.hue.tint(0.45) : brand.hairline,
          ),
        ),
        child: Row(
          children: [
            _Place(place: place),
            const SizedBox(width: 10),
            HueAvatar(name: name, hue: AstroPalette.forId(name), size: 44),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(ch.icon, size: 14, color: ch.hue.end),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          [
                            ch.label,
                            e.pastSessions > 0
                                ? l.waitlistRegular(e.pastSessions)
                                : l.waitlistNew,
                          ].join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    invited ? l.waitlistInvitedLeft(clock) : waited,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: invited ? ch.hue.end : brand.inkMuted,
                      fontWeight: invited ? FontWeight.w700 : null,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            if (!invited)
              FilledButton.tonal(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                onPressed: busy ? null : () => _invite(context),
                child: Text(l.waitlistInvite),
              ),
            PopupMenuButton<String>(
              tooltip: l.chatMoreOptions,
              enabled: !busy,
              onSelected: (_) => _remove(context),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'remove', child: Text(l.waitlistRemove)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _waited(AppLocalizations l, Duration d) {
    if (d.inMinutes < 1) return l.perfSeconds(d.inSeconds.clamp(0, 59));
    if (d.inHours < 1) return l.perfMinutes(d.inMinutes);
    return l.perfHoursMinutes(d.inHours, d.inMinutes % 60);
  }
}

class _Place extends StatelessWidget {
  const _Place({required this.place});

  final int place;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      child: Text(
        '$place',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: context.brand.inkMuted,
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        children: [
          SkeletonBox(height: 76, radius: 16),
          SizedBox(height: 10),
          SkeletonBox(height: 76, radius: 16),
          SizedBox(height: 10),
          SkeletonBox(height: 76, radius: 16),
        ],
      ),
    );
  }
}
