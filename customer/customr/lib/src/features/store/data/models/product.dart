import 'package:equatable/equatable.dart';

import 'consult.dart';
import 'store_json.dart';

/// How an item reaches the customer — backend `ProductType.fulfilment`.
enum Fulfilment {
  physical,
  digital,
  service;

  static Fulfilment parse(String? s) => switch (s) {
    'digital' => digital,
    'service' => service,
    _ => physical,
  };
}

class SellerRef extends Equatable {
  const SellerRef({required this.code, this.name = '', this.kind = ''});

  final String code;
  final String name;
  final String kind;

  bool get isTemple => kind == 'temple';

  factory SellerRef.fromJson(Json j) => SellerRef(
    code: jStr(j['code']),
    name: jStr(j['name'] ?? j['display_name']),
    kind: jStr(j['kind']),
  );

  @override
  List<Object?> get props => [code, name, kind];
}

/// A listing tile (`ProductCardSerializer`).
class ProductCard extends Equatable {
  const ProductCard({
    required this.id,
    required this.slug,
    required this.title,
    this.subtitle = '',
    this.type = '',
    this.fulfilment = Fulfilment.physical,
    this.category = '',
    this.image,
    this.priceFrom,
    this.compareAt,
    this.ratingAvg = 0,
    this.ratingCount = 0,
    this.isFeatured = false,
    this.needsAstrologer = false,
    this.seller = const SellerRef(code: ''),
  });

  final String id;
  final String slug;
  final String title;
  final String subtitle;
  final String type;
  final Fulfilment fulfilment;
  final String category;
  final String? image;
  final double? priceFrom;
  final double? compareAt;
  final double ratingAvg;
  final int ratingCount;
  final bool isFeatured;

  /// `requires_astrologer_confirmation` — gemstones etc.
  final bool needsAstrologer;
  final SellerRef seller;

  bool get isService => fulfilment == Fulfilment.service;

  /// Whole-percent discount against MRP, or null when there is none.
  int? get discountPercent => discountOf(priceFrom, compareAt);

  factory ProductCard.fromJson(Json j) => ProductCard(
    id: jStr(j['id']),
    slug: jStr(j['slug']),
    title: jStr(j['title']),
    subtitle: jStr(j['subtitle']),
    type: jStr(j['type']),
    fulfilment: Fulfilment.parse(jStrOrNull(j['fulfilment'])),
    category: jStr(j['category']),
    image: jStrOrNull(j['image']),
    priceFrom: jNumOrNull(j['price_from']),
    compareAt: jNumOrNull(j['compare_at']),
    ratingAvg: jNum(j['rating_avg']),
    ratingCount: jInt(j['rating_count']),
    isFeatured: jBool(j['is_featured']),
    needsAstrologer: jBool(j['requires_astrologer_confirmation']),
    seller: SellerRef.fromJson(jMap(j['seller'])),
  );

  @override
  List<Object?> get props => [id, slug, title, priceFrom, compareAt, image];
}

int? discountOf(double? price, double? mrp) {
  if (price == null || mrp == null || mrp <= 0 || mrp <= price) return null;
  final pct = ((mrp - price) / mrp * 100).round();
  return pct >= 1 ? pct : null;
}

class ProductMedia extends Equatable {
  const ProductMedia({required this.url, this.kind = 'image', this.alt = ''});

  final String url;
  final String kind;
  final String alt;

  bool get isVideo => kind == 'video';

  factory ProductMedia.fromJson(Json j) => ProductMedia(
    url: jStr(j['url']),
    kind: jStr(j['kind'], 'image'),
    alt: jStr(j['alt']),
  );

  @override
  List<Object?> get props => [url, kind];
}

/// One described property ("Mukhi: 5", "Weight: 4.75 ct").
class AttributeValue extends Equatable {
  const AttributeValue({
    required this.key,
    required this.name,
    required this.display,
    this.unit = '',
  });

  final String key;
  final String name;
  final String display;
  final String unit;

  String get text => unit.isEmpty ? display : '$display $unit';

