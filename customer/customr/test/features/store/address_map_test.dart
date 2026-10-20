import 'package:customr/src/features/store/data/models/address.dart';
import 'package:customr/src/features/store/data/models/place.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the map pin is sent with six decimals and read back', () {
    const a = Address(
      name: 'Ravi',
      phone: '+919812345678',
      line1: 'B-12',
      city: 'Noida',
      state: 'Uttar Pradesh',
      postalCode: '201309',
      latitude: 28.62712345,
      longitude: 77.3716,
    );
    final json = a.toJson();
    expect(json['latitude'], '28.627123');
    expect(json['longitude'], '77.371600');

    final back = Address.fromJson({...json, 'latitude': '28.627123'});
    expect(back.hasPin, isTrue);
    expect(back.latitude, closeTo(28.627123, 1e-9));
  });

  test('an address typed without the map sends no pin', () {
    const a = Address(
      name: 'Ravi',
      phone: '9812345678',
      line1: '12 MG Road',
      city: 'Pune',
      state: 'Maharashtra',
      postalCode: '411001',
    );
    expect(a.toJson().containsKey('latitude'), isFalse);
  });

  test('a found place reads the form fields and a short headline', () {
    final f = FoundPlace.fromJson({
      'line1': '',
      'line2': 'Sector 62, Noida',
      'city': 'Noida',
      'state': 'Uttar Pradesh',
      'postal_code': '201309',
      'latitude': 28.6271,
      'longitude': 77.3716,
      'formatted': 'Sector 62, Noida, Uttar Pradesh 201309, India',
    });
    expect(f.headline, 'Sector 62');
    expect(f.postalCode, '201309');
    expect(f.isEmpty, isFalse);
  });
}
