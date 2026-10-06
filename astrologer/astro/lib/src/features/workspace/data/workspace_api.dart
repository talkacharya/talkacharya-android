import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/util/json.dart';

Map<String, dynamic> _map(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : const {};

List<T> _list<T>(Object? v, T Function(Map<String, dynamic>) parse) => [
  for (final e in v as List? ?? const []) parse(_map(e)),
];

/// A notice from the platform.
class Announcement extends Equatable {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.linkUrl,
    required this.pinned,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final String body;
  final String linkUrl;
  final bool pinned;
  final DateTime? publishedAt;

  factory Announcement.fromJson(Map<String, dynamic> j) => Announcement(
    id: '${j['id']}',
    title: j['title'] as String? ?? '',
    body: j['body'] as String? ?? '',
    linkUrl: j['link_url'] as String? ?? '',
    pinned: j['is_pinned'] == true,
    publishedAt: DateTime.tryParse('${j['published_at']}'),
  );

  @override
  List<Object?> get props => [id, title, body, linkUrl, pinned, publishedAt];
}

class TrainingVideo extends Equatable {
  const TrainingVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnail,
    required this.durationSeconds,
    required this.category,
    required this.isNew,
  });

  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String? thumbnail;
  final int durationSeconds;
  final String category;
  final bool isNew;

  factory TrainingVideo.fromJson(Map<String, dynamic> j) => TrainingVideo(
    id: '${j['id']}',
    title: j['title'] as String? ?? '',
    description: j['description'] as String? ?? '',
    videoUrl: j['video_url'] as String? ?? '',
    thumbnail: j['thumbnail'] as String?,
    durationSeconds: (j['duration_seconds'] as num?)?.toInt() ?? 0,
    category: j['category'] as String? ?? '',
    isNew: j['is_new'] == true,
  );

  @override
  List<Object?> get props => [id, title, videoUrl, category, isNew];
}

/// A customer the astrologer marked, with their private note.
class FavouriteCustomer extends Equatable {
  const FavouriteCustomer({
    required this.conversationId,
    required this.name,
    required this.note,
    required this.sessions,
    required this.lastAt,
  });

  final String? conversationId;
  final String name;
  final String note;
  final int sessions;
  final DateTime? lastAt;

  factory FavouriteCustomer.fromJson(Map<String, dynamic> j) =>
      FavouriteCustomer(
        conversationId: j['conversation'] as String?,
        name: j['name'] as String? ?? '',
        note: j['note'] as String? ?? '',
        sessions: (j['sessions'] as num?)?.toInt() ?? 0,
        lastAt: DateTime.tryParse('${j['last_at']}'),
      );

  @override
  List<Object?> get props => [conversationId, name, note, sessions, lastAt];
}

class GalleryPhoto extends Equatable {
  const GalleryPhoto({
    required this.id,
    required this.image,
    required this.caption,
    required this.status,
    this.reviewNote = '',
  });

  final String id;
  final String image;
  final String caption;

  /// `pending` (waiting for a reviewer), `approved` (on the public profile)
  /// or `rejected`.
  final String status;

  /// What the reviewer asked to be changed, on a rejected photo.
  final String reviewNote;

  bool get pending => status == 'pending';
  bool get rejected => status == 'rejected';

  factory GalleryPhoto.fromJson(Map<String, dynamic> j) => GalleryPhoto(
    id: '${j['id']}',
    image: j['image'] as String? ?? '',
    caption: j['caption'] as String? ?? '',
    status: j['status'] as String? ?? 'approved',
    reviewNote: j['review_note'] as String? ?? '',
  );

  @override
  List<Object?> get props => [id, image, caption, status, reviewNote];
}

class Gallery extends Equatable {
  const Gallery({
    this.max = 8,
    this.photos = const [],
    this.requiresApproval = false,
  });

  final int max;
  final List<GalleryPhoto> photos;

  /// New photos wait for a reviewer before customers see them.
  final bool requiresApproval;

  bool get full => photos.length >= max;

  factory Gallery.fromJson(Map<String, dynamic> j) => Gallery(
    max: (j['max'] as num?)?.toInt() ?? 8,
    photos: _list(j['photos'], GalleryPhoto.fromJson),
    requiresApproval: j['requires_approval'] == true,
  );

  @override
  List<Object?> get props => [max, photos, requiresApproval];
}

class FeedbackItem extends Equatable {
  const FeedbackItem({
    required this.id,
    required this.category,
    required this.message,
    required this.status,
    required this.reply,
    required this.createdAt,
  });

  final String id;
  final String category;
  final String message;
  final String status;
  final String reply;
  final DateTime? createdAt;

