/// DRF serialises DecimalFields as strings ("4.78"); accept either shape.
double toDouble(Object? v) => switch (v) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s) ?? 0,
  _ => 0,
};
