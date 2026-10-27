import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/friendly_error.dart';
import '../../data/my_store_api.dart';
import '../../data/my_store_models.dart';
import 'listing_draft.dart';

/// The steps of the listing form. [details] is skipped for a kind with no
/// detail fields.
enum WizardStep { kind, photos, describe, details, price, preview }

/// Where the form's copy on the server stands, for the line under the title.
enum SaveState { idle, saving, saved, offline, failed }

enum UploadStatus { queued, uploading, failed }

/// A photo on its way up: picked, sending, or waiting for a retry.
class Upload extends Equatable {
  const Upload({
    required this.key,
    required this.path,
    this.status = UploadStatus.queued,
    this.progress = 0,
    this.attempts = 0,
  });

  final String key;
  final String path;
  final UploadStatus status;
  final double progress;
  final int attempts;

  Upload copyWith({UploadStatus? status, double? progress, int? attempts}) =>
      Upload(
        key: key,
        path: path,
        status: status ?? this.status,
        progress: progress ?? this.progress,
        attempts: attempts ?? this.attempts,
      );

  @override
  List<Object?> get props => [key, path, status, progress, attempts];
}

class ListingWizardState extends Equatable {
  const ListingWizardState({
    this.loading = true,
    this.error,
    this.options,
    this.listing,
    this.draft = const ListingDraft(),
    this.step = WizardStep.kind,
    this.uploads = const [],
    this.save = SaveState.idle,
    this.savedAt,
    this.restored = false,
    this.problems = const {},
    this.submitting = false,
    this.sent = false,
    this.notice,
    this.noticeId = 0,
  });

  final bool loading;
  final String? error;
  final CatalogOptions? options;

  /// The server's copy; null until the first step made a draft there.
  final MyListing? listing;
  final ListingDraft draft;
  final WizardStep step;
  final List<Upload> uploads;
  final SaveState save;
  final DateTime? savedAt;

  /// The form was brought back from the phone (the app had closed mid-edit).
  final bool restored;

  /// What stands between the listing and review, by step (from the server).
  final Map<WizardStep, List<String>> problems;
  final bool submitting;

  /// Sent for review: the page closes.
  final bool sent;

  /// A one-off message for a toast; [noticeId] changes with each.
  final String? notice;
  final int noticeId;

  bool get isNew => listing == null;
  bool get isLive => listing?.isLive ?? false;

  ListingType? get type =>
      draft.type.isEmpty ? null : options?.typeOf(draft.type);

  KindCategory? get category =>
      draft.category.isEmpty ? null : options?.kindCategory(draft.category);

  /// The steps this listing walks through, in order.
  List<WizardStep> get steps => [
    WizardStep.kind,
    WizardStep.photos,
    WizardStep.describe,
    if ((type?.attributes ?? const []).isNotEmpty) WizardStep.details,
    WizardStep.price,
    WizardStep.preview,
  ];

  int get photoCount => (listing?.photos.length ?? 0) + uploads.length;

  /// A live listing whose wording changed: saving sends it back to review.
  bool get liveContentChanged =>
      isLive &&
      draft.contentKey != ListingDraft.fromListing(listing!).contentKey;

  ListingWizardState copyWith({
    bool? loading,
    String? error,
    CatalogOptions? options,
    MyListing? listing,
    ListingDraft? draft,
    WizardStep? step,
    List<Upload>? uploads,
    SaveState? save,
    DateTime? savedAt,
    bool? restored,
    Map<WizardStep, List<String>>? problems,
    bool? submitting,
    bool? sent,
    String? notice,
  }) => ListingWizardState(
    loading: loading ?? this.loading,
    error: error,
    options: options ?? this.options,
    listing: listing ?? this.listing,
    draft: draft ?? this.draft,
    step: step ?? this.step,
    uploads: uploads ?? this.uploads,
    save: save ?? this.save,
    savedAt: savedAt ?? this.savedAt,
    restored: restored ?? this.restored,
    problems: problems ?? this.problems,
    submitting: submitting ?? this.submitting,
    sent: sent ?? this.sent,
    notice: notice ?? this.notice,
    noticeId: notice == null ? noticeId : noticeId + 1,
  );

