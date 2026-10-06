import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/data/consultation_api.dart';
import '../../../consultations/data/models/saved_reply.dart';
import '../../data/workspace_api.dart';
import '../widgets/async_page.dart';

/// Photos on the astrologer's public profile: add from the phone, remove.
class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  bool _busy = false;

  Future<void> _add(void Function(Gallery) set) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    setState(() => _busy = true);
    try {
      set(await getIt<WorkspaceApi>().addPhoto(picked.path));
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _remove(GalleryPhoto photo, void Function(Gallery) set) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(l.wsPhotoRemoveTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(l.wsRemove),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      set(await getIt<WorkspaceApi>().removePhoto(photo.id));
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<Gallery>(
      title: l.wsGallery,
      subtitle: l.wsGallerySubtitle,
      load: getIt<WorkspaceApi>().gallery,
      builder: (context, gallery, set, _) {
        final brand = context.brand;
        return [
          Text(
            l.wsGalleryCount(gallery.photos.length, gallery.max),
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: brand.inkMuted),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              for (final p in gallery.photos)
                ClipRRect(
                  borderRadius: BorderRadius.circular(Radii.sm),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        p.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => ColoredBox(
                          color: brand.tint,
                          child: Icon(
                            Icons.broken_image_rounded,
                            color: brand.inkMuted,
                          ),
                        ),
                      ),
                      if (p.pending || p.rejected)
                        GestureDetector(
                          // A rejected photo says why when tapped.
                          onTap: p.rejected && p.reviewNote.isNotEmpty
                              ? () => showToast(context, p.reviewNote)
                              : null,
                          child: ColoredBox(
                            color: Colors.black54,
                            child: Center(
                              child: Text(
                                p.pending
                                    ? l.wsPhotoPending
                                    : l.wsPhotoRejected,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: IconButton.filledTonal(
                          visualDensity: VisualDensity.compact,
                          iconSize: 16,
                          tooltip: l.wsRemove,
                          onPressed: () => _remove(p, set),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
              if (!gallery.full)
                Material(
                  color: brand.tint,
                  borderRadius: BorderRadius.circular(Radii.sm),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Radii.sm),
                    onTap: _busy ? null : () => _add(set),
                    child: Center(
                      child: _busy
                          ? const SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_a_photo_rounded,
                                  color: brand.onTint,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l.wsAddPhoto,
                                  style: TextStyle(
                                    color: brand.onTint,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (gallery.requiresApproval)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                l.wsGalleryReviewed,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: brand.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Text(
            l.wsGalleryRules,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: brand.inkMuted),
          ),
        ];
      },
    );
  }
}

/// Categories the backend accepts for feedback.
const kFeedbackCategories = [
  'bug',
  'suggestion',
  'payments',
  'customers',
  'other',
];

String feedbackCategoryLabel(AppLocalizations l, String key) => switch (key) {
  'bug' => l.wsFeedbackBug,
  'suggestion' => l.wsFeedbackSuggestion,
  'payments' => l.wsFeedbackPayments,
  'customers' => l.wsFeedbackCustomers,
  _ => l.wsFeedbackOther,
};

/// Tell the platform something, and read what it said back.
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _message = TextEditingController();
  String _category = 'suggestion';
  bool _sending = false;

  /// Sent along so a bug report says which build it came from. Read once, up
  /// front: sending must not wait on it, or fail because of it.
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform()
        .then((info) => _version = '${info.version}+${info.buildNumber}')
        .catchError((_) => _version);
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send(Future<void> Function() reload) async {
    final l = context.l10n;
    final text = _message.text.trim();
    if (text.length < 10) {
      showToast(context, l.wsFeedbackTooShort);
      return;
    }
    setState(() => _sending = true);
    try {
      await getIt<WorkspaceApi>().sendFeedback(
        category: _category,
        message: text,
        appVersion: _version,
      );
      _message.clear();
      await reload();
      if (mounted) showToast(context, l.wsFeedbackSent);
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<List<FeedbackItem>>(
      title: l.wsFeedback,
      subtitle: l.wsFeedbackSubtitle,
      load: getIt<WorkspaceApi>().feedback,
      builder: (context, items, _, reload) {
        final theme = Theme.of(context);
        final brand = context.brand;
        return [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in kFeedbackCategories)
                ChoiceChip(
                  label: Text(feedbackCategoryLabel(l, c)),
                  selected: c == _category,
                  onSelected: (_) => setState(() => _category = c),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _message,
            minLines: 4,
            maxLines: 8,
            maxLength: 4000,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: l.wsFeedbackHint),
          ),
          BusyButton(
            label: l.wsFeedbackSend,
            icon: Icons.send_rounded,
            busy: _sending,
            onPressed: () => _send(reload),
          ),
          if (items.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l.wsFeedbackEarlier,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: brand.inkMuted,
              ),
            ),
            const SizedBox(height: 10),
            for (final f in items)
              WsCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${feedbackCategoryLabel(l, f.category)} · '
                      '${TimeFormat.relative(l, f.createdAt)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(f.message, style: theme.textTheme.bodyMedium),
                    if (f.reply.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: brand.tint,
                          borderRadius: BorderRadius.circular(Radii.sm),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.wsFeedbackReply,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: brand.onTint,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              f.reply,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: brand.onTint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ];
      },
    );
  }
}

/// The astrologer's canned replies, managed in one place instead of only from
/// inside a chat.
class QuickRepliesPage extends StatelessWidget {
  const QuickRepliesPage({super.key});

  Future<void> _add(
    BuildContext context,
    Future<void> Function() reload,
  ) async {
    final l = context.l10n;
    final controller = TextEditingController();
    final body = await showAppSheet<String>(
      context: context,
      title: l.wsReplyNew,
      builder: (sheet) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            minLines: 2,
            maxLines: 5,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: l.wsReplyHint),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => Navigator.of(sheet).pop(controller.text.trim()),
            child: Text(l.commonSave),
          ),
        ],
      ),
    );
    if (body == null || body.isEmpty || !context.mounted) return;
    try {
      await getIt<ConsultationApi>().createSavedReply(body);
      await reload();
    } catch (e) {
      if (context.mounted) showToast(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<List<SavedReply>>(
      title: l.wsReplies,
      subtitle: l.wsRepliesSubtitle,
      load: getIt<ConsultationApi>().savedReplies,
      bottomBar: (context, reload) => StickyActionBar(
        child: BusyButton(
          label: l.wsReplyNew,
          icon: Icons.add_rounded,
          onPressed: () => _add(context, reload),
        ),
      ),
      builder: (context, replies, _, reload) => replies.isEmpty
          ? [
              WsEmpty(
                icon: Icons.quickreply_rounded,
                hue: AstroPalette.air,
                title: l.wsRepliesEmpty,
                message: l.wsRepliesSubtitle,
              ),
            ]
          : [
              for (final r in replies)
                WsCard(
                  padding: const EdgeInsets.fromLTRB(14, 6, 4, 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.body),
                            if (r.useCount > 0)
                              Text(
                                l.wsReplyUsed(r.useCount),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: context.brand.inkMuted),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l.wsRemove,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () async {
                          try {
                            await getIt<ConsultationApi>().deleteSavedReply(
                              r.id,
                            );
                            await reload();
                          } catch (e) {
                            if (context.mounted) {
                              showToast(context, friendlyError(e));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
            ],
    );
  }
}
