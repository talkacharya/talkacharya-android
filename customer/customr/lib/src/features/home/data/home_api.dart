import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'models/home_feed.dart';
import 'models/horoscope.dart';
import 'models/home_consultation.dart';
import 'models/live_stream_card.dart';
import 'models/panchang.dart';
import 'models/recharge_pack.dart';
import 'models/referral_overview.dart';
import 'models/wallet_balance.dart';
import 'models/zodiac.dart';

/// Transport for the endpoints the home feed composes itself from. Every method
/// throws [ApiException]; callers (the [HomeCubit]) turn that into a per-section
/// error so one dead endpoint never blanks the screen.
class HomeApi {
  HomeApi(this._dio);

  final Dio _dio;

  /// `GET /app/home` — the curated feed (featured / online / live / resume /
  /// categories / promos) in one round-trip.
  Future<HomeFeed> feed() async {
    return HomeFeed.fromJson(await _getMap(ApiPaths.home));
  }

  /// `GET /app/wallet/packs` — recharge suggestions + live offers.
  Future<List<RechargePack>> walletPacks({String? currency}) async {
    final json = await _getMap(
      ApiPaths.walletPacks,
      query: {'currency': ?currency},
    );
    final packs = (json['packs'] as List<dynamic>? ?? const []);
    return packs.indexed.map((e) {
      final i = e.$1;
      final badge = i == packs.length - 1
          ? 'Best value'
          : (i == packs.length ~/ 2 ? 'Popular' : null);
      return RechargePack.fromJson(e.$2 as Map<String, dynamic>, badge: badge);
    }).toList();
  }

  Future<Horoscope> horoscope(ZodiacSign sign, {String? language}) async {
    final json = await _getMap(
      ApiPaths.horoscope,
      query: {'sign': sign.slug, 'lang': ?language},
    );
    return Horoscope.fromArtifact(sign, json);
  }

  Future<Panchang> panchang(String birthProfileId, {String? language}) async {
    final json = await _getMap(
      ApiPaths.birthProfilePanchang(birthProfileId),
      query: {'lang': ?language},
    );
    return Panchang.fromArtifact(json);
  }

  Future<List<WalletBalance>> wallet() async {
    final list = await _getList(ApiPaths.wallet);
    return list
        .map((e) => WalletBalance.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<HomeConsultation>> consultations({String? status}) async {
    final list = await _getList(
      ApiPaths.consultations,
      query: {'status': ?status},
    );
    return list
        .map((e) => HomeConsultation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ReferralOverview> referrals() async {
    final json = await _getMap(ApiPaths.referrals);
    return ReferralOverview.fromJson(json);
  }

  Future<List<LiveStreamCard>> liveStreams() async {
    final list = await _getList(
      ApiPaths.livestreams,
      query: {'status': 'live'},
    );
    return list
        .map((e) => LiveStreamCard.fromJson(e as Map<String, dynamic>))
        .where((s) => s.id.isNotEmpty)
        .toList();
  }

  // --- helpers -----------------------------------------------------------

  Future<Map<String, dynamic>> _getMap(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      _raiseFor(res);
      return res.data ?? const {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<dynamic>> _getList(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final res = await _dio.get<dynamic>(path, queryParameters: query);
      _raiseFor(res);
      final data = res.data;
      if (data is List) return data;
      if (data is Map && data['results'] is List) {
        return data['results'] as List<dynamic>;
      }
      return const [];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  void _raiseFor(Response<dynamic> res) {
    if ((res.statusCode ?? 0) >= 400) {
      throw ApiException.fromDio(
        DioException(requestOptions: res.requestOptions, response: res),
      );
    }
  }
}
