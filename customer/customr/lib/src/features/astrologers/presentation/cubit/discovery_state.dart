part of 'discovery_cubit.dart';

enum DiscoveryStatus {
  /// Nothing fetched yet — show the full-screen skeleton.
  initial,

  /// First fetch for a brand-new query with no results to fall back on.
  loading,

  /// Re-fetching after a filter/search/sort change; the previous results stay
  /// on screen behind a thin progress bar.
  refiltering,
  ready,
  loadingMore,
  error,
}

class DiscoveryState extends Equatable {
  const DiscoveryState({
    this.status = DiscoveryStatus.initial,
    this.query = const AstrologerQuery(),
    this.items = const [],
    this.nextCursor,
    this.hasMore = false,
    this.error,
    this.loadMoreError = false,
  });

  final DiscoveryStatus status;
  final AstrologerQuery query;
  final List<Astrologer> items;
  final String? nextCursor;
  final bool hasMore;
  final String? error;

  /// The last `loadMore()` threw — the footer offers a retry.
  final bool loadMoreError;

  bool get isEmpty => status == DiscoveryStatus.ready && items.isEmpty;
  bool get showFullSkeleton =>
      (status == DiscoveryStatus.initial ||
          status == DiscoveryStatus.loading) &&
      items.isEmpty;
  bool get isBusy =>
      status == DiscoveryStatus.loading ||
      status == DiscoveryStatus.refiltering ||
      status == DiscoveryStatus.initial;

  DiscoveryState copyWith({
    DiscoveryStatus? status,
    AstrologerQuery? query,
    List<Astrologer>? items,
    String? nextCursor,
    bool clearCursor = false,
    bool? hasMore,
    String? error,
    bool clearError = false,
    bool? loadMoreError,
  }) {
    return DiscoveryState(
      status: status ?? this.status,
      query: query ?? this.query,
      items: items ?? this.items,
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      loadMoreError: loadMoreError ?? this.loadMoreError,
    );
  }

  @override
  List<Object?> get props => [
    status,
    query,
    items,
    nextCursor,
    hasMore,
    error,
    loadMoreError,
  ];
}
