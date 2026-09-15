import 'package:flutter/material.dart';

/// Fixed colours for the nine grahas — consistent across the chart, legends,
/// planet rows and dasha rails.
const _colors = <String, Color>{
  'Sun': Color(0xFFE0362C),
  'Moon': Color(0xFF5B6472),
  'Mars': Color(0xFFC2410C),
  'Mercury': Color(0xFF16A34A),
  'Jupiter': Color(0xFFCA8A04),
  'Venus': Color(0xFFDB2777),
  'Saturn': Color(0xFF1E40AF),
  'Rahu': Color(0xFF6D28D9),
  'Ketu': Color(0xFF6B5B4B),
};

Color planetColor(String name) => _colors[name] ?? const Color(0xFF8A7B6F);

const planetOrder = [
  'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu',
];

String planetToken(String name) => switch (name) {
  'Sun' => 'Su',
  'Moon' => 'Mo',
  'Mars' => 'Ma',
  'Mercury' => 'Me',
  'Jupiter' => 'Ju',
  'Venus' => 'Ve',
  'Saturn' => 'Sa',
  'Rahu' => 'Ra',
  'Ketu' => 'Ke',
  _ => name.length >= 2 ? name.substring(0, 2) : name,
};