  @override
  List<Object?> get props => [
    loading,
    error,
    options,
    listing,
    draft,
    step,
    uploads,
    save,
    savedAt,
    restored,
    problems,
    submitting,
    sent,
    noticeId,
  ];
}

/// The listing form: a step at a time, kept safe as it is typed — on the phone
/// a moment after every change, on the server every [serverEvery] (a live
/// listing only when the astrologer saves, since its wording going back to
/// review is theirs to decide). Photos go up one by one the moment they are
/// picked, apart from the text, and are retried until they arrive.
class ListingWizardCubit extends Cubit<ListingWizardState> {
  ListingWizardCubit({
    required MyStoreApi api,
    required ListingDraftStore store,
    this.serverEvery = const Duration(seconds: 30),
    this.localAfter = const Duration(milliseconds: 800),
    Stream<List<ConnectivityResult>>? connectivity,
  }) : _api = api,
       _store = store,
       _connectivity = connectivity,
       super(const ListingWizardState());

  final MyStoreApi _api;
  final ListingDraftStore _store;
  final Duration serverEvery;
  final Duration localAfter;
  final Stream<List<ConnectivityResult>>? _connectivity;

  Timer? _localTimer;
  Timer? _serverTimer;
  StreamSubscription<List<ConnectivityResult>>? _netSub;

  /// Changes not yet on the server.
  bool _dirty = false;
  bool _saving = false;
  bool _uploading = false;

  String? get _listingId => state.listing?.id;

  // --- loading -------------------------------------------------------------------

  Future<void> load(String? listingId) async {
    emit(state.copyWith(loading: true));
    try {
      final options = await _api.options();
      final listing = listingId == null ? null : await _api.listing(listingId);
      var draft = listing == null
          ? const ListingDraft()
          : ListingDraft.fromListing(listing);
      var uploads = const <Upload>[];
      var restored = false;
      final saved = _store.read(listingId);
      if (saved != null) {
        final differs =
            jsonKey(saved.draft) != jsonKey(draft) || saved.photos.isNotEmpty;
        if (differs) {
          draft = saved.draft;
          uploads = [
            for (final p in saved.photos) Upload(key: p.key, path: p.path),
          ];
          restored = true;
          _dirty = true;
        }
      }
      emit(
        state.copyWith(
          loading: false,
          options: options,
          listing: listing,
          draft: draft,
          uploads: uploads,
          restored: restored,
          // an existing listing opens on its summary, each part a tap away
          step: listing == null ? WizardStep.kind : WizardStep.preview,
          save: listing == null ? SaveState.idle : SaveState.saved,
        ),
      );
      _serverTimer = Timer.periodic(serverEvery, (_) => unawaited(saveNow()));
      _netSub = (_connectivity ?? Connectivity().onConnectivityChanged).listen((
        r,
      ) {
        if (r.any((c) => c != ConnectivityResult.none)) {
          _retryFailed();
          if (_dirty) unawaited(saveNow());
        }
      });
      if (restored) unawaited(saveNow());
      unawaited(_pumpUploads());
    } catch (e) {
      emit(state.copyWith(loading: false, error: friendlyError(e)));
    }
  }

  static String jsonKey(ListingDraft d) => d.toJson().toString();

  // --- editing ---------------------------------------------------------------------

  /// Any change to the form: kept on the phone shortly after, and on the server
  /// with the next save.
  void edit(ListingDraft Function(ListingDraft d) change) {
    final next = change(state.draft);
    _dirty = true;
    emit(state.copyWith(draft: next, problems: const {}));
    _scheduleLocal();
  }