  factory AttributeValue.fromJson(Json j) {
    final d = j['display'];
    return AttributeValue(
      key: jStr(j['key']),
      name: jStr(j['name']),
      display: d is bool ? (d ? '✓' : '—') : jStr(d),
      unit: jStr(j['unit']),
    );
  }

  @override
  List<Object?> get props => [key, display];
}

class Certificate extends Equatable {
  const Certificate({
    required this.lab,
    required this.number,
    this.verifyUrl,
    this.file,
  });

  final String lab;
  final String number;
  final String? verifyUrl;
  final String? file;

  factory Certificate.fromJson(Json j) => Certificate(
    lab: jStr(j['lab']),
    number: jStr(j['number']),
    verifyUrl: jStrOrNull(j['verify_url']),
    file: jStrOrNull(j['file']),
  );

  @override
  List<Object?> get props => [lab, number];
}

class ProductVariant extends Equatable {
  const ProductVariant({
    required this.id,
    this.sku = '',
    this.name = '',
    this.price,
    this.compareAt,
    this.inStock = true,
    this.stockLeft,
    this.attributes = const [],
    this.participants = 1,
    this.isUnique = false,
    this.maxPerOrder,
    this.certificates = const [],
  });

  final String id;
  final String sku;
  final String name;
  final double? price;
  final double? compareAt;
  final bool inStock;

  /// Only sent when stock is low (≤ 5).
  final int? stockLeft;
  final List<AttributeValue> attributes;
  final int participants;
  final bool isUnique;
  final int? maxPerOrder;
  final List<Certificate> certificates;

  int? get discountPercent => discountOf(price, compareAt);

  /// Highest quantity the customer may pick for one line.
  int maxQuantity(int platformMax) {
    var max = platformMax;
    if (maxPerOrder != null && maxPerOrder! > 0 && maxPerOrder! < max) {
      max = maxPerOrder!;
    }
    if (isUnique) max = 1;
    if (stockLeft != null && stockLeft! < max) max = stockLeft!;
    return max < 1 ? 1 : max;
  }

  factory ProductVariant.fromJson(Json j) => ProductVariant(
    id: jStr(j['id']),
    sku: jStr(j['sku']),
    name: jStr(j['name']),
    price: jNumOrNull(j['price']),
    compareAt: jNumOrNull(j['compare_at']),
    inStock: jBool(j['in_stock'], true),
    stockLeft: jIntOrNull(j['stock_left']),
    attributes: jList(j['attributes'], AttributeValue.fromJson),
    participants: jInt(j['participants'], 1),
    isUnique: jBool(j['is_unique']),
    maxPerOrder: jIntOrNull(j['max_per_order']),
    certificates: jList(j['certificates'], Certificate.fromJson),
  );

  @override
  List<Object?> get props => [id, price, inStock, stockLeft];
}

/// A pooja date / slot (`EventSerializer`).
class ServiceEvent extends Equatable {
  const ServiceEvent({
    required this.id,
    this.title = '',
    this.venue = '',
    this.startsAt,
    this.bookingClosesAt,
    this.capacity,
    this.remaining,
    this.status = 'scheduled',
    this.livestreamUrl,
  });

  final String id;
  final String title;
  final String venue;
  final DateTime? startsAt;
  final DateTime? bookingClosesAt;
  final int? capacity;

  /// Seats left; null = unlimited.
  final int? remaining;
  final String status;
  final String? livestreamUrl;

  bool get isOpen =>
      status == 'scheduled' &&
      (bookingClosesAt == null || bookingClosesAt!.isAfter(DateTime.now())) &&
      (remaining == null || remaining! > 0);

  factory ServiceEvent.fromJson(Json j) => ServiceEvent(
    id: jStr(j['id']),
    title: jStr(j['title']),
    venue: jStr(j['venue']),
    startsAt: jDate(j['starts_at']),
    bookingClosesAt: jDate(j['booking_closes_at']),
    capacity: jIntOrNull(j['capacity']),
    remaining: jIntOrNull(j['remaining']),
    status: jStr(j['status'], 'scheduled'),
    livestreamUrl: jStrOrNull(j['livestream_url']),
  );

  @override
  List<Object?> get props => [id, startsAt, remaining, status];
}

