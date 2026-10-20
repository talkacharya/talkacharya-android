import 'store_json.dart';

/// One suggestion while searching the delivery-address map.
class PlaceSuggestion {
  const PlaceSuggestion({
    required this.placeId,
    required this.title,
    required this.subtitle,
  });

  final String placeId;
  final String title;
  final String subtitle;

  factory PlaceSuggestion.fromJson(Json j) => PlaceSuggestion(
    placeId: jStr(j['place_id']),
    title: jStr(j['title']),
    subtitle: jStr(j['subtitle']),
  );
}

/// An address found on the map (a picked place or the pin's spot), already in
/// the address form's shape — `/app/store/places/{details,reverse}`.
class FoundPlace {
  const FoundPlace({
    this.line1 = '',
    this.line2 = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = 'IN',
    required this.latitude,
    required this.longitude,
    this.formatted = '',
  });

  final String line1;
  final String line2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final double latitude;
  final double longitude;
  final String formatted;

  bool get isEmpty => city.isEmpty && formatted.isEmpty;

  /// The bold line on the map card: the area, else the city.
  String get headline => line2.isNotEmpty
      ? line2.split(',').first.trim()
      : (line1.isNotEmpty ? line1 : city);

  factory FoundPlace.fromJson(Json j) => FoundPlace(
    line1: jStr(j['line1']),
    line2: jStr(j['line2']),
    city: jStr(j['city']),
    state: jStr(j['state']),
    postalCode: jStr(j['postal_code']),
    country: jStr(j['country'], 'IN'),
    latitude: jNum(j['latitude']),
    longitude: jNum(j['longitude']),
    formatted: jStr(j['formatted']),
  );
}