  void chooseKind(String kind) {
    if (kind == state.draft.kind) return;
    edit(
      (d) => d.copyWith(
        kind: kind,
        category: '',
        type: '',
        attributes: const {},
        packages: kind == 'service' && d.packages.isEmpty
            ? [PackageDraft(key: newKey(), name: '', participants: 1)]
            : d.packages,
      ),
    );
  }

  /// The category, and with it the kind of listing when it takes only one.
  Future<void> chooseCategory(String slug) async {
    final category = state.options?.kindCategory(slug);
    if (category == null) return;
    final type = category.types.length == 1 ? category.types.first : '';
    edit(
      (d) => d.copyWith(
        category: slug,
        type: state.isNew ? type : d.type,
        attributes: state.isNew && type != d.type ? const {} : d.attributes,
      ),
    );
    if (state.isNew && type.isNotEmpty) await saveNow();
  }

  Future<void> chooseType(String slug) async {
    if (!state.isNew) return;
    edit((d) => d.copyWith(type: slug, attributes: const {}));
    await saveNow();
  }

  void setAttribute(String key, Object? value) =>
      edit((d) => d.copyWith(attributes: {...d.attributes, key: value}));

  void addPackage({String name = '', int participants = 1}) => edit(
    (d) => d.copyWith(
      packages: [
        ...d.packages,
        PackageDraft(key: newKey(), name: name, participants: participants),
      ],
    ),
  );

  void updatePackage(
    String key,
    PackageDraft Function(PackageDraft p) change,
  ) => edit(
    (d) => d.copyWith(
      packages: [for (final p in d.packages) p.key == key ? change(p) : p],
    ),
  );

  void removePackage(String key) => edit(
    (d) => d.copyWith(
      packages: [
        for (final p in d.packages)
          if (p.key != key) p,
      ],
    ),
  );

  // --- steps -----------------------------------------------------------------------

  void goTo(WizardStep step) => emit(state.copyWith(step: step));

  /// The next step, after a light check of this one (the real check is the
  /// server's, when it is sent for review). Saving goes along with it.
  bool next() {
    final missing = _missingHere();
    if (missing != null) {
      emit(state.copyWith(notice: missing));
      return false;
    }
    final steps = state.steps;
    final i = steps.indexOf(state.step);
    if (i < steps.length - 1) emit(state.copyWith(step: steps[i + 1]));
    unawaited(saveNow());
    return true;
  }

  void back() {
    final steps = state.steps;
    final i = steps.indexOf(state.step);
    if (i > 0) emit(state.copyWith(step: steps[i - 1]));
  }

  /// Codes for the page to put into words (see the step widgets).
  String? _missingHere() {
    final d = state.draft;
    return switch (state.step) {
      WizardStep.kind when d.kind.isEmpty => 'need_kind',
      WizardStep.kind when d.category.isEmpty => 'need_category',
      WizardStep.kind when d.type.isEmpty => 'need_type',
      _ => null,
    };
  }

  // --- saving ----------------------------------------------------------------------

  void _scheduleLocal() {
    _localTimer?.cancel();
    _localTimer = Timer(localAfter, () => unawaited(_writeLocal()));
  }

  Future<void> _writeLocal() => _store.write(_listingId, state.draft, [
    for (final u in state.uploads) PendingPhoto(key: u.key, path: u.path),
  ]);