/// Kind of a customer-input field (`Product.input_schema[].type`).
enum InputKind {
  text,
  textarea,
  number,
  date,
  choice,
  phone,
  email;

  static InputKind parse(String? s) => InputKind.values.firstWhere(
    (k) => k.name == s,
    orElse: () => InputKind.text,
  );
}

class InputChoice extends Equatable {
  const InputChoice(this.value, this.label);
  final String value;
  final String label;

  factory InputChoice.fromJson(Object? raw) {
    if (raw is Map) {
      final m = raw.cast<String, dynamic>();
      final v = jStr(m['value']);
      return InputChoice(v, jStr(m['label'], v));
    }
    return InputChoice('$raw', '$raw');
  }

  @override
  List<Object?> get props => [value, label];
}

/// One field of the dynamic form (sankalp names, gotra, ring size …).
class InputField extends Equatable {
  const InputField({
    required this.key,
    required this.label,
    this.kind = InputKind.text,
    this.required = false,
    this.perParticipant = false,
    this.maxLength,
    this.min,
    this.max,
    this.choices = const [],
    this.hint = '',
  });

  final String key;
  final String label;
  final InputKind kind;
  final bool required;

  /// One value per participant (a family pooja needs N names).
  final bool perParticipant;
  final int? maxLength;
  final double? min;
  final double? max;
  final List<InputChoice> choices;
  final String hint;

  factory InputField.fromJson(Json j) => InputField(
    key: jStr(j['key']),
    label: jStr(j['label'], jStr(j['key'])),
    kind: InputKind.parse(jStrOrNull(j['type'])),
    required: jBool(j['required']),
    perParticipant: jBool(j['per_participant']),
    maxLength: jIntOrNull(j['max_length']),
    min: jNumOrNull(j['min']),
    max: jNumOrNull(j['max']),
    choices: j['choices'] is List
        ? [for (final c in j['choices'] as List) InputChoice.fromJson(c)]
        : const [],
    hint: jStr(j['hint']),
  );

  @override
  List<Object?> get props => [key, kind, required, perParticipant];
}

class ProductPolicy extends Equatable {
  const ProductPolicy({
    this.returnable = false,
    this.returnWindowDays = 0,
    this.cancellable = true,
    this.madeToOrder = false,
    this.leadTimeDays = 0,
  });

  final bool returnable;
  final int returnWindowDays;
  final bool cancellable;
  final bool madeToOrder;
  final int leadTimeDays;

  factory ProductPolicy.fromJson(Json j) => ProductPolicy(
    returnable: jBool(j['returnable']),
    returnWindowDays: jInt(j['return_window_days']),
    cancellable: jBool(j['cancellable'], true),
    madeToOrder: jBool(j['made_to_order']),
    leadTimeDays: jInt(j['lead_time_days']),
  );

  @override
  List<Object?> get props => [returnable, returnWindowDays, madeToOrder];
}

/// Seller disclosure shown on the product page (E-Commerce Rules 2020).
class SellerInfo extends Equatable {
  const SellerInfo({
    required this.code,
    this.kind = '',
    this.displayName = '',
    this.legalName = '',
    this.address = const {},
    this.supportEmail = '',
    this.supportPhone = '',
    this.grievanceOfficer = const {},
    this.logo,
  });

  final String code;
  final String kind;
  final String displayName;
  final String legalName;
  final Json address;
  final String supportEmail;
  final String supportPhone;
  final Json grievanceOfficer;
  final String? logo;

  /// "12 MG Road, Jaipur, Rajasthan 302001" from whatever keys are present.
  String get addressLine => [
    for (final k in const ['line1', 'line2', 'city', 'state', 'postal_code'])
      if (jStr(address[k]).isNotEmpty) jStr(address[k]),
  ].join(', ');

  factory SellerInfo.fromJson(Json j) => SellerInfo(
    code: jStr(j['code']),
    kind: jStr(j['kind']),
    displayName: jStr(j['display_name'] ?? j['name']),
    legalName: jStr(j['legal_name']),
    address: jMap(j['address']),
    supportEmail: jStr(j['support_email']),
    supportPhone: jStr(j['support_phone']),
    grievanceOfficer: jMap(j['grievance_officer']),
    logo: jStrOrNull(j['logo']),
  );

