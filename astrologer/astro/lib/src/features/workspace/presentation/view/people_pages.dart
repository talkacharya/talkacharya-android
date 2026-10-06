import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/util/money.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../data/workspace_api.dart';
import '../widgets/async_page.dart';

String _nameOr(AppLocalizations l, String name) =>
    name.trim().isEmpty ? l.winBackCustomer : name;

/// Customers the astrologer marked, each with a private note. Marking is done
/// from the customer's chat; here they are reread, annotated and unmarked.
class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<List<FavouriteCustomer>>(
      title: l.wsFavourites,
      subtitle: l.wsFavouritesSubtitle,
      load: getIt<WorkspaceApi>().favourites,
      builder: (context, items, set, _) => items.isEmpty
          ? [
              WsEmpty(
                icon: Icons.favorite_rounded,
                hue: AstroPalette.love,
                title: l.wsFavouritesEmpty,
                message: l.wsFavouritesEmptyBody,
              ),
            ]
          : [
              for (final f in items)
                _FavouriteCard(favourite: f, onChanged: set),
            ],
    );
  }
}

class _FavouriteCard extends StatelessWidget {
  const _FavouriteCard({required this.favourite, required this.onChanged});

  final FavouriteCustomer favourite;
  final ValueChanged<List<FavouriteCustomer>> onChanged;

  Future<void> _editNote(BuildContext context) async {
    final l = context.l10n;
    final thread = favourite.conversationId;
    if (thread == null) return;
    final controller = TextEditingController(text: favourite.note);
    final note = await showAppSheet<String>(
      context: context,
      title: l.wsNoteTitle(_nameOr(l, favourite.name)),
      builder: (sheet) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            maxLength: 240,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: l.wsNoteHint),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => Navigator.of(sheet).pop(controller.text),
            child: Text(l.commonSave),
          ),
        ],
      ),
    );
    if (note == null || !context.mounted) return;
    await _run(
      context,
      () => getIt<WorkspaceApi>().setFavourite(thread, note: note),
    );
  }

  Future<void> _run(
    BuildContext context,
    Future<List<FavouriteCustomer>> Function() call,
  ) async {
    try {
      onChanged(await call());
    } catch (e) {
      if (context.mounted) showToast(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final f = favourite;
    final name = _nameOr(l, f.name);
    final thread = f.conversationId;
    return WsCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
      onTap: thread == null
          ? null
          : () => context.push(Routes.chatRoom(thread)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                Text(
                  [
                    l.waitlistRegular(f.sessions),
                    if (f.lastAt != null) TimeFormat.relative(l, f.lastAt),
                  ].join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
                if (f.note.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                    decoration: BoxDecoration(
                      color: brand.tint,
                      borderRadius: BorderRadius.circular(Radii.sm),
                    ),
                    child: Text(
                      f.note,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.onTint,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (thread != null)
            PopupMenuButton<String>(
              tooltip: l.chatMoreOptions,
              onSelected: (v) => v == 'note'
                  ? _editNote(context)
                  : _run(
                      context,
                      () => getIt<WorkspaceApi>().removeFavourite(thread),
                    ),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'note', child: Text(l.wsEditNote)),
                PopupMenuItem(value: 'remove', child: Text(l.wsUnfavourite)),
              ],
            ),
        ],
      ),
    );
  }
}

/// The astrologer's followers: how many, how many joined this week, and the
/// latest names.
class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<Community>(
      title: l.wsCommunity,
      subtitle: l.wsCommunitySubtitle,
      load: getIt<WorkspaceApi>().community,
      builder: (context, c, _, _) {
        final theme = Theme.of(context);
        final brand = context.brand;
        return [
          Row(
            children: [
              _BigStat(
                hue: AstroPalette.love,
                icon: Icons.favorite_rounded,
                value: '${c.count}',
                label: l.wsFollowers,
              ),
              const SizedBox(width: 10),
              _BigStat(
                hue: AstroPalette.health,
                icon: Icons.trending_up_rounded,
                value: '+${c.newThisWeek}',
                label: l.wsNewThisWeek,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (c.followers.isEmpty)
            WsEmpty(
              icon: Icons.groups_rounded,
              hue: AstroPalette.love,
              title: l.wsCommunityEmpty,
              message: l.wsCommunityEmptyBody,
            )
          else
            for (final f in c.followers)
              WsCard(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  children: [
                    HueAvatar(
                      name: _nameOr(l, f.name),
                      hue: AstroPalette.forId(_nameOr(l, f.name)),
                      size: 38,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _nameOr(l, f.name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      l.wsFollowingSince(TimeFormat.relative(l, f.since)),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
        ];
      },
    );
  }
}

class _BigStat extends StatelessWidget {
  const _BigStat({
    required this.hue,
    required this.icon,
    required this.value,
    required this.label,
  });

  final AstroHue hue;
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: HueTile(
        hue: hue,
        radius: Radii.md,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: hue.end),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: context.brand.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The astrologer's invite code: copy it, share it, see who came through it.
class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<ReferralOverview>(
      title: l.wsReferral,
      load: getIt<WorkspaceApi>().referrals,
      builder: (context, r, _, _) {
        final theme = Theme.of(context);
        final brand = context.brand;
        final reward = Money.format(r.referrerBonus, r.currency);
        final gift = Money.format(r.refereeBonus, r.currency);
        return [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.lg),
              boxShadow: brand.shadowCosmic,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Radii.lg),
              child: Stack(
                children: [
                  const Positioned.fill(child: CosmicBackdrop()),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l.wsReferralPitch(reward, gift),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: brand.onCosmic,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Material(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(Radii.md),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(Radii.md),
                            onTap: () async {
                              await Clipboard.setData(
                                ClipboardData(text: r.code),
                              );
                              if (context.mounted) {
                                showToast(context, l.wsCodeCopied);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                12,
                                12,
                                12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      r.code,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            color: brand.gold,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 3,
                                          ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.copy_rounded,
                                    color: brand.onCosmicMuted,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () => Share.share(
                            l.wsReferralShare(r.code, gift, r.inviteLink),
                          ),
                          icon: const Icon(Icons.share_rounded),
                          label: Text(l.wsShareInvite),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _BigStat(
                hue: AstroPalette.career,
                icon: Icons.group_add_rounded,
                value: '${r.total}',
                label: l.wsReferralJoined,
              ),
              const SizedBox(width: 10),
              _BigStat(
                hue: AstroPalette.money,
                icon: Icons.payments_rounded,
                value: Money.format(r.earned, r.currency),
                label: l.wsReferralEarned,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.wsReferralHow,
            style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
          ),
          const SizedBox(height: 14),
          for (final p in r.people)
            WsCard(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      p.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    switch (p.status) {
                      'rewarded' => l.wsReferralRewarded,
                      'void' => l.wsReferralVoid,
                      _ => l.wsReferralPending,
                    },
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: p.status == 'rewarded'
                          ? brand.online
                          : brand.inkMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ];
      },
    );
  }
}