  /// Puts the form on the server: creates the draft once a category (and kind)
  /// is chosen, then updates it. A live listing waits for [saveChanges].
  Future<void> saveNow({bool force = false}) async {
    if (isClosed || _saving || !_dirty) return;
    if (state.isLive && !force) return;
    final d = state.draft;
    if (state.isNew && (d.category.isEmpty || d.type.isEmpty)) return;
    _saving = true;
    _dirty = false;
    emit(state.copyWith(save: SaveState.saving));
    try {
      final creating = state.isNew;
      final payload = d.toPayload(creating: creating);
      final listing = creating
          ? await _api.create(payload)
          : await _api.update(_listingId!, payload);
      if (creating) await _store.move(listing.id);
      if (isClosed) return;
      emit(
        state.copyWith(
          listing: listing,
          draft: _withServerIds(state.draft, listing),
          save: SaveState.saved,
          savedAt: DateTime.now(),
          notice: listing.sentBackToReview ? 'back_to_review' : null,
        ),
      );
      await _writeLocal();
      unawaited(_pumpUploads());
    } catch (e) {
      _dirty = true;
      if (!isClosed) {
        emit(
          state.copyWith(
            save: _offline(e) ? SaveState.offline : SaveState.failed,
            notice: _offline(e) ? null : friendlyError(e),
          ),
        );
      }
    } finally {
      _saving = false;
    }
  }

  /// A live listing: saved when the astrologer says so (its wording changing
  /// takes it off sale until the team looks again — the page asks first).
  Future<void> saveChanges() async {
    _dirty = true;
    await saveNow(force: true);
  }

  /// Packages saved for the first time get their server ids, so the next save
  /// updates them instead of adding them again.
  ListingDraft _withServerIds(ListingDraft d, MyListing l) {
    if (!d.isService || l.packages.isEmpty) return d;
    final named = [
      for (final p in d.packages)
        if (p.name.trim().isNotEmpty) p,
    ];
    if (named.length != l.packages.length) return d;
    var i = 0;
    return d.copyWith(
      packages: [
        for (final p in d.packages)
          p.name.trim().isEmpty ? p : p.copyWith(id: l.packages[i++].id),
      ],
    );
  }

  static bool _offline(Object e) =>
      e is DioException &&
      (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.response == null);

  // --- photos ----------------------------------------------------------------------

  /// Photos picked (already shrunk by the picker): each goes up on its own.
  void addPhotos(List<String> paths) {
    final room = (state.options?.maxImages ?? 8) - state.photoCount;
    if (room <= 0) return;
    emit(
      state.copyWith(
        uploads: [
          ...state.uploads,
          for (final p in paths.take(room)) Upload(key: newKey(), path: p),
        ],
      ),
    );
    unawaited(_writeLocal());
    unawaited(_pumpUploads());
  }

  void retryUpload(String key) {
    emit(
      state.copyWith(
        uploads: [
          for (final u in state.uploads)
            u.key == key ? u.copyWith(status: UploadStatus.queued) : u,
        ],
      ),
    );
    unawaited(_pumpUploads());
  }

  void cancelUpload(String key) {
    emit(
      state.copyWith(
        uploads: [
          for (final u in state.uploads)
            if (u.key != key) u,
        ],
      ),
    );
    unawaited(_writeLocal());
  }

  void _retryFailed() {
    if (!state.uploads.any((u) => u.status == UploadStatus.failed)) return;
    emit(
      state.copyWith(
        uploads: [
          for (final u in state.uploads)
            u.status == UploadStatus.failed
                ? u.copyWith(status: UploadStatus.queued)
                : u,
        ],
      ),
    );
    unawaited(_pumpUploads());
  }

  /// Sends queued photos one at a time once the listing exists on the server.
  Future<void> _pumpUploads() async {
    if (_uploading || isClosed) return;
    final id = _listingId;
    if (id == null) return;
    _uploading = true;
    try {
      while (!isClosed) {
        final next = state.uploads
            .where((u) => u.status == UploadStatus.queued)
            .firstOrNull;
        if (next == null) break;
        _setUpload(next.copyWith(status: UploadStatus.uploading, progress: 0));
        try {
          final listing = await _api.addPhoto(
            id,
            next.path,
            clientKey: next.key,
            onProgress: (p) => _setUpload(
              next.copyWith(status: UploadStatus.uploading, progress: p),
            ),
          );
          if (isClosed) return;
          emit(
            state.copyWith(
              listing: listing,
              uploads: [
                for (final u in state.uploads)
                  if (u.key != next.key) u,
              ],
              notice: listing.sentBackToReview ? 'back_to_review' : null,
            ),
          );
          await _writeLocal();
        } catch (e) {
          if (isClosed) return;
          final attempts = next.attempts + 1;
          _setUpload(
            next.copyWith(status: UploadStatus.failed, attempts: attempts),
          );
          // a network blip: try again by itself, a few times, a little later
          if (_offline(e) && attempts < 4) {
            Timer(Duration(seconds: 4 * attempts), () {
              if (!isClosed) retryUpload(next.key);
            });
          } else if (!_offline(e)) {
            emit(state.copyWith(notice: friendlyError(e)));
          }
        }
      }
    } finally {
      _uploading = false;
    }
  }