  @override
  List<Object?> get props => [code, displayName];
}

/// The consult-before-buying block on a product page.
class ConsultBlock extends Equatable {
  const ConsultBlock({
    this.enabled = false,
    this.channels = const ['video'],
    this.required = false,
    this.cleared = false,
    this.latest,
  });

  final bool enabled;
  final List<String> channels;

  /// The purchase is locked until an astrologer recommends it.
  final bool required;

  /// The customer holds a live recommendation for this product.
  final bool cleared;
  final StoreConsult? latest;

  bool get blocksPurchase => required && !cleared;

  factory ConsultBlock.fromJson(Json j) => ConsultBlock(
    enabled: jBool(j['enabled']),
    channels: jStrings(j['channels']).isEmpty
        ? const ['video']
        : jStrings(j['channels']),
    required: jBool(j['required']),
    cleared: jBool(j['cleared']),
    latest: jMapOrNull(j['latest']) == null
        ? null
        : StoreConsult.fromJson(jMap(j['latest'])),
  );

  @override
  List<Object?> get props => [enabled, required, cleared, latest];
}

class ProductDetail extends Equatable {
  const ProductDetail({
    required this.card,
    this.description = '',
    this.benefits = '',
    this.howToUse = '',
    this.disclaimer = '',
    this.media = const [],
    this.attributes = const [],
    this.variants = const [],
    this.inputSchema = const [],
    this.serviceEventRequired = true,
    this.remedyTags = const [],
    this.countryOfOrigin = 'IN',
    this.manufacturer = const {},
    this.policy = const ProductPolicy(),
    this.events = const [],
    this.hsnSac = '',
    this.taxRate,
    this.seller = const SellerInfo(code: ''),
    this.consult = const ConsultBlock(),
  });

  final ProductCard card;
  final String description;
  final String benefits;
  final String howToUse;
  final String disclaimer;
  final List<ProductMedia> media;
  final List<AttributeValue> attributes;
  final List<ProductVariant> variants;
  final List<InputField> inputSchema;
  final bool serviceEventRequired;
  final List<String> remedyTags;
  final String countryOfOrigin;
  final Json manufacturer;
  final ProductPolicy policy;
  final List<ServiceEvent> events;
  final String hsnSac;
  final double? taxRate;
  final SellerInfo seller;
  final ConsultBlock consult;

  String get id => card.id;
  String get slug => card.slug;
  String get title => card.title;
  Fulfilment get fulfilment => card.fulfilment;
  bool get isService => card.isService;

  List<ProductMedia> get images =>
      media.where((m) => !m.isVideo && m.url.isNotEmpty).toList();

  factory ProductDetail.fromJson(Json j) {
    final tax = jMap(j['tax']);
    return ProductDetail(
      card: ProductCard.fromJson(j),
      description: jStr(j['description']),
      benefits: jStr(j['benefits']),
      howToUse: jStr(j['how_to_use']),
      disclaimer: jStr(j['disclaimer']),
      media: jList(j['media'], ProductMedia.fromJson),
      attributes: jList(j['attributes'], AttributeValue.fromJson),
      variants: jList(j['variants'], ProductVariant.fromJson),
      inputSchema: jList(j['input_schema'], InputField.fromJson),
      serviceEventRequired: jBool(j['service_event_required'], true),
      remedyTags: jStrings(j['remedy_tags']),
      countryOfOrigin: jStr(j['country_of_origin'], 'IN'),
      manufacturer: jMap(j['manufacturer']),
      policy: ProductPolicy.fromJson(jMap(j['policy'])),
      events: jList(j['events'], ServiceEvent.fromJson),
      hsnSac: jStr(tax['hsn_sac']),
      taxRate: jNumOrNull(tax['rate']),
      seller: SellerInfo.fromJson(jMap(j['seller'])),
      consult: ConsultBlock.fromJson(jMap(j['consult'])),
    );
  }

  @override
  List<Object?> get props => [card, variants, events, consult];
}
