import 'package:astro/src/features/kundali/presentation/kundali_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const en = KT('en');
  const hi = KT('hi');

  bool devanagari(String s) => s.runes.any((r) => r >= 0x0900 && r <= 0x097F);

  test('English leaves canonical names alone and tidies the codes', () {
    expect(en.term('Saturn'), 'Saturn');
    expect(en.term('Purva Bhadrapada'), 'Purva Bhadrapada');
    expect(en.term('friend_sign'), "friend's sign");
    expect(en.h(7), 'H7');
  });

  test('Hindi names every planet, sign, nakshatra, yoga and dosha', () {
    const names = [
      'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu',
      'Ketu', 'Aries', 'Libra', 'Pisces', 'Ashwini', 'Purva Bhadrapada',
      'Revati', 'Sasa Yoga', 'Raja Yoga', 'Gajakesari Yoga', 'Mangal Dosha',
      'Kaal Sarpa Dosha', 'Sunday', 'Saturday', //
    ];
    for (final name in names) {
      expect(devanagari(hi.term(name)), isTrue, reason: name);
    }
  });

  test('Hindi translates the codes the engine sends', () {
    const codes = [
      'exalted', 'debilitated', 'own', 'moolatrikona', 'friend_sign',
      'great_friend_sign', 'neutral', 'enemy_sign', 'great_enemy_sign',
      'supportive', 'balanced', 'mixed', 'challenging', 'mild', 'moderate',
      'rising', 'peak', 'setting', 'kantaka', 'ashtama', 'moolank',
      'bhagyank', 'naamank', 'mind', 'heart', 'action', 'pacify', 'wealth',
      'mahapurusha', 'chandra', 'Atmakaraka', 'Bhramari', //
    ];
    for (final code in codes) {
      expect(devanagari(hi.term(code)), isTrue, reason: code);
    }
  });

  test('an unknown word passes through unchanged', () {
    expect(hi.term('Something new'), 'Something new');
    expect(hi.term(''), '');
  });

  test('lists and raw tables are translated item by item', () {
    expect(hi.terms(['Sun', 'Moon']), '${hi.term('Sun')}, ${hi.term('Moon')}');
    final row = hi.value({
      'sub_lord': 'Venus',
      'house': 7,
      'planets': ['Mars', 'Rahu'],
    });
    expect(row, contains(hi.term('Venus')));
    expect(row, contains(hi.term('Rahu')));
    expect(row, isNot(contains('sub_lord')));
  });

  test('chart copy follows the kundali language', () {
    expect(en.chartStrings.ascendant, 'Ascendant');
    expect(devanagari(hi.chartStrings.ascendant), isTrue);
    expect(devanagari(hi.chartStrings.planetName('Jupiter')), isTrue);
    expect(devanagari(hi.chartName('d9', 'Navamsha')), isTrue);
    expect(devanagari(hi.chartName('bhava_chalit', 'Bhava Chalit')), isTrue);
    expect(hi.chartName('d999', 'Unknown'), 'Unknown');
    expect(hi.tabs, hasLength(en.tabs.length));
  });

  test('house phrases read naturally in both languages', () {
    expect(en.nthHouse(7), 'the 7th house');
    expect(en.ordinal(2), '2nd');
    expect(devanagari(hi.nthHouse(7)), isTrue);
    expect(devanagari(hi.ordinal(12)), isTrue);
  });
}
