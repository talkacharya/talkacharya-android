import 'package:equatable/equatable.dart';

import 'product.dart';
import 'store_json.dart';

class StoreCategory extends Equatable {
  const StoreCategory({
    required this.slug,
    required this.name,
    this.description = '',
    this.image,
    this.icon = '',
    this.parent,
    this.displayOrder = 0,
  });

  final String slug;
  final String name;
  final String description;
  final String? image;
  final String icon;
  final String? parent;
  final int displayOrder;

  factory StoreCategory.fromJson(Json j) => StoreCategory(
    slug: jStr(j['slug']),
    name: jStr(j['name']),
    description: jStr(j['description']),
    image: jStrOrNull(j['image']),
    icon: jStr(j['icon']),
    parent: jStrOrNull(j['parent']),
    displayOrder: jInt(j['display_order']),
  );

  @override
  List<Object?> get props => [slug, name, image];
}

class StoreCollection extends Equatable {
  const StoreCollection({
    required this.slug,
    required this.title,
    this.description = '',
    this.image,
    this.remedyKeys = const [],
    this.products = const [],
  });

  final String slug;
  final String title;
  final String description;
  final String? image;
  final List<String> remedyKeys;

  /// Filled only by the collection detail endpoint.
  final List<ProductCard> products;

  factory StoreCollection.fromJson(Json j) => StoreCollection(
    slug: jStr(j['slug']),
    title: jStr(j['title']),
    description: jStr(j['description']),
    image: jStrOrNull(j['image']),
    remedyKeys: jStrings(j['remedy_keys']),
    products: jList(j['products'], ProductCard.fromJson),
  );

  @override
  List<Object?> get props => [slug, title, products];
}

/// `GET /store/home`.
class StoreHome extends Equatable {
  const StoreHome({
    this.currency = 'INR',
    this.categories = const [],
    this.collections = const [],
    this.featured = const [],
    this.poojas = const [],
  });

  final String currency;
  final List<StoreCategory> categories;
  final List<StoreCollection> collections;
  final List<ProductCard> featured;
  final List<ProductCard> poojas;

  bool get isEmpty =>
      categories.isEmpty &&
      collections.isEmpty &&
      featured.isEmpty &&
      poojas.isEmpty;

  factory StoreHome.fromJson(Json j) => StoreHome(
    currency: jStr(j['currency'], 'INR'),
    categories: jList(j['categories'], StoreCategory.fromJson),
    collections: jList(j['collections'], StoreCollection.fromJson),
    featured: jList(j['featured'], ProductCard.fromJson),
    poojas: jList(j['poojas'], ProductCard.fromJson),
  );

  @override
  List<Object?> get props => [
    currency,
    categories,
    collections,
    featured,
    poojas,
  ];
}

class FacetOption extends Equatable {
  const FacetOption(this.value, this.label);
  final String value;
  final String label;

  factory FacetOption.fromJson(Json j) =>
      FacetOption(jStr(j['value']), jStr(j['label'], jStr(j['value'])));

  @override
  List<Object?> get props => [value, label];
}

/// A filter built from the admin's filterable attributes.
class FilterFacet extends Equatable {
  const FilterFacet({
    required this.key,
    required this.param,
    required this.name,
    this.inputType = 'choice',
    this.unit = '',
    this.options = const [],
  });

  final String key;

  /// Query-string key, e.g. `attr.mukhi`.
  final String param;
  final String name;
  final String inputType;
  final String unit;
  final List<FacetOption> options;

  bool get isChoice => options.isNotEmpty;

  factory FilterFacet.fromJson(Json j) => FilterFacet(
    key: jStr(j['key']),
    param: jStr(j['param'], 'attr.${jStr(j['key'])}'),
    name: jStr(j['name']),
    inputType: jStr(j['input_type'], 'choice'),
    unit: jStr(j['unit']),
    options: jList(j['options'], FacetOption.fromJson),
  );

  @override
  List<Object?> get props => [key, options];
}

/// One page of `GET /store/products` (limit / offset).
class ProductPage extends Equatable {
  const ProductPage({
    this.count = 0,
    this.items = const [],
    this.hasMore = false,
  });

  final int count;
  final List<ProductCard> items;
  final bool hasMore;

  factory ProductPage.fromJson(Json j) => ProductPage(
    count: jInt(j['count']),
    items: jList(j['results'], ProductCard.fromJson),
    hasMore: j['next'] != null,
  );

  @override
  List<Object?> get props => [count, items, hasMore];
}

/// Everything the product list can be filtered by. Mirrors the query string so a
/// deep link (`/store/products?category=rudraksha&attr.mukhi=5`) round-trips.
class ProductQuery extends Equatable {
  const ProductQuery({
    this.category,
    this.type,
    this.fulfilment,
    this.collection,
    this.remedy,
    this.seller,
    this.search = '',
    this.sort = '',
    this.featured = false,
    this.attributes = const {},
  });

  final String? category;
  final String? type;
  final String? fulfilment;
  final String? collection;
  final String? remedy;
  final String? seller;
  final String search;
  final String sort;
  final bool featured;

  /// `attr.<key>` → value.
  final Map<String, String> attributes;

  factory ProductQuery.fromParams(Map<String, String> p) => ProductQuery(
    category: _nonEmpty(p['category']),
    type: _nonEmpty(p['type']),
    fulfilment: _nonEmpty(p['fulfilment']),
    collection: _nonEmpty(p['collection']),
    remedy: _nonEmpty(p['remedy']),
    seller: _nonEmpty(p['seller']),
    search: p['q'] ?? '',
    sort: p['sort'] ?? '',
    featured: p['featured'] == '1' || p['featured'] == 'true',
    attributes: {
      for (final e in p.entries)
        if (e.key.startsWith('attr.') && e.value.isNotEmpty) e.key: e.value,
    },
  );

  static String? _nonEmpty(String? s) => (s == null || s.isEmpty) ? null : s;

  Map<String, String> toParams() => {
    'category': ?category,
    'type': ?type,
    'fulfilment': ?fulfilment,
    'collection': ?collection,
    'remedy': ?remedy,
    'seller': ?seller,
    if (search.trim().isNotEmpty) 'q': search.trim(),
    if (sort.isNotEmpty) 'sort': sort,
    if (featured) 'featured': '1',
    ...attributes,
  };

  int get activeFilterCount =>
      attributes.length +
      (type != null ? 1 : 0) +
      (fulfilment != null ? 1 : 0) +
      (remedy != null ? 1 : 0);

  ProductQuery copyWith({
    Object? category = _keep,
    Object? type = _keep,
    Object? fulfilment = _keep,
    Object? collection = _keep,
    Object? remedy = _keep,
    String? search,
    String? sort,
    bool? featured,
    Map<String, String>? attributes,
  }) => ProductQuery(
    category: identical(category, _keep) ? this.category : category as String?,
    type: identical(type, _keep) ? this.type : type as String?,
    fulfilment: identical(fulfilment, _keep)
        ? this.fulfilment
        : fulfilment as String?,
    collection: identical(collection, _keep)
        ? this.collection
        : collection as String?,
    remedy: identical(remedy, _keep) ? this.remedy : remedy as String?,
    seller: seller,
    search: search ?? this.search,
    sort: sort ?? this.sort,
    featured: featured ?? this.featured,
    attributes: attributes ?? this.attributes,
  );

  static const _keep = Object();

  @override
  List<Object?> get props => [
    category,
    type,
    fulfilment,
    collection,
    remedy,
    seller,
    search,
    sort,
    featured,
    attributes,
  ];
}
