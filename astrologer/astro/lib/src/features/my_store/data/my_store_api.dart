import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import 'my_store_models.dart';

Map<String, dynamic> _map(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : const {};

List<Map<String, dynamic>> _rows(Object? v) {
  final list = v is Map ? v['results'] : v;
  return [
    for (final e in list as List? ?? const [])
      if (e is Map) e.cast<String, dynamic>(),
  ];
}

/// The astrologer's own store: `/astro/store/{seller,catalog}` for setting it
/// up and listing, `/seller/*` for the orders and bookings that come in.
class MyStoreApi {
  MyStoreApi(this._dio);

  final Dio _dio;

  // --- setup -------------------------------------------------------------------------

  Future<StoreSetup> setup() async => StoreSetup.fromJson(
    _map((await _dio.get<dynamic>(ApiPaths.astroStoreSeller)).ensureOk().data),
  );

  Future<StoreSetup> saveSetup({
    required String displayName,
    required String description,
    required Map<String, String> address,
  }) async => StoreSetup.fromJson(
    _map(
      (await _dio.put<dynamic>(
        ApiPaths.astroStoreSeller,
        data: {
          'display_name': displayName.trim(),
          'description': description.trim(),
          'address': address,
        },
      )).ensureOk().data,
    ),
  );

  Future<CatalogOptions> options() async => CatalogOptions.fromJson(
    _map(
      (await _dio.get<dynamic>(ApiPaths.astroCatalogOptions)).ensureOk().data,
    ),
  );

  // --- listings ----------------------------------------------------------------------

  Future<List<MyListing>> listings() async => [
    for (final r in _rows(
      (await _dio.get<dynamic>(ApiPaths.astroListings)).ensureOk().data,
    ))
      MyListing.fromJson(r),
  ];

  Future<MyListing> listing(String id) async => MyListing.fromJson(
    _map((await _dio.get<dynamic>(ApiPaths.astroListing(id))).ensureOk().data),
  );

  Future<MyListing> create(Map<String, dynamic> data) async =>
      MyListing.fromJson(
        _map(
          (await _dio.post<dynamic>(
            ApiPaths.astroListings,
            data: data,
          )).ensureOk().data,
        ),
      );

  Future<MyListing> update(String id, Map<String, dynamic> data) async =>
      MyListing.fromJson(
        _map(
          (await _dio.patch<dynamic>(
            ApiPaths.astroListing(id),
            data: data,
          )).ensureOk().data,
        ),
      );

  Future<void> remove(String id) async =>
      (await _dio.delete<dynamic>(ApiPaths.astroListing(id))).ensureOk();

  Future<MyListing> addPhoto(String id, String filePath) async {
    final form = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
    });
    return MyListing.fromJson(
      _map(
        (await _dio.post<dynamic>(
          ApiPaths.astroListingMedia(id),
          data: form,
        )).ensureOk().data,
      ),
    );
  }

  Future<MyListing> removePhoto(String id, int photoId) async =>
      MyListing.fromJson(
        _map(
          (await _dio.delete<dynamic>(
            ApiPaths.astroListingMediaItem(id, photoId),
          )).ensureOk().data,
        ),
      );

  Future<MyListing> reorderPhotos(String id, List<int> ids) async =>
      MyListing.fromJson(
        _map(
          (await _dio.put<dynamic>(
            ApiPaths.astroListingMediaOrder(id),
            data: {'ids': ids},
          )).ensureOk().data,
        ),
      );

  Future<MyListing> submit(String id) async => MyListing.fromJson(
    _map(
      (await _dio.post<dynamic>(
        ApiPaths.astroListingSubmit(id),
      )).ensureOk().data,
    ),
  );

  Future<MyListing> withdraw(String id) async => MyListing.fromJson(
    _map(
      (await _dio.post<dynamic>(
        ApiPaths.astroListingWithdraw(id),
      )).ensureOk().data,
    ),
  );

  // --- orders and bookings ------------------------------------------------------------

  Future<List<SellerOrder>> orders() async => [
    for (final r in _rows(
      (await _dio.get<dynamic>(ApiPaths.sellerOrders)).ensureOk().data,
    ))
      SellerOrder.fromJson(r),
  ];

  Future<SellerOrder> order(String id) async => SellerOrder.fromJson(
    _map((await _dio.get<dynamic>(ApiPaths.sellerOrder(id))).ensureOk().data),
  );

  /// `processing` | `ship` (courier, AWB, tracking link) | `cancel` (reason).
  Future<SellerOrder> orderAction(
    String id,
    String action, {
    Map<String, dynamic> data = const {},
  }) async => SellerOrder.fromJson(
    _map(
      (await _dio.post<dynamic>(
        ApiPaths.sellerOrderAction(id, action),
        data: data,
      )).ensureOk().data,
    ),
  );

  Future<List<SellerBooking>> bookings() async => [
    for (final r in _rows(
      (await _dio.get<dynamic>(ApiPaths.sellerBookings)).ensureOk().data,
    ))
      SellerBooking.fromJson(r),
  ];

  Future<SellerBooking> markPerformed(String id, {String note = ''}) async =>
      SellerBooking.fromJson(
        _map(
          (await _dio.post<dynamic>(
            ApiPaths.sellerBookingAction(id, 'performed'),
            data: {'note': note},
          )).ensureOk().data,
        ),
      );

  Future<SellerBooking> addProof(
    String id,
    String filePath, {
    required String kind,
  }) async {
    final form = FormData.fromMap({
      'kind': kind,
      'file': await MultipartFile.fromFile(filePath),
    });
    return SellerBooking.fromJson(
      _map(
        (await _dio.post<dynamic>(
          ApiPaths.sellerBookingAction(id, 'proof'),
          data: form,
        )).ensureOk().data,
      ),
    );
  }
}
