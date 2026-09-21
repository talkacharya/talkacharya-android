import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/config/flavor.dart';
import '../../../../../core/di/service_locator.dart';

/// Stored media can come back as a `/media/...` path (local filesystem storage)
/// or a full URL (S3/MinIO). Resolve the first against the API origin.
String resolveMediaUrl(String url) {
  if (url.isEmpty || url.startsWith('http')) return url;
  final base = Uri.parse(getIt<AppConfig>().apiBaseUrl);
  return Uri(
    scheme: base.scheme,
    host: base.host,
    port: base.hasPort ? base.port : null,
    path: url,
  ).toString();
}

/// A picture sent in the live chat: a small rounded thumbnail that opens
/// full-screen on tap.
class LiveChatImage extends StatelessWidget {
  const LiveChatImage({required this.url, this.width = 150, super.key});

  final String url;
  final double width;

  @override
  Widget build(BuildContext context) {
    final resolved = resolveMediaUrl(url);
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => _FullScreenImage(url: resolved),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: resolved,
            width: width,
            fit: BoxFit.cover,
            placeholder: (_, _) => _Box(width: width, child: const _Spinner()),
            errorWidget: (_, _, _) => _Box(
              width: width,
              child: const Icon(
                Icons.broken_image_outlined,
                color: Colors.white54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: width * 0.66,
    color: Colors.white.withValues(alpha: 0.12),
    alignment: Alignment.center,
    child: child,
  );
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) => const SizedBox.square(
    dimension: 20,
    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
  );
}

class _FullScreenImage extends StatelessWidget {
  const _FullScreenImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    body: Center(
      child: InteractiveViewer(
        maxScale: 5,
        child: CachedNetworkImage(imageUrl: url),
      ),
    ),
  );
}

/// The picked-but-not-yet-sent picture sitting above the composer.
class LiveChatImagePreview extends StatelessWidget {
  const LiveChatImagePreview({
    required this.path,
    required this.onRemove,
    super.key,
  });

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(path),
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: -8,
                right: -8,
                child: IconButton(
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onRemove,
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
