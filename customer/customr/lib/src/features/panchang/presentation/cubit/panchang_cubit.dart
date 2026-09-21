import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/async_value.dart';
import '../../data/models/day_panchang.dart';
import '../../data/panchang_repository.dart';
import '../../../../core/network/friendly_error.dart';

/// The full panchang page: a place + a date → that day's panchang.
///
/// The place is the one the user picked last time, else the active birth
/// profile's city ([fallbackPlace]); with neither, the page asks for a city.
class PanchangCubit extends Cubit<PanchangState> {
  PanchangCubit({
    required PanchangRepository repo,
    PanchangPlace? fallbackPlace,
    DateTime? initialDate,
    DateTime Function()? clock,
  }) : _repo = repo,
       _fallback = fallbackPlace,
       _clock = clock ?? DateTime.now,
       super(
         PanchangState(
           date: _dateOnly(initialDate ?? (clock ?? DateTime.now)()),
         ),
       );

  final PanchangRepository _repo;
  final PanchangPlace? _fallback;
  final DateTime Function() _clock;
  int _generation = 0;

  /// How far either side of today the date strip lets you go (matches the API).
  static const maxDays = 400;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime get today => _dateOnly(_clock());

  Future<void> init() async {
    final place = await _repo.savedPlace() ?? _fallback;
    emit(state.copyWith(place: place, placeResolved: true));
    if (place != null) await load();
  }

  Future<void> load() async {
    final place = state.place;
    if (place == null) return;
    final gen = ++_generation;
    final cached = _repo.cached(place, state.date);
    emit(state.copyWith(day: AsyncValue.loading(cached)));
    try {
      final day = await _repo.day(place, state.date);
      if (gen != _generation) return;
      emit(state.copyWith(day: AsyncValue.data(day)));
    } catch (e) {
      if (gen != _generation) return;
      emit(state.copyWith(day: AsyncValue.error(friendlyError(e), cached)));
    }
  }

  Future<void> setDate(DateTime date) {
    final d = _dateOnly(date);
    if (d.difference(today).inDays.abs() > maxDays || d == state.date) {
      return Future.value();
    }
    emit(state.copyWith(date: d));
    return load();
  }

  Future<void> shiftDays(int days) => setDate(
    DateTime(state.date.year, state.date.month, state.date.day + days),
  );

  Future<void> setPlace(PanchangPlace place) async {
    emit(state.copyWith(place: place, placeResolved: true));
    await _repo.savePlace(place);
    await load();
  }
}

class PanchangState extends Equatable {
  const PanchangState({
    required this.date,
    this.place,
    this.placeResolved = false,
    this.day = const AsyncValue.idle(),
  });

  final DateTime date;
  final PanchangPlace? place;

  /// The saved / fallback place lookup has finished (so a null [place] really
  /// means "ask the user").
  final bool placeResolved;
  final AsyncValue<DayPanchang> day;

  bool get needsPlace => placeResolved && place == null;

  PanchangState copyWith({
    DateTime? date,
    PanchangPlace? place,
    bool? placeResolved,
    AsyncValue<DayPanchang>? day,
  }) => PanchangState(
    date: date ?? this.date,
    place: place ?? this.place,
    placeResolved: placeResolved ?? this.placeResolved,
    day: day ?? this.day,
  );

  @override
  List<Object?> get props => [date, place, placeResolved, day];
}
