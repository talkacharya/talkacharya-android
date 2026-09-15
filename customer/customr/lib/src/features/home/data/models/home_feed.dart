import '../../../astrologers/data/models/astrologer.dart';
import 'home_consultation.dart';
import 'home_promo.dart';
import 'live_stream_card.dart';

/// `GET /app/home` — the curated feed. One round-trip for the sections that
/// don't depend on the active birth profile.
class HomeFeed {
  const HomeFeed({
    this.featured = const [],
    this.onlineNow = const [],
    this.liveNow = const [],
    this.categories = const [],
    this.resume,
    this.promos = const [],
  });

  final List<Astrologer> featured;
  final List<Astrologer> onlineNow;
  final List<LiveStreamCard> liveNow;
  final List<AstrologerSkill> categories;
  final HomeConsultation? resume;
  final List<PromoSlide> promos;

  /// Featured astrologers first, then the recommended list, de-duped by id.
  List<Astrologer> get astrologerRail {
    final seen = <String>{};
    return [
      for (final a in [...featured, ...onlineNow])
        if (seen.add(a.id)) a,
    ];
  }

  factory HomeFeed.fromJson(Map<String, dynamic> json) {
    List<Astrologer> people(String key) =>
        (json[key] as List<dynamic>? ?? const [])
            .map((e) => Astrologer.fromJson(e as Map<String, dynamic>))
            .toList();

    final resumeJson = json['resume'];
    return HomeFeed(
      featured: people('featured'),
      onlineNow: people('online_now'),
      liveNow: (json['live_now'] as List<dynamic>? ?? const [])
          .map((e) => LiveStreamCard.fromJson(e as Map<String, dynamic>))
          .where((s) => s.id.isNotEmpty)
          .toList(),
      categories: (json['categories'] as List<dynamic>? ?? const [])
          .map((e) => AstrologerSkill.fromJson(e as Map<String, dynamic>))
          .toList(),
      resume: resumeJson is Map<String, dynamic>
          ? HomeConsultation.fromJson(resumeJson)
          : null,
      promos: (json['promos'] as List<dynamic>? ?? const []).indexed
          .map(
            (e) =>
                PromoSlide.fromJson(e.$2 as Map<String, dynamic>, index: e.$1),
          )
          .toList(),
    );
  }
}
