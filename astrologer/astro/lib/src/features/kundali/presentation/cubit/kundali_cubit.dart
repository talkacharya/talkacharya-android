import 'package:astro_kundali/astro_kundali.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/async_value.dart';
import '../../data/kundali_repository.dart';

part 'kundali_state.dart';

/// One cubit per consultation kundali screen. Each tab triggers its own slice;
/// slices load, succeed and fail independently. Divisional / bhava-chalit /
/// transit charts cache per type in [KundaliState.charts].
class KundaliCubit extends Cubit<KundaliState> {
  KundaliCubit({required KundaliRepository repo, required this.consultationId})
    : _repo = repo,
      super(const KundaliState());

  final KundaliRepository _repo;
  final String consultationId;

  Future<void> loadOverview() => _slice(
    () => state.overview,
    (v) => emit(state.copyWith(overview: v)),
    () => _repo.overview(consultationId),
  );

  Future<void> loadChartTypes() => _slice(
    () => state.chartTypes,
    (v) => emit(state.copyWith(chartTypes: v)),
    () => _repo.chartTypes(consultationId),
  );

  Future<void> loadDasha() => _slice(
    () => state.dasha,
    (v) => emit(state.copyWith(dasha: v)),
    () => _repo.dasha(consultationId),
  );

  Future<void> loadAllDashas() => _slice(
    () => state.allDashas,
    (v) => emit(state.copyWith(allDashas: v)),
    () => _repo.allDashas(consultationId),
  );

  Future<void> loadDashaNarrative() => _slice(
    () => state.dashaNarrative,
    (v) => emit(state.copyWith(dashaNarrative: v)),
    () => _repo.dashaNarrative(consultationId),
  );

  Future<void> loadNumerology() => _slice(
    () => state.numerology,
    (v) => emit(state.copyWith(numerology: v)),
    () => _repo.numerology(consultationId),
  );

  Future<void> loadSadeSati() => _slice(
    () => state.sadeSati,
    (v) => emit(state.copyWith(sadeSati: v)),
    () => _repo.sadeSati(consultationId),
  );

  Future<void> loadAvTransit() => _slice(
    () => state.avTransit,
    (v) => emit(state.copyWith(avTransit: v)),
    () => _repo.avTransit(consultationId),
  );

  Future<void> loadMuhurta() => _slice(
    () => state.muhurta,
    (v) => emit(state.copyWith(muhurta: v)),
    () => _repo.muhurta(consultationId),
  );

  Future<void> loadJyotishUpaya() => _slice(
    () => state.jyotishUpaya,
    (v) => emit(state.copyWith(jyotishUpaya: v)),
    () => _repo.jyotishUpaya(consultationId),
  );

  Future<void> loadLalKitab() => _slice(
    () => state.lalKitab,
    (v) => emit(state.copyWith(lalKitab: v)),
    () => _repo.lalKitab(consultationId),
  );

  Future<void> loadVarshphal() => _slice(
    () => state.varshphal,
    (v) => emit(state.copyWith(varshphal: v)),
    () => _repo.varshphal(consultationId),
  );

  Future<void> loadYogas() => _slice(
    () => state.yogas,
    (v) => emit(state.copyWith(yogas: v)),
    () => _repo.yogas(consultationId),
  );

  Future<void> loadDoshas() => _slice(
    () => state.doshas,
    (v) => emit(state.copyWith(doshas: v)),
    () => _repo.doshas(consultationId),
  );

  Future<void> loadInsights() => _slice(
    () => state.insights,
    (v) => emit(state.copyWith(insights: v)),
    () => _repo.insights(consultationId),
  );

  Future<void> loadRemedies() => _slice(
    () => state.remedies,
    (v) => emit(state.copyWith(remedies: v)),
    () => _repo.remedies(consultationId),
  );

  Future<void> loadBhava() => _slice(
    () => state.bhava,
    (v) => emit(state.copyWith(bhava: v)),
    () => _repo.bhava(consultationId),
  );

  Future<void> loadTransits() => _slice(
    () => state.transits,
    (v) => emit(state.copyWith(transits: v)),
    () => _repo.transits(consultationId),
  );

  Future<void> loadAshtakavarga() => _slice(
    () => state.ashtakavarga,
    (v) => emit(state.copyWith(ashtakavarga: v)),
    () => _repo.ashtakavarga(consultationId),
  );

  Future<void> loadShadbala() => _slice(
    () => state.shadbala,
    (v) => emit(state.copyWith(shadbala: v)),
    () => _repo.shadbala(consultationId),
  );

  Future<void> loadKp() => _slice(
    () => state.kp,
    (v) => emit(state.copyWith(kp: v)),
    () => _repo.kp(consultationId),
  );

  Future<void> loadJaimini() => _slice(
    () => state.jaimini,
    (v) => emit(state.copyWith(jaimini: v)),
    () => _repo.jaimini(consultationId),
  );

  Future<void> loadChart(String type, {bool force = false}) async {
    final key = type.toLowerCase();
    final current = state.charts[key] ?? const AsyncValue<VargaChart>.idle();
    final fresh = force || key == 'transit';
    if (!fresh && (current.status == AsyncStatus.data || current.isLoading)) {
      return;
    }
    _writeChart(key, AsyncValue.loading(current.value));
    try {
      _writeChart(
        key,
        AsyncValue.data(await _repo.vargaChart(consultationId, key)),
      );
    } catch (e) {
      _writeChart(key, AsyncValue.error(e.toString(), current.value));
    }
  }

  void _writeChart(String key, AsyncValue<VargaChart> v) =>
      emit(state.copyWith(charts: {...state.charts, key: v}));

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
      write(AsyncValue.error(e.toString(), current.value));
    }
  }
}
