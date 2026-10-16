/// The astrologer's own store: setup, listings, and what customers ordered.
/// Lenient parsers — a missing field falls back instead of throwing.
library;

Map<String, dynamic> _map(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : const {};

List<Map<String, dynamic>> _maps(Object? v) => [
  for (final e in v as List? ?? const [])
    if (e is Map) e.cast<String, dynamic>(),
];

String _s(Object? v, [String fallback = '']) =>
    v == null ? fallback : (v is String ? v : '$v');

String? _sOrNull(Object? v) {
  final s = _s(v);
  return s.isEmpty ? null : s;
}

double? _num(Object? v) => v is num ? v.toDouble() : double.tryParse(_s(v));

int? _int(Object? v) => v is num ? v.toInt() : int.tryParse(_s(v));

DateTime? _date(Object? v) =>
    v == null ? null : DateTime.tryParse(_s(v))?.toLocal();

// --- store setup ------------------------------------------------------------------

/// `none` (not set up), `pending` (waiting for approval), `active`, `suspended`.
class StoreSetup {
  const StoreSetup({
    required this.status,
    this.enabled = true,
    this.displayName = '',
    this.description = '',
    this.address = const {},
  });

  factory StoreSetup.fromJson(Map<String, dynamic> j) => StoreSetup(
    status: _s(j['status'], 'none'),
    enabled: j['enabled'] != false,
    displayName: _s(j['display_name']),
    description: _s(j['description']),
    address: _map(j['address']).map((k, v) => MapEntry(k, _s(v))),
  );

  final String status;
  final bool enabled;
  final String displayName;
  final String description;
  final Map<String, String> address;

  bool get exists => status != 'none';
  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';
  bool get isSuspended => status == 'suspended';
}

// --- the listing form ---------------------------------------------------------------

class AttributeOption {
  const AttributeOption(this.key, this.label);
  final String key;
  final String label;
}

/// One describable property of a type ("Mukhi", "Origin"), and how it is entered.
class ListingAttribute {
  const ListingAttribute({
    required this.key,
    required this.name,
    required this.inputType,
    this.unit = '',
    this.helpText = '',
    this.required = false,
    this.options = const [],
  });

  factory ListingAttribute.fromJson(Map<String, dynamic> j) => ListingAttribute(
    key: _s(j['key']),
    name: _s(j['name']),
    inputType: _s(j['input_type'], 'text'),
    unit: _s(j['unit']),
    helpText: _s(j['help_text']),
    required: j['required'] == true,
    options: [
      for (final o in _maps(j['options']))
        AttributeOption(_s(o['key']), _s(o['label'], _s(o['key']))),
    ],
  );

  final String key;
  final String name;

  /// text | number | boolean | choice | multi_choice
  final String inputType;
  final String unit;
  final String helpText;
  final bool required;
  final List<AttributeOption> options;
}

class ListingType {
  const ListingType({
    required this.slug,
    required this.name,
    required this.fulfilment,
    this.attributes = const [],
  });

  factory ListingType.fromJson(Map<String, dynamic> j) => ListingType(
    slug: _s(j['slug']),
    name: _s(j['name']),
    fulfilment: _s(j['fulfilment'], 'physical'),
    attributes: [
      for (final a in _maps(j['attributes'])) ListingAttribute.fromJson(a),
    ],
  );

  final String slug;
  final String name;

  /// physical (shipped) | service (performed by the astrologer)
  final String fulfilment;
  final List<ListingAttribute> attributes;

  bool get isService => fulfilment == 'service';
  bool get isPhysical => fulfilment == 'physical';
}

class ListingCategory {
  const ListingCategory({required this.slug, required this.name, this.parent});
  final String slug;
  final String name;
  final String? parent;
}

/// `GET astro/store/catalog/options`.
class CatalogOptions {
  const CatalogOptions({
    this.enabled = true,
    this.types = const [],
    this.categories = const [],
    this.states = const [],
    this.maxImages = 8,
    this.currency = 'INR',
  });

  factory CatalogOptions.fromJson(Map<String, dynamic> j) => CatalogOptions(
    enabled: j['enabled'] != false,
    types: [for (final t in _maps(j['types'])) ListingType.fromJson(t)],
    categories: [
      for (final c in _maps(j['categories']))
        ListingCategory(
          slug: _s(c['slug']),
          name: _s(c['name']),
          parent: _sOrNull(c['parent']),
        ),
    ],
    states: [for (final s in j['states'] as List? ?? const []) _s(s)],
    maxImages: _int(j['max_images']) ?? 8,
    currency: _s(j['currency'], 'INR'),
  );

  final bool enabled;
  final List<ListingType> types;
  final List<ListingCategory> categories;
  final List<String> states;
  final int maxImages;
  final String currency;

  ListingType? typeOf(String slug) {
    for (final t in types) {
      if (t.slug == slug) return t;
    }
    return null;
  }

  /// "Rudraksha › 5 Mukhi" for a sub-category.
  String categoryLabel(String slug) {
    for (final c in categories) {
      if (c.slug != slug) continue;
      if (c.parent == null) return c.name;
      final parent = categories.where((p) => p.slug == c.parent).firstOrNull;
      return parent == null ? c.name : '${parent.name} › ${c.name}';
    }
    return slug;
  }
}

// --- a listing ------------------------------------------------------------------------

class ListingPhoto {
  const ListingPhoto({
    required this.id,
    required this.url,
    required this.thumb,
  });
  final int id;
  final String url;
  final String thumb;
}

class ChecklistItem {
  const ChecklistItem(this.code, this.message);
  final String code;
  final String message;
}

/// draft | in_review | published | archived
class MyListing {
  const MyListing({
    required this.id,
    required this.status,
    required this.typeSlug,
    required this.typeName,
    required this.fulfilment,
    required this.categorySlug,
    required this.categoryName,
    required this.title,
    this.subtitle = '',
    this.description = '',
    this.benefits = '',
    this.howToUse = '',
    this.attributes = const {},
    this.leadTimeDays,
    this.photos = const [],
    this.price,
    this.compareAt,
    this.currency = 'INR',
    this.tracksStock = false,
    this.stock,
    this.weightGrams = 0,
    this.soldCount = 0,
    this.reviewNote = '',
    this.submittedAt,
    this.publishedAt,
    this.checklist = const [],
    this.sentBackToReview = false,
  });

  factory MyListing.fromJson(Map<String, dynamic> j) {
    final type = _map(j['product_type']);
    final category = _map(j['category']);
    return MyListing(
      id: _s(j['id']),
      status: _s(j['status'], 'draft'),
      typeSlug: _s(type['slug']),
      typeName: _s(type['name']),
      fulfilment: _s(type['fulfilment'], 'physical'),
      categorySlug: _s(category['slug']),
      categoryName: _s(category['name']),
      title: _s(j['title']),
      subtitle: _s(j['subtitle']),
      description: _s(j['description']),
      benefits: _s(j['benefits']),
      howToUse: _s(j['how_to_use']),
      attributes: _map(j['attributes']),
      leadTimeDays: _int(j['lead_time_days']),
      photos: [
        for (final m in _maps(j['media']))
          ListingPhoto(
            id: _int(m['id']) ?? 0,
            url: _s(m['url']),
            thumb: _s(m['thumb'], _s(m['url'])),
          ),
      ],
      price: _num(j['price']),
      compareAt: _num(j['compare_at']),
      currency: _s(j['currency'], 'INR'),
      tracksStock: j['tracks_stock'] == true,
      stock: _int(j['stock']),
      weightGrams: _int(j['weight_grams']) ?? 0,
      soldCount: _int(j['sold_count']) ?? 0,
      reviewNote: _s(j['review_note']),
      submittedAt: _date(j['submitted_at']),
      publishedAt: _date(j['published_at']),
      checklist: [
        for (final c in _maps(j['checklist']))
          ChecklistItem(_s(c['code']), _s(c['message'])),
      ],
      sentBackToReview: j['sent_back_to_review'] == true,
    );
  }

  final String id;
  final String status;
  final String typeSlug;
  final String typeName;
  final String fulfilment;
  final String categorySlug;
  final String categoryName;
  final String title;
  final String subtitle;
  final String description;
  final String benefits;
  final String howToUse;
  final Map<String, dynamic> attributes;
  final int? leadTimeDays;
  final List<ListingPhoto> photos;
  final double? price;
  final double? compareAt;
  final String currency;
  final bool tracksStock;
  final int? stock;
  final int weightGrams;
  final int soldCount;

  /// What the team asked to change, when they sent it back.
  final String reviewNote;
  final DateTime? submittedAt;
  final DateTime? publishedAt;

  /// What is missing before it can be sent for review.
  final List<ChecklistItem> checklist;

  /// This save took a live listing off sale until the team looks again.
  final bool sentBackToReview;

  bool get isDraft => status == 'draft';
  bool get inReview => status == 'in_review';
  bool get isLive => status == 'published';
  bool get isService => fulfilment == 'service';
  bool get isPhysical => fulfilment == 'physical';
  bool get hasChangesRequested => isDraft && reviewNote.isNotEmpty;
  bool get outOfStock => tracksStock && (stock ?? 0) <= 0;
  String? get cover => photos.isEmpty ? null : photos.first.url;
}

// --- what customers ordered ------------------------------------------------------------

class SellerOrderLine {
  const SellerOrderLine({
    required this.title,
    this.variantName = '',
    this.quantity = 1,
    this.unitPrice,
    this.lineTotal,
    this.inputs = const {},
  });

  factory SellerOrderLine.fromJson(Map<String, dynamic> j) => SellerOrderLine(
    title: _s(j['product_title']),
    variantName: _s(j['variant_name']),
    quantity: _int(j['quantity']) ?? 1,
    unitPrice: _num(j['unit_price']),
    lineTotal: _num(j['line_total']),
    inputs: _map(j['inputs']),
  );

  final String title;
  final String variantName;
  final int quantity;
  final double? unitPrice;
  final double? lineTotal;

  /// What the customer filled in (ring size, names for a pooja …).
  final Map<String, dynamic> inputs;
}

class SellerShipment {
  const SellerShipment({
    this.courierName = '',
    this.awb = '',
    this.trackingUrl = '',
    this.status = '',
    this.shippedAt,
  });

  factory SellerShipment.fromJson(Map<String, dynamic> j) => SellerShipment(
    courierName: _s(j['courier_name']),
    awb: _s(j['awb']),
    trackingUrl: _s(j['tracking_url']),
    status: _s(j['status']),
    shippedAt: _date(j['shipped_at']),
  );

  final String courierName;
  final String awb;
  final String trackingUrl;
  final String status;
  final DateTime? shippedAt;
}

/// One customer's order, the part of it this store fulfils.
class SellerOrder {
  const SellerOrder({
    required this.id,
    required this.number,
    required this.status,
    required this.fulfilment,
    this.total,
    this.lines = const [],
    this.shipments = const [],
    this.address = const {},
    this.contactName = '',
    this.contactPhone = '',
    this.paidAt,
  });

  factory SellerOrder.fromJson(Map<String, dynamic> j) {
    final contact = _map(j['contact']);
    return SellerOrder(
      id: _s(j['id']),
      number: _s(j['number'], _s(j['order_number'])),
      status: _s(j['status']),
      fulfilment: _s(j['fulfilment'], 'physical'),
      total: _num(j['total']),
      lines: [for (final l in _maps(j['lines'])) SellerOrderLine.fromJson(l)],
      shipments: [
        for (final s in _maps(j['shipments'])) SellerShipment.fromJson(s),
      ],
      address: _map(j['shipping_address']).map((k, v) => MapEntry(k, _s(v))),
      contactName: _s(contact['name']),
      contactPhone: _s(contact['phone']),
      paidAt: _date(j['paid_at']),
    );
  }

  final String id;
  final String number;

  /// confirmed | processing | shipped | delivered | completed | cancelled | …
  final String status;
  final String fulfilment;
  final double? total;
  final List<SellerOrderLine> lines;
  final List<SellerShipment> shipments;
  final Map<String, String> address;
  final String contactName;
  final String contactPhone;
  final DateTime? paidAt;

  bool get canStart => status == 'confirmed';
  bool get canShip =>
      fulfilment == 'physical' &&
      (status == 'confirmed' || status == 'processing');
  bool get canCancel =>
      status == 'confirmed' ||
      status == 'processing' ||
      status == 'awaiting_approval';
  bool get isOpen => canStart || canShip || status == 'awaiting_approval';

  String get addressText => [
    address['name'],
    address['line1'],
    address['line2'],
    [
      address['city'],
      address['state'],
      address['postal_code'],
    ].where((p) => (p ?? '').isNotEmpty).join(', '),
  ].where((p) => (p ?? '').isNotEmpty).join('\n');
}

/// A service a customer booked: perform it, then share a photo or video.
class SellerBooking {
  const SellerBooking({
    required this.id,
    required this.title,
    required this.status,
    this.sankalp = const {},
    this.scheduledFor,
    this.performedAt,
    this.proofCount = 0,
  });

  factory SellerBooking.fromJson(Map<String, dynamic> j) => SellerBooking(
    id: _s(j['id']),
    title: _s(j['product_title']),
    status: _s(j['status']),
    sankalp: _map(j['sankalp']),
    scheduledFor: _date(j['scheduled_for']),
    performedAt: _date(j['performed_at']),
    proofCount: (j['proofs'] as List?)?.length ?? 0,
  );

  final String id;
  final String title;

  /// confirmed | performed | proof_uploaded | completed | cancelled
  final String status;

  /// Names, gotra and the rest the customer gave for the ritual.
  final Map<String, dynamic> sankalp;
  final DateTime? scheduledFor;
  final DateTime? performedAt;
  final int proofCount;

  bool get canMarkPerformed => status == 'confirmed';
  bool get canAddProof => status == 'confirmed' || status == 'performed';
  bool get isOpen => canMarkPerformed || canAddProof;
}
