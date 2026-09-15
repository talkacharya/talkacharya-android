/// Lenient readers for the store payloads. Money arrives as decimal strings
/// (`"1200.00"`), ids as UUID strings; anything missing falls back instead of throwing.
library;

typedef Json = Map<String, dynamic>;

String jStr(Object? v, [String fallback = '']) =>
    v == null ? fallback : (v is String ? v : '$v');

String? jStrOrNull(Object? v) {
  if (v == null) return null;
  final s = v is String ? v : '$v';
  return s.isEmpty ? null : s;
}

double jNum(Object? v, [double fallback = 0]) {
  if (v is num) return v.toDouble();
  return double.tryParse('${v ?? ''}') ?? fallback;
}

double? jNumOrNull(Object? v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse('$v');
}

int jInt(Object? v, [int fallback = 0]) {
  if (v is num) return v.toInt();
  return int.tryParse('${v ?? ''}') ?? fallback;
}

int? jIntOrNull(Object? v) {
  if (v == null) return null;
  if (v is num) return v.toInt();
  return int.tryParse('$v');
}

bool jBool(Object? v, [bool fallback = false]) => v is bool ? v : fallback;

DateTime? jDate(Object? v) =>
    v == null ? null : DateTime.tryParse('$v')?.toLocal();

Json jMap(Object? v) =>
    v is Map ? v.cast<String, dynamic>() : <String, dynamic>{};

Json? jMapOrNull(Object? v) => v is Map ? v.cast<String, dynamic>() : null;

List<T> jList<T>(Object? v, T Function(Json) parse) => v is List
    ? [
        for (final e in v)
          if (e is Map) parse(e.cast<String, dynamic>()),
      ]
    : <T>[];

List<String> jStrings(Object? v) =>
    v is List ? [for (final e in v) '$e'] : const <String>[];