  factory FeedbackItem.fromJson(Map<String, dynamic> j) => FeedbackItem(
    id: '${j['id']}',
    category: j['category'] as String? ?? 'other',
    message: j['message'] as String? ?? '',
    status: j['status'] as String? ?? 'open',
    reply: j['reply'] as String? ?? '',
    createdAt: DateTime.tryParse('${j['created_at']}'),
  );

  @override
  List<Object?> get props => [id, category, message, status, reply, createdAt];
}

class Follower extends Equatable {
  const Follower({required this.name, required this.since});

  final String name;
  final DateTime? since;

  @override
  List<Object?> get props => [name, since];
}

class Community extends Equatable {
  const Community({
    this.count = 0,
    this.newThisWeek = 0,
    this.followers = const [],
  });

  final int count;
  final int newThisWeek;
  final List<Follower> followers;

  factory Community.fromJson(Map<String, dynamic> j) => Community(
    count: (j['count'] as num?)?.toInt() ?? 0,
    newThisWeek: (j['new_this_week'] as num?)?.toInt() ?? 0,
    followers: _list(
      j['followers'],
      (f) => Follower(
        name: f['name'] as String? ?? '',
        since: DateTime.tryParse('${f['since']}'),
      ),
    ),
  );

  @override
  List<Object?> get props => [count, newThisWeek, followers];
}

class ReferredPerson extends Equatable {
  const ReferredPerson({
    required this.name,
    required this.status,
    required this.createdAt,
  });

  final String name;

  /// `pending`, `qualified`, `rewarded` or `void`.
  final String status;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [name, status, createdAt];
}

class ReferralOverview extends Equatable {
  const ReferralOverview({
    required this.code,
    required this.inviteLink,
    required this.total,
    required this.pending,
    required this.rewarded,
    required this.earned,
    required this.currency,
    required this.refereeBonus,
    required this.referrerBonus,
    required this.people,
  });

  final String code;
  final String inviteLink;
  final int total;
  final int pending;
  final int rewarded;
  final double earned;
  final String currency;

  /// What the person invited gets, and what the astrologer gets for them.
  final double refereeBonus;
  final double referrerBonus;
  final List<ReferredPerson> people;

  factory ReferralOverview.fromJson(Map<String, dynamic> j) => ReferralOverview(
    code: j['code'] as String? ?? '',
    inviteLink: j['invite_link'] as String? ?? '',
    total: (j['total'] as num?)?.toInt() ?? 0,
    pending: (j['pending'] as num?)?.toInt() ?? 0,
    rewarded: (j['rewarded'] as num?)?.toInt() ?? 0,
    earned: toDouble(j['earned']),
    currency: j['currency'] as String? ?? 'INR',
    refereeBonus: toDouble(j['referee_bonus']),
    referrerBonus: toDouble(j['referrer_bonus']),
    people: _list(
      j['referrals'],
      (r) => ReferredPerson(
        name: r['referee_name'] as String? ?? '',
        status: r['status'] as String? ?? 'pending',
        createdAt: DateTime.tryParse('${r['created_at']}'),
      ),
    ),
  );

  @override
  List<Object?> get props => [code, total, pending, rewarded, earned, people];
}

/// Everything in the astrologer's own corner of the app that is not a
/// session: notices, training, favourites, gallery, feedback, followers,
/// referrals.
/// A discount the astrologer runs on their own rates, and what it brought in.
class AstroOffer extends Equatable {
  const AstroOffer({
    required this.id,
    required this.percentOff,
    required this.channels,
    required this.audience,
    required this.startsAt,
    required this.endsAt,
    required this.isLive,
    required this.sessions,
    required this.earned,
  });

  final String id;
  final int percentOff;

  /// chat / voice / video it covers; empty means all of them.
  final List<String> channels;
  final String audience; // everyone | new
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool isLive;
  final int sessions;
  final double earned;

  factory AstroOffer.fromJson(Map<String, dynamic> j) => AstroOffer(
    id: '${j['id']}',
    percentOff: (j['percent_off'] as num?)?.toInt() ?? 0,
    channels: [for (final c in j['channels'] as List? ?? const []) '$c'],
    audience: j['audience'] as String? ?? 'everyone',
    startsAt: DateTime.tryParse('${j['starts_at']}'),
    endsAt: DateTime.tryParse('${j['ends_at']}'),
    isLive: j['is_live'] == true,
    sessions: (j['sessions'] as num?)?.toInt() ?? 0,
    earned: double.tryParse('${j['earned']}') ?? 0,
  );

  @override
  List<Object?> get props => [
    id,
    percentOff,
    channels,
    audience,
    startsAt,
    endsAt,
    isLive,
    sessions,
    earned,
  ];
}

