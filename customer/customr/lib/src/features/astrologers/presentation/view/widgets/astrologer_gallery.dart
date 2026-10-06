import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../data/models/astrologer.dart';

/// The astrologer's own photos on their profile: a rail of thumbnails that
/// opens full screen. Leaves itself out when they have none.
class AstrologerGallery extends StatelessWidget {
  const AstrologerGallery({required this.photos, super.key});

  final List<AstrologerPhoto> photos;

  static const _thumb = 104.0;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return const SizedBox.shrink();
    final brand = context.brand;
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: brand.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.astroGalleryTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${photos.length}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: _thumb,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: photos.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) => Semantics(
                button: true,
                image: true,
                label: photos[i].caption.isEmpty
                    ? context.l10n.astroGalleryPhoto(i + 1, photos.length)
                    : photos[i].caption,
                child: GestureDetector(
                  onTap: () => _open(context, i),
                  child: Hero(
                    tag: _heroTag(photos[i]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox.square(
                        dimension: _thumb,
                        child: _Photo(url: photos[i].image, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, int index) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, _, _) =>
            GalleryViewer(photos: photos, initialIndex: index),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }
}

String _heroTag(AstrologerPhoto p) => 'astro-gallery:${p.image}';

class _Photo extends StatelessWidget {
  const _Photo({required this.url, required this.fit});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (_, _) => ColoredBox(color: brand.tint),
      errorWidget: (_, _, _) => ColoredBox(
        color: brand.tint,
        child: Icon(Icons.broken_image_rounded, color: brand.inkMuted),
      ),
    );
  }
}

/// Full-screen, swipeable, pinch-to-zoom view of the gallery.
class GalleryViewer extends StatefulWidget {
  const GalleryViewer({required this.photos, this.initialIndex = 0, super.key});

  final List<AstrologerPhoto> photos;
  final int initialIndex;

  @override
  State<GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer> {
  late final _controller = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final photos = widget.photos;
    final caption = photos[_index].caption;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: photos.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => InteractiveViewer(
                maxScale: 4,
                child: Center(
                  child: Hero(
                    tag: _heroTag(photos[i]),
                    child: _Photo(url: photos[i].image, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).closeButtonTooltip,
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l.astroGalleryPhoto(_index + 1, photos.length),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (caption.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                      child: Text(
                        caption,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
