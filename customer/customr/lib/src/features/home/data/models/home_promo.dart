import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// A slide in the home promo rail.
///
/// The rail renders whatever kind of slide the feed hands it — a styled text
/// card ([RichPromo]), a full-bleed image ([ImagePromo]), an inline video
/// ([VideoPromo]) or a fully custom widget ([WidgetPromo]) — so a new promo
/// format only needs a new subclass here and a `case` in `promo_carousel.dart`.
sealed class PromoSlide extends Equatable {
  const PromoSlide({required this.id, this.deeplink});

  final String id;

  /// A `talkacharya://…` or `/route` location to open on tap.
  final String? deeplink;

  /// Build a slide from one `GET /app/home → promos[]` entry. Dispatches on
  /// `media_type` (`"image"` | `"video"` | `"rich"`); when it's absent the kind
  /// is inferred from whichever media URL is present, else a rich card.
  factory PromoSlide.fromJson(Map<String, dynamic> json, {int index = 0}) {
    final id = '${json['code'] ?? json['id'] ?? 'promo-$index'}';
    final deeplink = (json['deeplink'] as String?) ?? '/wallet';
    final title = '${json['title'] ?? ''}'.trim();
    final subtitle = '${json['subtitle'] ?? json['description'] ?? ''}'.trim();
    final cta = '${json['cta'] ?? ''}'.trim();
    final image =
        (json['image_url'] ?? json['image'] ?? json['media_url']) as String?;
    final video = (json['video_url'] ?? json['video']) as String?;
    final hasImage = image != null && image.isNotEmpty;
    final hasVideo = video != null && video.isNotEmpty;
    final mediaType =
        '${json['media_type'] ?? (hasVideo ? 'video' : (hasImage ? 'image' : 'rich'))}';

    switch (mediaType) {
      case 'video' when hasVideo:
        return VideoPromo(
          id: id,
          deeplink: deeplink,
          videoUrl: video,
          posterUrl: hasImage ? image : null,
          title: title.isEmpty ? null : title,
          cta: cta.isEmpty ? null : cta,
        );
      case 'image' when hasImage:
        return ImagePromo(
          id: id,
          deeplink: deeplink,
          imageUrl: image,
          title: title.isEmpty ? null : title,
          subtitle: subtitle.isEmpty ? null : subtitle,
          cta: cta.isEmpty ? null : cta,
        );
      default:
        return RichPromo(
          id: id,
          deeplink: deeplink,
          title: title,
          subtitle: subtitle,
          cta: cta.isEmpty ? 'Claim' : cta,
          tone: PromoTone.values[index % PromoTone.values.length],
        );
    }
  }
}

/// The default: a warm colour-blocked card with a headline, one line of copy
/// and a pill CTA. No `/app/home` media required.
class RichPromo extends PromoSlide {
  const RichPromo({
    required super.id,
    required this.title,
    required this.subtitle,
    required this.cta,
    super.deeplink,
    this.tone = PromoTone.night,
  });

  final String title;
  final String subtitle;
  final String cta;
  final PromoTone tone;

  @override
  List<Object?> get props => [id, title, subtitle, cta, deeplink, tone];
}

/// A full-bleed image with an optional headline / CTA overlaid on a scrim.
class ImagePromo extends PromoSlide {
  const ImagePromo({
    required super.id,
    required this.imageUrl,
    super.deeplink,
    this.title,
    this.subtitle,
    this.cta,
  });

  final String imageUrl;
  final String? title;
  final String? subtitle;
  final String? cta;

  bool get hasOverlay =>
      (title?.isNotEmpty ?? false) ||
      (subtitle?.isNotEmpty ?? false) ||
      (cta?.isNotEmpty ?? false);

  @override
  List<Object?> get props => [id, imageUrl, title, subtitle, cta, deeplink];
}

/// An inline, muted, looping video that plays while its slide is the active one
/// and pauses otherwise. Falls back to [posterUrl] (or a plain fill) until the
/// first frame is ready, and if playback can't start.
class VideoPromo extends PromoSlide {
  const VideoPromo({
    required super.id,
    required this.videoUrl,
    super.deeplink,
    this.posterUrl,
    this.title,
    this.cta,
  });

  final String videoUrl;
  final String? posterUrl;
  final String? title;
  final String? cta;

  @override
  List<Object?> get props => [id, videoUrl, posterUrl, title, cta, deeplink];
}

/// A slide the app supplies directly — a seasonal illustration, an announcement,
/// an interactive teaser. Never produced by [PromoSlide.fromJson]; add it to the
/// list the repository returns.
class WidgetPromo extends PromoSlide {
  const WidgetPromo({required super.id, required this.builder, super.deeplink});

  final WidgetBuilder builder;

  @override
  List<Object?> get props => [id];
}

enum PromoTone { night, saffron, calm }
