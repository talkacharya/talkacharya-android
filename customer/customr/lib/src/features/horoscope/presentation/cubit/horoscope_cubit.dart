import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../../home/data/horoscope_sign_store.dart';
import '../../../home/data/models/zodiac.dart';
import '../../data/horoscope_repository.dart';
import '../../data/models/sign_horoscope.dart';

part 'horoscope_state.dart';

/// Owns the full horoscope screen: which sign, which span (yesterday … month),
/// and the reading for that pair. Changing the sign persists it in
/// [HoroscopeSignStore] so the home card follows.
class HoroscopeCubit extends Cubit<HoroscopeState> {
  HoroscopeCubit({
    required HoroscopeRepository repo,
    required HoroscopeSignStore signStore,
    required ZodiacSign initialSign,
    HoroscopeSpan initialSpan = HoroscopeSpan.today,
  }) : _repo = repo,
       _signStore = signStore,
       super(HoroscopeState(sign: initialSign, span: initialSpan));

  final HoroscopeRepository _repo;
  final HoroscopeSignStore _signStore;
  int _request = 0;

  Future<void> load({bool force = false}) async {
    final sign = state.sign;
    final span = state.span;
    final ticket = ++_request;

    final cached = force ? null : _repo.cached(sign, span);
    if (cached != null) {
      emit(state.copyWith(reading: AsyncValue.data(cached)));
      return;
    }
    emit(state.copyWith(reading: AsyncValue.loading(state.reading.value)));
    try {
      final h = await _repo.fetch(sign, span, force: force);
      if (ticket != _request || isClosed) return; // user moved on
      emit(state.copyWith(reading: AsyncValue.data(h)));
    } catch (e) {
      if (ticket != _request || isClosed) return;
      emit(state.copyWith(reading: AsyncValue.error(friendlyError(e))));
    }
  }

  Future<void> selectSign(ZodiacSign sign) async {
    if (sign == state.sign) return;
    // Drop the old sign's reading so its text never shows under the new sign.
    emit(state.copyWith(sign: sign, reading: const AsyncValue.loading()));
    unawaited(_signStore.set(sign));
    await load();
  }

  Future<void> selectSpan(HoroscopeSpan span) async {
    if (span == state.span) return;
    emit(state.copyWith(span: span, reading: const AsyncValue.loading()));
    await load();
  }
}
