part of 'birth_profiles_cubit.dart';

enum BpStatus { initial, loading, ready, error }

const _unset = Object();

class BirthProfilesState extends Equatable {
  const BirthProfilesState({
    this.status = BpStatus.initial,
    this.profiles = const [],
    this.activeProfileId,
    this.error,
  });

  final BpStatus status;
  final List<BirthProfile> profiles;
  final String? activeProfileId;
  final String? error;

  BirthProfile? get activeProfile => profileById(activeProfileId);

  BirthProfile? profileById(String? id) {
    if (id == null) return null;
    for (final p in profiles) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// The profile to fall back to when nothing is explicitly active — the user's
  /// own chart. Preference: primary (is_primary) → the `self` relation →
  /// earliest created → first in the list.
  BirthProfile? get primaryProfile {
    if (profiles.isEmpty) return null;
    for (final p in profiles) {
      if (p.isPrimary) return p;
    }
    for (final p in profiles) {
      if (p.relation == 'self') return p;
    }
    final sorted = [...profiles]
      ..sort((a, b) {
        final ca = a.createdAt, cb = b.createdAt;
        if (ca == null || cb == null) return 0;
        return ca.compareTo(cb);
      });
    return sorted.first;
  }

  /// Explicit active profile, or the primary fallback. Use this for anything
  /// that just needs "the user's chart" (panchang, horoscope, free tools).
  BirthProfile? get resolvedProfile => activeProfile ?? primaryProfile;

  bool get isEmpty => status == BpStatus.ready && profiles.isEmpty;

  BirthProfilesState copyWith({
    BpStatus? status,
    List<BirthProfile>? profiles,
    Object? activeProfileId = _unset,
    String? error,
    bool clearError = false,
  }) {
    return BirthProfilesState(
      status: status ?? this.status,
      profiles: profiles ?? this.profiles,
      activeProfileId: identical(activeProfileId, _unset)
          ? this.activeProfileId
          : activeProfileId as String?,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, profiles, activeProfileId, error];
}
