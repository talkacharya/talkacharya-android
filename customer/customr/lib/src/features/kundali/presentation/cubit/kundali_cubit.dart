import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../data/kundali_repository.dart';
import '../../data/models/daily_mood.dart';
import 'package:astro_kundali/astro_kundali.dart';

part 'kundali_state.dart';

/// One cubit for the whole kundali section (provided by the `/kundali/:id`
/// shell route). Each screen triggers its own slice; slices load, succeed and
/// fail independently like the home feed.
class KundaliCubit extends Cubit<KundaliState> {
  KundaliCubit({required KundaliRepository repo, required this.profileId})
    : _repo = repo,
      super(const KundaliState());

  final KundaliRepository _repo;
  final String profileId;

  Future<void> loadOverview({bool force = false}) => _slice(
    () => state.overview,
    (v) => emit(state.copyWith(overview: v)),
    () => _repo.overview(profileId),
    force: force,
  );

  Future<void> loadNavamsa({bool force = false}) => _slice(
    () => state.navamsa,
    (v) => emit(state.copyWith(navamsa: v)),
    () => _repo.chart(profileId, type: 'd9'),
    force: force,
  );

  Future<void> loadDasha({bool force = false}) => _slice(
    () => state.dasha,
    (v) => emit(state.copyWith(dasha: v)),
    () => _repo.dasha(profileId),
    force: force,
  );

  Future<void> loadAllDashas({bool force = false}) => _slice(
    () => state.allDashas,
    (v) => emit(state.copyWith(allDashas: v)),
    () => _repo.allDashas(profileId),
    force: force,
  );

  Future<void> loadDashaNarrative({bool force = false}) => _slice(
    () => state.dashaNarrative,
    (v) => emit(state.copyWith(dashaNarrative: v)),
    () => _repo.dashaNarrative(profileId),
    force: force,
  );

  Future<void> loadNumerology({bool force = false}) => _slice(
    () => state.numerology,
    (v) => emit(state.copyWith(numerology: v)),
    () => _repo.numerology(profileId),
    force: force,
  );

  Future<void> loadSadeSati({bool force = false}) => _slice(
    () => state.sadeSati,
    (v) => emit(state.copyWith(sadeSati: v)),
    () => _repo.sadeSati(profileId),
    force: force,
  );

  Future<void> loadAvTransit({bool force = false}) => _slice(
    () => state.avTransit,
    (v) => emit(state.copyWith(avTransit: v)),
    () => _repo.avTransit(profileId),
    force: force,
  );

  Future<void> loadMuhurta({bool force = false}) => _slice(
    () => state.muhurta,
    (v) => emit(state.copyWith(muhurta: v)),
    () => _repo.muhurta(profileId),
    force: force,
  );

  Future<void> loadJyotishUpaya({bool force = false}) => _slice(
    () => state.jyotishUpaya,
    (v) => emit(state.copyWith(jyotishUpaya: v)),
    () => _repo.jyotishUpaya(profileId),
    force: force,
  );

  Future<void> loadLalKitab({bool force = false}) => _slice(
    () => state.lalKitab,
    (v) => emit(state.copyWith(lalKitab: v)),
    () => _repo.lalKitab(profileId),
    force: force,
  );

  Future<void> loadVarshphal({bool force = false}) => _slice(
    () => state.varshphal,
    (v) => emit(state.copyWith(varshphal: v)),
    () => _repo.varshphal(profileId),
    force: force,
  );

  Future<void> loadTransits({bool force = false}) => _slice(
    () => state.transits,
    (v) => emit(state.copyWith(transits: v)),
    () => _repo.transits(profileId),
    force: force,
  );

  Future<void> loadYogas({bool force = false}) => _slice(
    () => state.yogas,
    (v) => emit(state.copyWith(yogas: v)),
    () => _repo.yogas(profileId),
    force: force,
  );

  Future<void> loadDoshas({bool force = false}) => _slice(
    () => state.doshas,
    (v) => emit(state.copyWith(doshas: v)),
    () => _repo.doshas(profileId),
    force: force,
  );

  Future<void> loadInsights({bool force = false}) => _slice(
    () => state.insights,
    (v) => emit(state.copyWith(insights: v)),
    () => _repo.insights(profileId),
    force: force,
  );

