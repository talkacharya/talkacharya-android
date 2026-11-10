import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../../../core/l10n/l10n.dart';
import 'live_chat_image.dart';

/// Photos on a live call — a palm, a chart, a document — shared between the
/// caller and the astrologer only, in a small strip above the call bar. The
/// stream's chat is text; nobody else watching sees these.
class CallPhotoStrip extends StatelessWidget {
  const CallPhotoStrip({
    required this.photos,
    required this.sending,
    required this.peerName,
    required this.onSend,
    super.key,
  });

  final List<LiveCallPhoto> photos;
  final bool sending;

  /// Who else sees them: the astrologer.
  final String peerName;
  final Future<void> Function(String path) onSend;

  Future<void> _add(BuildContext context) async {
    final l = context.l10n;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF1B0F3B),
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_camera_rounded,
                color: Colors.white,
              ),
              title: Text(
                l.liveCallPhotoCamera,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(sheet, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_rounded,
                color: Colors.white,
              ),
              title: Text(
                l.liveCallPhotoGallery,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(sheet, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked != null) await onSend(picked.path);
    } on Object {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.livePhotoFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_rounded, size: 12, color: Colors.white70),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  l.liveCallPhotosTitle(peerName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return _AddTile(
                    busy: sending,
                    label: l.liveSendPhoto,
                    onTap: sending ? null : () => _add(context),
                  );
                }
                // newest next to the add button
                final photo = photos[photos.length - i];
                return _Thumb(photo: photo);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.busy, required this.label, this.onTap});

  final bool busy;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Material(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: SizedBox.square(
            dimension: 56,
            child: busy
                ? const Center(
                    child: SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const Icon(Icons.add_a_photo_rounded, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.photo});

  final LiveCallPhoto photo;

  @override
  Widget build(BuildContext context) {
    final url = resolveMediaUrl(photo.imageUrl);
    return GestureDetector(
      onTap: () => openLiveImage(context, url),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: photo.fromHost
                ? const Color(0xFFFFC53D)
                : Colors.white.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) =>
              const Icon(Icons.broken_image_outlined, color: Colors.white54),
        ),
      ),
    );
  }
}
