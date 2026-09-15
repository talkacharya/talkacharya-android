part of 'horoscope_cubit.dart';

class HoroscopeState extends Equatable {
  const HoroscopeState({
    required this.sign,
    required this.span,
    this.reading = const AsyncValue.idle(),
  });

  final ZodiacSign sign;
  final HoroscopeSpan span;
  final AsyncValue<SignHoroscope> reading;

  HoroscopeState copyWith({
    ZodiacSign? sign,
    HoroscopeSpan? span,
    AsyncValue<SignHoroscope>? reading,
  }) => HoroscopeState(
    sign: sign ?? this.sign,
    span: span ?? this.span,
    reading: reading ?? this.reading,
  );

  @override
  List<Object?> get props => [sign, span, reading];
}
