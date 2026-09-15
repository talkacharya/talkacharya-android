import '../../astrologers/data/astrologers_api.dart';
import 'follows_api.dart';

class FollowsRepository {
  FollowsRepository(this._api);

  final FollowsApi _api;

  Future<FollowStatus> status(String astrologerId) => _api.status(astrologerId);

  Future<FollowStatus> setFollowing(
    String astrologerId, {
    required bool follow,
    FollowSource source = FollowSource.profile,
  }) => follow
      ? _api.follow(astrologerId, source: source)
      : _api.unfollow(astrologerId);

  Future<AstrologerPage> following({String? cursor}) =>
      _api.following(cursor: cursor);

  Future<bool> alertsEnabled() => _api.alertsEnabled();

  Future<bool> setAlertsEnabled(bool enabled) => _api.setAlertsEnabled(enabled);
}
