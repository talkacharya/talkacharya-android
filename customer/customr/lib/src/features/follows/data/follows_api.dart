import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import '../../astrologers/data/astrologers_api.dart';
import '../../astrologers/data/models/astrologer.dart';

/// Where a follow tap happened — analytics only.
enum FollowSource { profile, card, postSession }

extension on FollowSource {
  String get wire => switch (this) {
    FollowSource.profile => 'profile',
    FollowSource.card => 'card',
    FollowSource.postSession => 'post_session',
  };
}

/// The server's view of one follow edge.
class FollowStatus {
  const FollowStatus({required this.following, required this.followersCount});

  factory FollowStatus.fromJson(Map<String, dynamic> j) => FollowStatus(
    following: j['following'] as bool? ?? false,
    followersCount: (j['followers_count'] as num?)?.toInt() ?? 0,
  );

  final bool following;
  final int followersCount;
}

/// Transport for `/app/astrologers/{id}/follow`, `/app/me/following` and
/// `/app/follows/alerts`. Throws [ApiException].
class FollowsApi {
  FollowsApi(this._dio);

  final Dio _dio;

  Future<FollowStatus> status(String astrologerId) =>
      _call(() => _dio.get(ApiPaths.astrologerFollow(astrologerId)));

  Future<FollowStatus> follow(
    String astrologerId, {
    FollowSource source = FollowSource.profile,
  }) => _call(
    () => _dio.post(
      ApiPaths.astrologerFollow(astrologerId),
      data: {'source': source.wire},
    ),
  );

  Future<FollowStatus> unfollow(String astrologerId) =>
      _call(() => _dio.delete(ApiPaths.astrologerFollow(astrologerId)));

  Future<AstrologerPage> following({String? cursor}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.meFollowing,
        queryParameters: {'cursor': ?cursor},
      );
      final data = res.data ?? const {};
      final next = data['next'] as String?;
      return AstrologerPage(
        items: [
          for (final e in data['results'] as List<dynamic>? ?? const [])
            Astrologer.fromJson(e as Map<String, dynamic>),
        ],
        nextCursor: next == null
            ? null
            : Uri.tryParse(next)?.queryParameters['cursor'],
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<bool> alertsEnabled() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiPaths.followAlerts);
      return res.data?['enabled'] as bool? ?? true;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<bool> setAlertsEnabled(bool enabled) async {
    try {
      final res = await _dio.put<Map<String, dynamic>>(
        ApiPaths.followAlerts,
        data: {'enabled': enabled},
      );
      return res.data?['enabled'] as bool? ?? enabled;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<FollowStatus> _call(Future<Response<dynamic>> Function() send) async {
    try {
      final res = await send();
      return FollowStatus.fromJson(
        (res.data as Map?)?.cast<String, dynamic>() ?? const {},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