  Future<void> loadMood({bool force = false}) => _slice(
    () => state.mood,
    (v) => emit(state.copyWith(mood: v)),
    () => _repo.mood(profileId),
    force: force,
  );

  Future<void> loadRemedies({bool force = false}) => _slice(
    () => state.remedies,
    (v) => emit(state.copyWith(remedies: v)),
    () => _repo.remedies(profileId),
    force: force,
  );

  Future<void> loadBhava({bool force = false}) => _slice(
    () => state.bhava,
    (v) => emit(state.copyWith(bhava: v)),
    () => _repo.bhava(profileId),
    force: force,
  );

  Future<void> loadChartTypes({bool force = false}) => _slice(
    () => state.chartTypes,
    (v) => emit(state.copyWith(chartTypes: v)),
    () => _repo.chartTypes(profileId),
    force: force,
  );

  /// Load one divisional / bhava-chalit / transit chart. Each type caches
  /// independently in [KundaliState.charts]; `transit` always refetches (6h TTL
  /// on the server, but the "as of" clock moves).
  Future<void> loadChart(String type, {bool force = false}) async {
    final key = type.toLowerCase();
    final current = state.charts[key] ?? const AsyncValue<VargaChart>.idle();
    final fresh = force || key == 'transit';
    if (!fresh && (current.status == AsyncStatus.data || current.isLoading)) {
      return;
    }
    _writeChart(key, AsyncValue.loading(current.value));
    try {
      _writeChart(key, AsyncValue.data(await _repo.vargaChart(profileId, key)));
    } catch (e) {
      _writeChart(key, AsyncValue.error(friendlyError(e), current.value));
    }
  }

  void _writeChart(String key, AsyncValue<VargaChart> v) =>
      emit(state.copyWith(charts: {...state.charts, key: v}));

  /// The server writes reading prose in the user's language, so a language
  /// switch re-fetches every slice already loaded. Old values stay on screen
  /// until the new ones land.
  Future<void> reloadForLanguage() async {
    await Future.wait([
      if (state.overview.value != null) loadOverview(force: true),
      if (state.navamsa.value != null) loadNavamsa(force: true),
      if (state.dasha.value != null) loadDasha(force: true),
      if (state.allDashas.value != null) loadAllDashas(force: true),
      if (state.dashaNarrative.value != null) loadDashaNarrative(force: true),
      if (state.numerology.value != null) loadNumerology(force: true),
      if (state.sadeSati.value != null) loadSadeSati(force: true),
      if (state.avTransit.value != null) loadAvTransit(force: true),
      if (state.muhurta.value != null) loadMuhurta(force: true),
      if (state.jyotishUpaya.value != null) loadJyotishUpaya(force: true),
      if (state.lalKitab.value != null) loadLalKitab(force: true),
      if (state.varshphal.value != null) loadVarshphal(force: true),
      if (state.transits.value != null) loadTransits(force: true),
      if (state.yogas.value != null) loadYogas(force: true),
      if (state.doshas.value != null) loadDoshas(force: true),
      if (state.insights.value != null) loadInsights(force: true),
      if (state.remedies.value != null) loadRemedies(force: true),
      if (state.mood.value != null) loadMood(force: true),
      if (state.bhava.value != null) loadBhava(force: true),
      if (state.chartTypes.value != null) loadChartTypes(force: true),
      for (final e in state.charts.entries)
        if (e.value.value != null) loadChart(e.key, force: true),
    ]);
  }

  Future<void> refresh() async {
    emit(const KundaliState());
    await Future.wait([loadOverview(force: true), loadTransits(force: true)]);
  }

  Future<void> _slice<T>(
    AsyncValue<T> Function() read,
    void Function(AsyncValue<T>) write,
    Future<T> Function() fetch, {
    bool force = false,
  }) async {
    final current = read();
    if (!force && (current.status == AsyncStatus.data || current.isLoading)) {
      return;
    }
    write(AsyncValue.loading(current.value));
    try {
      write(AsyncValue.data(await fetch()));
    } catch (e) {
      write(AsyncValue.error(friendlyError(e), current.value));
    }
  }
}
