import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

/// A geocoded place from `GET /app/places/search`.
@freezed
abstract class Place with _$Place {
  const factory Place({
    @JsonKey(name: 'place_id') required String placeId,
    required String name,
    required double latitude,
    required double longitude,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}