/// The offers page: what the platform allows, the offer running now, and
/// the earlier ones.
class OffersOverview extends Equatable {
  const OffersOverview({
    required this.enabled,
    required this.percentChoices,
    required this.hourChoices,
    required this.live,
    required this.past,
  });

  final bool enabled;
  final List<int> percentChoices;
  final List<int> hourChoices;
  final AstroOffer? live;
  final List<AstroOffer> past;

  factory OffersOverview.fromJson(Map<String, dynamic> j) {
    final limits = _map(j['limits']);
    List<int> ints(Object? v) => [
      for (final e in v as List? ?? const [])
        if (e is num) e.toInt(),
    ];
    return OffersOverview(
      enabled: limits['enabled'] != false,
      percentChoices: ints(limits['percent_choices']),
      hourChoices: ints(limits['hour_choices']),
      live: j['live'] is Map ? AstroOffer.fromJson(_map(j['live'])) : null,
      past: _list(j['past'], AstroOffer.fromJson),
    );
  }

  @override
  List<Object?> get props => [enabled, percentChoices, hourChoices, live, past];
}

class WorkspaceApi {
  WorkspaceApi(this._dio);

  final Dio _dio;

  Future<List<Announcement>> announcements() async => _list(
    (await _dio.get<dynamic>(ApiPaths.astroAnnouncements)).ensureOk().data,
    Announcement.fromJson,
  );

  Future<List<TrainingVideo>> trainingVideos() async => _list(
    (await _dio.get<dynamic>(ApiPaths.astroTrainingVideos)).ensureOk().data,
    TrainingVideo.fromJson,
  );

  Future<List<FavouriteCustomer>> favourites() async => _list(
    (await _dio.get<dynamic>(ApiPaths.astroFavourites)).ensureOk().data,
    FavouriteCustomer.fromJson,
  );

  /// Marks the customer of [conversationId] a favourite, or updates the note.
  Future<List<FavouriteCustomer>> setFavourite(
    String conversationId, {
    String note = '',
  }) async => _list(
    (await _dio.put<dynamic>(
      ApiPaths.astroFavourite(conversationId),
      data: {'note': note.trim()},
    )).ensureOk().data,
    FavouriteCustomer.fromJson,
  );

  Future<List<FavouriteCustomer>> removeFavourite(
    String conversationId,
  ) async => _list(
    (await _dio.delete<dynamic>(
      ApiPaths.astroFavourite(conversationId),
    )).ensureOk().data,
    FavouriteCustomer.fromJson,
  );

  Future<Gallery> gallery() async => Gallery.fromJson(
    _map((await _dio.get<dynamic>(ApiPaths.astroPhotos)).ensureOk().data),
  );

  Future<Gallery> addPhoto(String filePath, {String caption = ''}) async {
    final form = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
      'caption': caption.trim(),
    });
    final res = (await _dio.post<dynamic>(
      ApiPaths.astroPhotos,
      data: form,
    )).ensureOk();
    return Gallery.fromJson(_map(res.data));
  }

  Future<Gallery> removePhoto(String id) async => Gallery.fromJson(
    _map((await _dio.delete<dynamic>(ApiPaths.astroPhoto(id))).ensureOk().data),
  );

  Future<List<FeedbackItem>> feedback() async => _list(
    (await _dio.get<dynamic>(ApiPaths.astroFeedback)).ensureOk().data,
    FeedbackItem.fromJson,
  );

  Future<void> sendFeedback({
    required String category,
    required String message,
    String appVersion = '',
  }) async {
    (await _dio.post<dynamic>(
      ApiPaths.astroFeedback,
      data: {
        'category': category,
        'message': message.trim(),
        'app_version': appVersion,
      },
    )).ensureOk();
  }

  Future<Community> community() async => Community.fromJson(
    _map((await _dio.get<dynamic>(ApiPaths.astroFollowers)).ensureOk().data),
  );

  Future<ReferralOverview> referrals() async => ReferralOverview.fromJson(
    _map((await _dio.get<dynamic>(ApiPaths.astroReferrals)).ensureOk().data),
  );

  Future<OffersOverview> offers() async => OffersOverview.fromJson(
    _map((await _dio.get<dynamic>(ApiPaths.astroOffers)).ensureOk().data),
  );

  /// Starts an offer now. [channels] empty means every channel.
  Future<void> startOffer({
    required int percentOff,
    required int hours,
    String audience = 'everyone',
    List<String> channels = const [],
  }) async {
    (await _dio.post<dynamic>(
      ApiPaths.astroOffers,
      data: {
        'percent_off': percentOff,
        'hours': hours,
        'audience': audience,
        'channels': channels,
      },
    )).ensureOk();
  }

  Future<void> endOffer(String id) async {
    (await _dio.delete<dynamic>(ApiPaths.astroOffer(id))).ensureOk();
  }
}
