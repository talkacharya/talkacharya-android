import 'package:equatable/equatable.dart';

import 'store_json.dart';

/// A saved delivery address (`/store/addresses`).
class Address extends Equatable {
  const Address({
    this.id = '',
    this.label = '',
    required this.name,
    required this.phone,
    required this.line1,
    this.line2 = '',
    this.landmark = '',
    required this.city,
    required this.state,
    this.stateCode = '',
    required this.postalCode,
    this.country = 'IN',
    this.gstin = '',
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String name;
  final String phone;
  final String line1;
  final String line2;
  final String landmark;
  final String city;
  final String state;
  final String stateCode;
  final String postalCode;
  final String country;
  final String gstin;
  final bool isDefault;

  bool get isSaved => id.isNotEmpty;

  /// "12 MG Road, Near park, Pune, Maharashtra 411001".
  String get singleLine => [
    line1,
    line2,
    landmark,
    city,
    '$state $postalCode'.trim(),
  ].where((s) => s.trim().isNotEmpty).join(', ');

  factory Address.fromJson(Json j) => Address(
    id: jStr(j['id']),
    label: jStr(j['label']),
    name: jStr(j['name']),
    phone: jStr(j['phone']),
    line1: jStr(j['line1']),
    line2: jStr(j['line2']),
    landmark: jStr(j['landmark']),
    city: jStr(j['city']),
    state: jStr(j['state']),
    stateCode: jStr(j['state_code']),
    postalCode: jStr(j['postal_code']),
    country: jStr(j['country'], 'IN'),
    gstin: jStr(j['gstin']),
    isDefault: jBool(j['is_default']),
  );

  Json toJson() => {
    'label': label,
    'name': name,
    'phone': phone,
    'line1': line1,
    'line2': line2,
    'landmark': landmark,
    'city': city,
    'state': state,
    'postal_code': postalCode,
    'country': country,
    'gstin': gstin,
    'is_default': isDefault,
  };

  Address copyWith({bool? isDefault}) => Address(
    id: id,
    label: label,
    name: name,
    phone: phone,
    line1: line1,
    line2: line2,
    landmark: landmark,
    city: city,
    state: state,
    stateCode: stateCode,
    postalCode: postalCode,
    country: country,
    gstin: gstin,
    isDefault: isDefault ?? this.isDefault,
  );

  /// Indian states and union territories, as the backend recognises them.
  static const indianStates = <String>[
    'Andaman and Nicobar Islands',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Ladakh',
    'Lakshadweep',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    line1,
    line2,
    landmark,
    city,
    state,
    postalCode,
    isDefault,
  ];
}
