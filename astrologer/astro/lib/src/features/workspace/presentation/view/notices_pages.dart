import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../home/presentation/cubit/tool_counts_cubit.dart';
import '../../../performance/presentation/widgets/perf_format.dart';
import '../../data/workspace_api.dart';
import '../widgets/async_page.dart';

/// Opens [url] outside the app; says so if nothing on the phone can.
Future<void> openLink(BuildContext context, String url) async {
  final l = context.l10n;
  final uri = Uri.tryParse(url);
  var ok = false;
  if (uri != null) {
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
  if (!ok && context.mounted) showToast(context, l.wsCantOpen);
}

/// Notices from the platform, pinned ones first.
class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  @override
  void initState() {
    super.initState();
    // Reading the list is what clears the badge on its Home tile.
    if (getIt.isRegistered<ToolCountsCubit>()) {
      getIt<ToolCountsCubit>().markAnnouncementsSeen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<List<Announcement>>(
      title: l.wsAnnouncements,
      load: getIt<WorkspaceApi>().announcements,
      builder: (context, items, _, _) => items.isEmpty
          ? [
              WsEmpty(
                icon: Icons.campaign_rounded,
                hue: AstroPalette.money,
                title: l.wsAnnouncementsEmpty,
                message: l.wsAnnouncementsEmptyBody,
              ),
            ]
          : [for (final a in items) _AnnouncementCard(item: a)],
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.item});

  final Announcement item;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final a = item;
    return WsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (a.pinned) ...[
                Icon(
                  Icons.push_pin_rounded,
                  size: 15,
                  color: AstroPalette.money.end,
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  a.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                TimeFormat.relative(l, a.publishedAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            a.body,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
          if (a.linkUrl.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () => openLink(context, a.linkUrl),
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: Text(l.wsReadMore),
              ),
            ),
        ],
      ),
    );
  }
}

/// How-to videos, grouped by shelf; each opens in the phone's video app.
class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<List<TrainingVideo>>(
      title: l.wsTraining,
      subtitle: l.wsTrainingSubtitle,
      load: getIt<WorkspaceApi>().trainingVideos,
      builder: (context, videos, _, _) {
        if (videos.isEmpty) {
          return [
            WsEmpty(
              icon: Icons.play_circle_rounded,
              hue: AstroPalette.fire,
              title: l.wsTrainingEmpty,
              message: l.wsTrainingEmptyBody,
            ),
          ];
        }
        // Shelves in the order their first video appears.
        final shelves = <String, List<TrainingVideo>>{};
        for (final v in videos) {
          shelves.putIfAbsent(v.category, () => []).add(v);
        }
        return [
          for (final shelf in shelves.entries) ...[
            if (shelf.key.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: Text(
                  shelf.key,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.brand.inkMuted,
                  ),
                ),
              ),
            for (final v in shelf.value) _VideoCard(video: v),
          ],
        ];
      },
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.video});

  final TrainingVideo video;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final v = video;
    const hue = AstroPalette.fire;
    final thumb = v.thumbnail;
    return WsCard(
      padding: const EdgeInsets.all(10),
      onTap: () => openLink(context, v.videoUrl),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.sm),
            child: SizedBox(
              width: 104,
              height: 64,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (thumb != null && thumb.isNotEmpty)
                    Image.network(
                      thumb,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => DecoratedBox(
                        decoration: BoxDecoration(gradient: hue.linear()),
                      ),
                    )
                  else
                    DecoratedBox(
                      decoration: BoxDecoration(gradient: hue.linear()),
                    ),
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  v.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (v.durationSeconds > 0)
                      Text(
                        formatDuration(l, v.durationSeconds),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                    if (v.isNew) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: hue.end,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l.wsNew,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
