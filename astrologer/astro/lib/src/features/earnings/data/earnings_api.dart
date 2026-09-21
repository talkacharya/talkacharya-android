import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'earnings_models.dart';

class EarningsApi {
  EarningsApi(this._dio);
  final Dio _dio;

  /// Raw `GET /astro/earnings` (`{by_currency: [...]}`) — see
  /// `PayoutSummary.fromJson`.
  Future<Map<String, dynamic>> summary() async {
    final res = await _ok(
      _dio.get<Map<String, dynamic>>(ApiPaths.astroEarnings),
    );
    return res.data ?? const {};
  }

  Future<CursorPage<EarningEntry>> entries({
    String? cursor,
    String? kind,
  }) async {
    final res = await _ok(
      _dio.get<dynamic>(
        ApiPaths.astroEarningEntries,
        queryParameters: {'cursor': ?cursor, 'kind': ?kind},
      ),
    );
    return CursorPage.parse(res.data, EarningEntry.fromJson);
  }

  Future<CursorPage<Payout>> payouts({String? cursor}) async {
    final res = await _ok(
      _dio.get<dynamic>(
        ApiPaths.astroPayouts,
        queryParameters: {'cursor': ?cursor},
      ),
    );
    return CursorPage.parse(res.data, Payout.fromJson);
  }

  Future<Payout> payout(String id) async {
    final res = await _ok(
      _dio.get<Map<String, dynamic>>(ApiPaths.astroPayout(id)),
    );
    return Payout.fromJson(res.data ?? const {});
  }

  Future<List<TaxDocument>> taxDocuments({String? kind}) async {
    final res = await _ok(
      _dio.get<dynamic>(
        ApiPaths.astroTaxDocuments,
        queryParameters: {'kind': ?kind},
      ),
    );
    return (res.data as List? ?? const [])
        .map((e) => TaxDocument.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  /// PDF bytes (authenticated, so it can't be opened as a plain URL).
  Future<List<int>> taxDocumentPdf(String id) async {
    final res = await _ok(
      _dio.get<List<int>>(
        ApiPaths.astroTaxDocumentPdf(id),
        options: Options(responseType: ResponseType.bytes),
      ),
    );
    return res.data ?? const [];
  }

  /// Awaits [call] and throws on a 4xx (see [EnsureOk]).
  Future<Response<T>> _ok<T>(Future<Response<T>> call) async =>
      (await call).ensureOk();
}
