import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../../../core/l10n/l10n.dart';
import 'live_chat_image.dart';

/// Photos on the call on air — a chart, a remedy, the caller's palm — shared
/// between the astrologer and the caller only, in a small strip above the call
/// panel. The stream's chat is text; nobody else watching sees these.
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

  /// Who else sees them: the caller.
  final String peerName;
  final Future<void> Function(String path) onSend;

  Future<void> _add(BuildContext context) async {
    final l = context.l10n;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: Text(l.liveCallPhotoCamera),
              onTap: () => Navigator.pop(sheet, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(l.liveCallPhotoGallery),
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
                  return Tooltip(
                    message: l.liveSendPhoto,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: sending ? null : () => _add(context),
                        child: SizedBox.square(
                          dimension: 56,
                          child: sending
                              ? const Center(
                                  child: SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.add_a_photo_rounded,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  );
                }
                // newest next to the add button
                final photo = photos[photos.length - i];
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
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
