import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/my_store_models.dart';

/// What the astrologer has typed into the listing form, kept apart from the
/// server's copy so nothing is lost: it is written to the phone a moment after
/// every change and to the server every half-minute (see `ListingWizardCubit`).

/// A short random id for an upload or a package row that has no server id yet.
String newKey() {
  final r = Random.secure();
  return List.generate(16, (_) => r.nextInt(16).toRadixString(16)).join();
}

/// One package of a service, as being edited.
class PackageDraft {
  const PackageDraft({
    required this.key,
    this.id = '',
    this.name = '',
    this.participants = 1,
    this.includes = '',
    this.price = '',
    this.mrp = '',
  });

  factory PackageDraft.fromListing(ListingPackage p) => PackageDraft(
    key: p.id,
    id: p.id,
    name: p.name,
    participants: p.participants,
    includes: p.includes,
    price: _plain(p.price),
    mrp: _plain(p.compareAt),
  );

  factory PackageDraft.fromJson(Map<String, dynamic> j) => PackageDraft(
    key: '${j['key'] ?? newKey()}',
    id: '${j['id'] ?? ''}',
    name: '${j['name'] ?? ''}',
    participants: (j['participants'] as num?)?.toInt() ?? 1,
    includes: '${j['includes'] ?? ''}',
    price: '${j['price'] ?? ''}',
    mrp: '${j['mrp'] ?? ''}',
  );

  /// Local identity, stable while editing (the server [id] once saved).
  final String key;
  final String id;
  final String name;
  final int participants;
  final String includes;
  final String price;
  final String mrp;

  PackageDraft copyWith({
    String? id,
    String? name,
    int? participants,
    String? includes,
    String? price,
    String? mrp,
  }) => PackageDraft(
    key: key,
    id: id ?? this.id,
    name: name ?? this.name,
    participants: participants ?? this.participants,
    includes: includes ?? this.includes,
    price: price ?? this.price,
    mrp: mrp ?? this.mrp,
  );

  Map<String, dynamic> toJson() => {
    'key': key,
    'id': id,
    'name': name,
    'participants': participants,
    'includes': includes,
    'price': price,
    'mrp': mrp,
  };

  Map<String, dynamic> toPayload() => {
    if (id.isNotEmpty) 'id': id,
    'name': name.trim(),
    'participants': participants,
    'includes': includes.trim(),
    'price': price.trim().isEmpty ? null : price.trim(),
    'compare_at': mrp.trim().isEmpty ? null : mrp.trim(),
  };
}

String _plain(double? v) => v == null
    ? ''
    : (v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2));

/// Everything the form holds, as plain strings the way it was typed.
class ListingDraft {
  const ListingDraft({
    this.kind = '',
    this.category = '',
    this.type = '',
    this.title = '',
    this.subtitle = '',
    this.description = '',
    this.benefits = '',
    this.howTo = '',
    this.attributes = const {},
    this.price = '',
    this.mrp = '',
    this.stock = '',
    this.weight = '',
    this.lead = '',
    this.packages = const [],
  });

  factory ListingDraft.fromListing(MyListing l) => ListingDraft(
    kind: l.isService ? 'service' : 'product',
    category: l.categorySlug,
    type: l.typeSlug,
    title: l.title,
    subtitle: l.subtitle,
    description: l.description,
    benefits: l.benefits,
    howTo: l.howToUse,
    attributes: Map.of(l.attributes),
    price: _plain(l.price),
    mrp: _plain(l.compareAt),
    stock: l.stock?.toString() ?? '',
    weight: l.weightGrams > 0 ? '${l.weightGrams}' : '',
    lead: l.leadTimeDays?.toString() ?? '',
    packages: [for (final p in l.packages) PackageDraft.fromListing(p)],
  );

  factory ListingDraft.fromJson(Map<String, dynamic> j) => ListingDraft(
    kind: '${j['kind'] ?? ''}',
    category: '${j['category'] ?? ''}',
    type: '${j['type'] ?? ''}',
    title: '${j['title'] ?? ''}',
    subtitle: '${j['subtitle'] ?? ''}',
    description: '${j['description'] ?? ''}',
    benefits: '${j['benefits'] ?? ''}',
    howTo: '${j['how_to'] ?? ''}',
    attributes: (j['attributes'] as Map?)?.cast<String, dynamic>() ?? const {},
    price: '${j['price'] ?? ''}',
    mrp: '${j['mrp'] ?? ''}',
    stock: '${j['stock'] ?? ''}',
    weight: '${j['weight'] ?? ''}',
    lead: '${j['lead'] ?? ''}',
    packages: [
      for (final p in j['packages'] as List? ?? const [])
        if (p is Map) PackageDraft.fromJson(p.cast<String, dynamic>()),
    ],
  );

  /// product | service
  final String kind;
  final String category;

