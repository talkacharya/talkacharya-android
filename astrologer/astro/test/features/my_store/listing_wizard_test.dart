import 'dart:async';

import 'package:astro/src/features/my_store/data/my_store_api.dart';
import 'package:astro/src/features/my_store/data/my_store_models.dart';
import 'package:astro/src/features/my_store/presentation/listing/listing_draft.dart';
import 'package:astro/src/features/my_store/presentation/listing/listing_wizard_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Api extends Mock implements MyStoreApi {}

const _options = CatalogOptions(
  types: [
    ListingType(slug: 'pooja', name: 'Pooja', fulfilment: 'service'),
    ListingType(slug: 'gemstone', name: 'Gemstone', fulfilment: 'physical'),
    ListingType(slug: 'gemstone_ring', name: 'Ring', fulfilment: 'physical'),
  ],
  kinds: [
    ListingKind(
      key: 'product',
      fulfilment: 'physical',
      categories: [
        KindCategory(
          slug: 'gemstones',
          name: 'Gemstones',
          types: ['gemstone', 'gemstone_ring'],
          commissionPercent: 30,
        ),
      ],
    ),
    ListingKind(
      key: 'service',
      fulfilment: 'service',
      categories: [
        KindCategory(
          slug: 'poojas',
          name: 'Poojas',
          types: ['pooja'],
          commissionPercent: 30,
        ),
      ],
    ),
  ],
  bannedClaims: ['guaranteed'],
);