  void _setUpload(Upload u) {
    if (isClosed) return;
    emit(
      state.copyWith(
        uploads: [for (final x in state.uploads) x.key == u.key ? u : x],
      ),
    );
  }

  Future<void> removePhoto(ListingPhoto photo) async {
    final id = _listingId;
    if (id == null) return;
    try {
      final listing = await _api.removePhoto(id, photo.id);
      if (!isClosed) {
        emit(
          state.copyWith(
            listing: listing,
            notice: listing.sentBackToReview ? 'back_to_review' : null,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) emit(state.copyWith(notice: friendlyError(e)));
    }
  }

  /// [ordered] is the photos in their new order; the first is the cover.
  Future<void> reorderPhotos(List<ListingPhoto> ordered) async {
    final id = _listingId;
    final listing = state.listing;
    if (id == null || listing == null) return;
    try {
      final updated = await _api.reorderPhotos(id, [
        for (final p in ordered) p.id,
      ]);
      if (!isClosed) emit(state.copyWith(listing: updated));
    } catch (e) {
      if (!isClosed) emit(state.copyWith(notice: friendlyError(e)));
    }
  }

  // --- review ----------------------------------------------------------------------

  static const _stepOfProblem = {
    'no_image': WizardStep.photos,
    'no_title': WizardStep.describe,
    'no_description': WizardStep.describe,
    'claims': WizardStep.describe,
    'attributes': WizardStep.details,
    'no_price': WizardStep.price,
    'no_weight': WizardStep.price,
  };

  /// Saves, and sends it for review — or shows what is missing, by step, and
  /// takes the astrologer to the first of it.
  Future<void> submit() async {
    if (state.submitting) return;
    emit(state.copyWith(submitting: true));
    _dirty = true;
    await saveNow(force: true);
    final listing = state.listing;
    if (listing == null || state.save != SaveState.saved) {
      emit(state.copyWith(submitting: false));
      return;
    }
    if (state.uploads.isNotEmpty) {
      emit(state.copyWith(submitting: false, notice: 'photos_uploading'));
      return;
    }
    if (listing.checklist.isNotEmpty) {
      final problems = <WizardStep, List<String>>{};
      for (final c in listing.checklist) {
        final step = _stepOfProblem[c.code] ?? WizardStep.describe;
        (problems[step] ??= []).add(c.message);
      }
      final first = state.steps.firstWhere(
        problems.containsKey,
        orElse: () => state.step,
      );
      emit(
        state.copyWith(
          submitting: false,
          problems: problems,
          step: first,
          notice: 'fix_problems',
        ),
      );
      return;
    }
    try {
      final sent = await _api.submit(listing.id);
      await _store.clear(listing.id);
      if (!isClosed) {
        emit(state.copyWith(listing: sent, submitting: false, sent: true));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(submitting: false, notice: friendlyError(e)));
      }
    }
  }

  @override
  Future<void> close() async {
    _localTimer?.cancel();
    _serverTimer?.cancel();
    await _netSub?.cancel();
    // what was typed in the last moment is kept
    if (!state.loading && state.error == null && !state.sent) {
      await _writeLocal();
    }
    return super.close();
  }
}