  /// The product type: set from the category, asked only when it takes more
  /// than one ("which kind?").
  final String type;
  final String title;
  final String subtitle;
  final String description;
  final String benefits;
  final String howTo;
  final Map<String, dynamic> attributes;
  final String price;
  final String mrp;
  final String stock;
  final String weight;
  final String lead;
  final List<PackageDraft> packages;

  bool get isService => kind == 'service';

  ListingDraft copyWith({
    String? kind,
    String? category,
    String? type,
    String? title,
    String? subtitle,
    String? description,
    String? benefits,
    String? howTo,
    Map<String, dynamic>? attributes,
    String? price,
    String? mrp,
    String? stock,
    String? weight,
    String? lead,
    List<PackageDraft>? packages,
  }) => ListingDraft(
    kind: kind ?? this.kind,
    category: category ?? this.category,
    type: type ?? this.type,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    description: description ?? this.description,
    benefits: benefits ?? this.benefits,
    howTo: howTo ?? this.howTo,
    attributes: attributes ?? this.attributes,
    price: price ?? this.price,
    mrp: mrp ?? this.mrp,
    stock: stock ?? this.stock,
    weight: weight ?? this.weight,
    lead: lead ?? this.lead,
    packages: packages ?? this.packages,
  );

  Map<String, dynamic> toJson() => {
    'kind': kind,
    'category': category,
    'type': type,
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'benefits': benefits,
    'how_to': howTo,
    'attributes': attributes,
    'price': price,
    'mrp': mrp,
    'stock': stock,
    'weight': weight,
    'lead': lead,
    'packages': [for (final p in packages) p.toJson()],
  };

  /// What the server is sent. A draft goes up half-filled: the server only
  /// insists on everything when it is sent for review.
  Map<String, dynamic> toPayload({required bool creating}) {
    String? orNull(String v) => v.trim().isEmpty ? null : v.trim();
    return {
      if (creating && type.isNotEmpty) 'product_type': type,
      'category': category,
      'title': title.trim(),
      'subtitle': subtitle.trim(),
      'description': description.trim(),
      'benefits': benefits.trim(),
      'how_to_use': howTo.trim(),
      'attributes': attributes,
      'lead_time_days': orNull(lead),
      if (isService)
        'packages': [
          for (final p in packages)
            if (p.name.trim().isNotEmpty) p.toPayload(),
        ]
      else ...{
        'price': orNull(price),
        'compare_at': orNull(mrp),
        'stock': orNull(stock) ?? 0,
        'weight_grams': orNull(weight) ?? 0,
      },
    };
  }

  /// What a customer reads, to tell a content edit from a price one.
  String get contentKey => [
    title.trim(),
    subtitle.trim(),
    description.trim(),
    benefits.trim(),
    howTo.trim(),
    category,
    lead.trim(),
    jsonEncode(attributes),
    for (final p in packages) '${p.name}|${p.participants}|${p.includes}',
  ].join('\u0001');
}

/// A photo picked on the phone and not yet confirmed by the server.
class PendingPhoto {
  const PendingPhoto({required this.key, required this.path});

  factory PendingPhoto.fromJson(Map<String, dynamic> j) =>
      PendingPhoto(key: '${j['key']}', path: '${j['path']}');

  /// The upload's id (`client_key`), so a retry never makes a second copy.
  final String key;
  final String path;

  Map<String, dynamic> toJson() => {'key': key, 'path': path};
}

/// The form, on the phone: survives the app closing, a call, a dead network.
class ListingDraftStore {
  ListingDraftStore(this._prefs);

  final SharedPreferences _prefs;

  static String _slot(String? listingId) =>
      'listing_draft:${listingId ?? 'new'}';

  ({ListingDraft draft, List<PendingPhoto> photos, DateTime savedAt})? read(
    String? listingId,
  ) {
    final raw = _prefs.getString(_slot(listingId));
    if (raw == null) return null;
    try {
      final j = (jsonDecode(raw) as Map).cast<String, dynamic>();
      return (
        draft: ListingDraft.fromJson(
          (j['draft'] as Map).cast<String, dynamic>(),
        ),
        photos: [
          for (final p in j['photos'] as List? ?? const [])
            if (p is Map) PendingPhoto.fromJson(p.cast<String, dynamic>()),
        ],
        savedAt: DateTime.tryParse('${j['saved_at']}') ?? DateTime(2000),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> write(
    String? listingId,
    ListingDraft draft,
    List<PendingPhoto> photos,
  ) => _prefs.setString(
    _slot(listingId),
    jsonEncode({
      'draft': draft.toJson(),
      'photos': [for (final p in photos) p.toJson()],
      'saved_at': DateTime.now().toIso8601String(),
    }),
  );

  Future<void> clear(String? listingId) => _prefs.remove(_slot(listingId));

  /// The new-listing slot becomes the listing's own once the server made it.
  Future<void> move(String listingId) async {
    final raw = _prefs.getString(_slot(null));
    if (raw == null) return;
    await _prefs.setString(_slot(listingId), raw);
    await _prefs.remove(_slot(null));
  }
}