MyListing _listing({
  String id = 'L1',
  String type = 'pooja',
  String category = 'poojas',
  String fulfilment = 'service',
  List<ListingPhoto> photos = const [],
  List<ChecklistItem> checklist = const [],
  String status = 'draft',
  String title = '',
}) => MyListing(
  id: id,
  status: status,
  typeSlug: type,
  typeName: type,
  fulfilment: fulfilment,
  categorySlug: category,
  categoryName: category,
  title: title,
  photos: photos,
  checklist: checklist,
);

Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  late _Api api;
  late ListingDraftStore store;
  late StreamController<List<ConnectivityResult>> net;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = ListingDraftStore(await SharedPreferences.getInstance());
    api = _Api();
    net = StreamController.broadcast();
    when(() => api.options()).thenAnswer((_) async => _options);
  });

  tearDown(() => net.close());

  ListingWizardCubit cubit() => ListingWizardCubit(
    api: api,
    store: store,
    connectivity: net.stream,
    localAfter: const Duration(milliseconds: 1),
    serverEvery: const Duration(hours: 1),
  );

  test('a category with one kind makes the server draft at once', () async {
    when(() => api.create(any())).thenAnswer((_) async => _listing());
    final c = cubit();
    await c.load(null);

    c.chooseKind('service');
    await c.chooseCategory('poojas');

    final sent = verify(() => api.create(captureAny())).captured.single as Map;
    expect(sent['category'], 'poojas');
    expect(sent['product_type'], 'pooja');
    expect(sent['packages'], isEmpty, reason: 'nameless packages are not sent');
    expect(c.state.listing?.id, 'L1');
    expect(c.state.save, SaveState.saved);
    await c.close();
  });

  test('a category with more than one kind waits for the choice', () async {
    when(() => api.create(any())).thenAnswer(
      (_) async => _listing(
        type: 'gemstone_ring',
        category: 'gemstones',
        fulfilment: 'physical',
      ),
    );
    final c = cubit();
    await c.load(null);
    c.chooseKind('product');
    await c.chooseCategory('gemstones');
    verifyNever(() => api.create(any()));
    expect(c.next(), isFalse, reason: 'which kind is still to choose');

    await c.chooseType('gemstone_ring');
    verify(() => api.create(any())).called(1);
    await c.close();
  });

  test('what was typed comes back after the app closed', () async {
    final first = cubit();
    await first.load(null);
    first.chooseKind('product');
    first.edit((d) => d.copyWith(title: 'Natural ruby', price: '4500'));
    await _settle();
    await first.close();

    final again = cubit();
    await again.load(null);
    expect(again.state.restored, isTrue);
    expect(again.state.draft.title, 'Natural ruby');
    expect(again.state.draft.price, '4500');
    await again.close();
  });

  test('offline keeps the draft and says so', () async {
    when(() => api.create(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      ),
    );
    final c = cubit();
    await c.load(null);
    c.chooseKind('service');
    await c.chooseCategory('poojas');
    expect(c.state.save, SaveState.offline);
    expect(c.state.listing, isNull);
    await c.close();
  });

  test('a photo goes up on its own with its upload key', () async {
    when(() => api.create(any())).thenAnswer((_) async => _listing());
    when(
      () => api.addPhoto(
        any(),
        any(),
        clientKey: any(named: 'clientKey'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer(
      (_) async => _listing(
        photos: const [ListingPhoto(id: 1, url: 'u', thumb: 't')],
      ),
    );
    final c = cubit();
    await c.load(null);
    c.chooseKind('service');
    await c.chooseCategory('poojas');

    c.addPhotos(['/tmp/a.jpg']);
    await _settle();

    final key =
        verify(
              () => api.addPhoto(
                'L1',
                '/tmp/a.jpg',
                clientKey: captureAny(named: 'clientKey'),
                onProgress: any(named: 'onProgress'),
              ),
            ).captured.single
            as String;
    expect(key, isNotEmpty);
    expect(c.state.uploads, isEmpty);
    expect(c.state.listing?.photos.length, 1);
    await c.close();
  });

  test('a failed photo can be retried', () async {
    when(() => api.create(any())).thenAnswer((_) async => _listing());
    var calls = 0;
    when(
      () => api.addPhoto(
        any(),
        any(),
        clientKey: any(named: 'clientKey'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer((_) async {
      if (calls++ == 0) throw StateError('server said no');
      return _listing(
        photos: const [ListingPhoto(id: 1, url: 'u', thumb: 't')],
      );
    });
    final c = cubit();
    await c.load(null);
    c.chooseKind('service');
    await c.chooseCategory('poojas');
    c.addPhotos(['/tmp/a.jpg']);
    await _settle();
    expect(c.state.uploads.single.status, UploadStatus.failed);

    c.retryUpload(c.state.uploads.single.key);
    await _settle();
    expect(c.state.uploads, isEmpty);
    await c.close();
  });

  test('sending for review takes them to the first thing to fix', () async {
    when(() => api.create(any())).thenAnswer((_) async => _listing());
    when(() => api.update(any(), any())).thenAnswer(
      (_) async => _listing(
        checklist: const [
          ChecklistItem('no_price', 'Set a price for every package.'),
          ChecklistItem('no_image', 'Add at least one photo.'),
        ],
      ),
    );
    final c = cubit();
    await c.load(null);
    c.chooseKind('service');
    await c.chooseCategory('poojas');

    await c.submit();

    expect(c.state.step, WizardStep.photos);
    expect(c.state.problems[WizardStep.price], isNotEmpty);
    verifyNever(() => api.submit(any()));
    await c.close();
  });

  test('a clean listing is sent and the phone copy cleared', () async {
    when(() => api.create(any())).thenAnswer((_) async => _listing());
    when(() => api.update(any(), any())).thenAnswer((_) async => _listing());
    when(
      () => api.submit(any()),
    ).thenAnswer((_) async => _listing(status: 'in_review'));
    final c = cubit();
    await c.load(null);
    c.chooseKind('service');
    await c.chooseCategory('poojas');

    await c.submit();

    expect(c.state.sent, isTrue);
    expect(store.read('L1'), isNull);
    await c.close();
  });

  test('a live listing is not saved behind the astrologer', () async {
    when(() => api.listing('L1')).thenAnswer(
      (_) async => _listing(status: 'published', title: 'Rudrabhishek'),
    );
    when(() => api.update(any(), any())).thenAnswer(
      (_) async => _listing(status: 'published', title: 'Rudrabhishek!'),
    );
    final c = cubit();
    await c.load('L1');
    expect(c.state.step, WizardStep.preview);

    c.edit((d) => d.copyWith(title: 'Rudrabhishek!'));
    await c.saveNow();
    verifyNever(() => api.update(any(), any()));
    expect(c.state.liveContentChanged, isTrue);

    await c.saveChanges();
    verify(() => api.update('L1', any())).called(1);
    await c.close();
  });

  test('banned words are found as typed', () {
    expect(_options.claimsIn('A GUARANTEED result'), ['guaranteed']);
    expect(_options.claimsIn('A calm pooja'), isEmpty);
  });
}
