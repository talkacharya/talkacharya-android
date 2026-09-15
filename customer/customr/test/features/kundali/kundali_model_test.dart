import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Kundali.fromArtifact reads the /kundli envelope', () {
    final k = Kundali.fromArtifact({
      'kind': 'kundli',
      'time_assumed': true,
      'payload': {
        'nakshatra': {'name': 'Ashwini', 'pada': 3, 'lord': 'Ketu'},
        'chandra_rasi': {'name': 'Aries'},
        'soorya_rasi': {'name': 'Cancer'},
        'lagna': {'name': 'Leo'},
        'planet_position': [
          {
            'name': 'Moon',
            'rasi': {'name': 'Aries', 'id': 1},
            'degree': 21.1,
            'house': 9,
            'is_retrograde': false,
            'nakshatra': {'name': 'Ashwini', 'pada': 3},
            'dignity': 'neutral',
          },
        ],
        'houses': [
          {
            'house': 1,
            'sign': 'Leo',
            'planets': ['Venus'],
          },
          {
            'house': 9,
            'sign': 'Aries',
            'planets': ['Moon'],
          },
        ],
        'mangal_dosha': {
          'has_dosha': true,
          'from': ['lagna'],
        },
        'yoga': [
          {
            'name': 'Gajakesari Yoga',
            'key': 'yoga.gajakesari',
            'description': 'Jupiter in a kendra',
          },
        ],
      },
    });

    expect(k.timeAssumed, isTrue);
    expect(k.moonSign, 'Aries');
    expect(k.lagnaSign, 'Leo');
    expect(k.nakshatra, 'Ashwini');
    expect(k.nakshatraPada, 3);
    expect(k.planet('Moon')?.house, 9);
    expect(k.planet('Moon')?.token, 'Mo');
    expect(k.houseForSign('Aries'), 9);
    expect(k.mangalDosha.hasDosha, isTrue);
    expect(k.mangalDosha.from, ['lagna']);
    expect(k.yogas.single.name, 'Gajakesari Yoga');
    expect(k.yogas.single.key, 'yoga.gajakesari');
  });

  test('Kundali.fromArtifact reads avakahada chakra + birth panchang', () {
    final k = Kundali.fromArtifact({
      'payload': {
        'nakshatra': {'name': 'Uttara Phalguni', 'pada': 3, 'lord': 'Sun'},
        'soorya_nakshatra': {'name': 'Punarvasu', 'pada': 2},
        'chandra_rasi': {'name': 'Virgo'},
        'soorya_rasi': {'name': 'Gemini'},
        'lagna': {'name': 'Cancer'},
        'avakahada': {
          'nakshatra_lord': 'Sun',
          'rasi_lord': 'Mercury',
          'varna': 'Vaishya',
          'vashya': 'Manava',
          'yoni': 'Cow',
          'gana': 'Manushya',
          'nadi': 'Aadi',
          'tara': 'Vipat',
          'tattva': 'Earth',
          'yunja': 'Madhya',
          'rasi_paya': 'Copper',
          'nakshatra_paya': 'Silver',
        },
        'panchang': {
          'vaara': 'Friday',
          'tithi': {'name': 'Shashthi', 'paksha': 'Shukla'},
          'nakshatra': {'name': 'Uttara Phalguni', 'pada': 3},
          'yoga': {'name': 'Parigha'},
          'karana': {'name': 'Taitila'},
          'sunrise': '05:25:37',
          'sunset': '19:08:25',
          'ishta_kala': {'ghati': 6, 'pala': 33, 'vipala': 26},
        },
      },
    });

    expect(k.sunNakshatra, 'Punarvasu');
    expect(k.sunNakshatraPada, 2);
    expect(k.chakra.varna, 'Vaishya');
    expect(k.chakra.yoni, 'Cow');
    expect(k.chakra.nadi, 'Aadi');
    expect(k.chakra.tara, 'Vipat');
    expect(k.chakra.rasiPaya, 'Copper');
    expect(k.panchang.vaara, 'Friday');
    expect(k.panchang.tithi, 'Shashthi');
    expect(k.panchang.paksha, 'Shukla');
    expect(k.panchang.yoga, 'Parigha');
    expect(k.panchang.karana, 'Taitila');
    expect(k.panchang.hasIshta, isTrue);
    expect(k.panchang.ishtaGhati, 6);
  });

  test('DashaTimeline nests antardashas and finds the current span', () {
    final now = DateTime.now();
    final d = DashaTimeline.fromArtifact({
      'payload': {
        'balance': {'lord': 'Moon', 'years': 6.3},
        'current': {'maha': 'Rahu', 'antar': 'Jupiter', 'pratyantar': 'Saturn'},
        'dasha_periods': [
          {
            'name': 'Rahu',
            'start': now.subtract(const Duration(days: 3650)).toIso8601String(),
            'end': now.add(const Duration(days: 3650)).toIso8601String(),
            'antardashas': [
              {
                'name': 'Jupiter',
                'start': now
                    .subtract(const Duration(days: 200))
                    .toIso8601String(),
                'end': now.add(const Duration(days: 200)).toIso8601String(),
              },
            ],
          },
        ],
      },
    });

    expect(d.currentMaha, 'Rahu');
    expect(d.balanceLord, 'Moon');
    expect(d.currentSpan?.lord, 'Rahu');
    expect(d.currentSpan?.children.single.lord, 'Jupiter');
    expect(d.currentSpan!.progress(now), closeTo(0.5, 0.02));
  });

  test('Transits reads Sade Sati flags', () {
    final t = Transits.fromArtifact({
      'payload': {
        'natal_moon_sign': 'Aries',
        'positions': [
          {
            'name': 'Saturn',
            'sign': 'Pisces',
            'house_from_moon': 12,
            'house_from_lagna': 8,
          },
        ],
        'sade_sati': {
          'active': true,
          'phase': 'rising',
          'saturn_house_from_moon': 12,
        },
        'small_panoti': {'active': false},
        'jupiter_transit': {'house_from_moon': 3, 'favourable': false},
      },
    });

    expect(t.sadeSatiActive, isTrue);
    expect(t.sadeSatiPhase, 'rising');
    expect(t.planet('Saturn')?.houseFromLagna, 8);
    expect(t.jupiterFavourable, isFalse);
  });

  test('VargaChart.fromArtifact reads a divisional chart', () {
    final vc = VargaChart.fromArtifact({
      'payload': {
        'chart_type': 'd9',
        'name': 'Navamsa (D9)',
        'signifies': 'Marriage, dharma, inner strength',
        'verified': true,
        'ascendant': {'sign': 'Libra', 'degree': 12.4, 'vargottama': true},
        'houses': [
          {
            'house': 1,
            'sign': 'Libra',
            'planets': ['Jupiter'],
          },
          {'house': 4, 'sign': 'Capricorn', 'planets': <String>[]},
        ],
        'planets': [
          {
            'name': 'Jupiter',
            'sign': 'Libra',
            'degree': 3.2,
            'dms': "03°12'00\"",
            'house': 1,
            'retrograde': false,
            'vargottama': true,
          },
        ],
      },
    });

    expect(vc.chartType, 'd9');
    expect(vc.isTransit, isFalse);
    expect(vc.ascendantSign, 'Libra');
    expect(vc.ascendantVargottama, isTrue);
    expect(vc.houses.first.planets, ['Jupiter']);
    expect(vc.planets.single.vargottama, isTrue);
    expect(vc.planets.single.dms, "03°12'00\"");
  });

  test('VargaChart.fromArtifact maps transit_planets onto house planets', () {
    final vc = VargaChart.fromArtifact({
      'payload': {
        'chart_type': 'transit',
        'name': 'Transit (Gochar)',
        'verified': true,
        'as_of': '2026-09-08T12:00:00+00:00',
        'ascendant': 'Leo',
        'houses': [
          {
            'house': 1,
            'sign': 'Leo',
            'natal_planets': ['Sun'],
            'transit_planets': ['Mars', 'Venus'],
          },
        ],
        'planets': [
          {
            'name': 'Mars',
            'sign': 'Leo',
            'degree': 5.0,
            'house_from_lagna': 1,
            'house_from_moon': 7,
            'conjunct_natal': ['Sun'],
          },
        ],
      },
    });

    expect(vc.isTransit, isTrue);
    expect(vc.ascendantSign, 'Leo');
    expect(vc.asOf, '2026-09-08T12:00:00+00:00');
    expect(vc.houses.single.planets, ['Mars', 'Venus']);
    expect(vc.planets.single.houseFromMoon, 7);
    expect(vc.planets.single.conjunctNatal, ['Sun']);
  });

  test('VargaChart.shiftedPlanets picks bhava-chalit movers', () {
    final vc = VargaChart.fromArtifact({
      'payload': {
        'chart_type': 'bhava_chalit',
        'name': 'Bhava Chalit',
        'houses': const [],
        'planets': [
          {
            'name': 'Mercury',
            'sign': 'Aries',
            'bhava': 2,
            'rasi_house': 1,
            'shifted': true,
          },
          {
            'name': 'Sun',
            'sign': 'Aries',
            'bhava': 1,
            'rasi_house': 1,
            'shifted': false,
          },
        ],
      },
    });

    expect(vc.isBhavaChalit, isTrue);
    expect(vc.shiftedPlanets.map((p) => p.name), ['Mercury']);
    expect(vc.shiftedPlanets.single.house, 2);
    expect(vc.shiftedPlanets.single.rasiHouse, 1);
  });

  test('ChartTypeInfo.fromMap defaults verified to true and reads varga', () {
    final d = ChartTypeInfo.fromMap({
      'type': 'd24',
      'name': 'D24',
      'varga': 24,
    });
    final bc = ChartTypeInfo.fromMap({
      'type': 'bhava_chalit',
      'name': 'Bhava Chalit',
    });
    final unver = ChartTypeInfo.fromMap({
      'type': 'd5',
      'name': 'D5',
      'varga': 5,
      'verified': false,
    });

    expect(d.varga, 24);
    expect(d.verified, isTrue);
    expect(bc.varga, isNull);
    expect(unver.verified, isFalse);
  });

  test(
    'DoshaReport.fromArtifact parses verdicts, reasons and cancellations',
    () {
      final report = DoshaReport.fromArtifact({
        'kind': 'doshas',
        'payload': {
          'count': 1,
          'present_keys': ['mangal'],
          'disclaimer': 'Structural only.',
          'doshas': [
            {
              'key': 'mangal',
              'name': 'Mangal Dosha',
              'present': true,
              'severity': 2,
              'net_severity': 1,
              'severity_label': 'moderate',
              'is_cancelled': false,
              'planets': ['Mars'],
              'houses': [7, 8],
              'references': ['lagna', 'moon'],
              'reasons': [
                {
                  'key': 'mangal.from_lagna',
                  'text': 'Mars in the 7th from the Lagna.',
                },
              ],
              'cancellations': [
                {
                  'key': 'mangal.cancel.jupiter',
                  'text': 'Jupiter aspects Mars.',
                  'applies': true,
                },
                {
                  'key': 'mangal.cancel.mars_dignity',
                  'text': 'Mars own sign.',
                  'applies': false,
                },
              ],
              'summary': 'Manglik from 2 references.',
            },
            {
              'key': 'kaal_sarpa',
              'name': 'Kaal Sarpa Dosha',
              'present': false,
              'severity': 0,
            },
          ],
        },
      });

      expect(report.count, 1);
      expect(report.present.map((d) => d.key), ['mangal']);
      expect(report.clear.map((d) => d.key), ['kaal_sarpa']);

      final mangal = report.present.single;
      expect(mangal.displaySeverity, 1); // net_severity
      expect(mangal.reasons.single.text, contains('7th'));
      expect(mangal.activeCancellations, hasLength(1));
      expect(mangal.activeCancellations.single.key, 'mangal.cancel.jupiter');
    },
  );

  test(
    'BhavaHouse.listFromArtifact reads int influence counts (not lists)',
    () {
      final houses = BhavaHouse.listFromArtifact({
        'kind': 'bhava',
        'payload': {
          'houses': [
            {
              'house': 1,
              'sign': 'Leo',
              'karaka': 'Sun',
              'lord': 'Sun',
              'lord_sign': 'Cancer',
              'lord_house': 12,
              'lord_dignity': 'neutral',
              'lord_retrograde': false,
              'occupants': ['Mercury'],
              'aspected_by': ['Saturn', 'Mars'],
              // backend sends these as counts, not arrays
              'benefic_influences': 1,
              'malefic_influences': 2,
              'net_influence': -1,
            },
          ],
        },
      });

      final h = houses.single;
      expect(h.house, 1);
      expect(h.occupants, ['Mercury']);
      expect(h.aspectedBy, ['Saturn', 'Mars']);
      expect(h.beneficCount, 1);
      expect(h.maleficCount, 2);
      expect(h.influenceTally, -1);
      expect(h.influences, ['Mercury', 'Saturn', 'Mars']);
    },
  );

  test('BhavaHouse tolerates influences arriving as a list', () {
    final h = BhavaHouse.fromMap({
      'house': 4,
      'benefic_influences': ['Jupiter', 'Venus'],
      'malefic_influences': ['Saturn'],
    });
    expect(h.beneficCount, 2);
    expect(h.maleficCount, 1);
  });

  test('OverviewReport.fromArtifact parses sections, tone and factors', () {
    final report = OverviewReport.fromArtifact({
      'kind': 'overview',
      'payload': {
        'disclaimer': 'General guidance, not a prediction.',
        'areas': ['personality', 'marriage'],
        'sections': [
          {
            'area': 'personality',
            'key': 'overview.personality',
            'title': 'Personality & Nature',
            'strength': 3,
            'tone': 'supportive',
            'summary': 'Rising sign Leo: warm, proud.',
            'factors': [
              {'key': 'overview.factor.lagna_sign', 'sign': 'Leo'},
              {
                'key': 'overview.factor.lagna_lord',
                'planet': 'Sun',
                'in_house': 10,
                'dignity': 'own',
                'strength': 3,
              },
            ],
          },
          {
            'area': 'marriage',
            'key': 'overview.marriage',
            'title': 'Marriage & Spouse',
            'strength': 1,
            'tone': 'mixed',
            'summary': 'Partnership is read from the 7th house.',
            'factors': [
              {'key': 'overview.factor.seventh_sign', 'sign': 'Aquarius'},
              {
                'key': 'overview.factor.karaka',
                'role': 'darakaraka',
                'planet': 'Saturn',
                'strength': 2,
              },
              {'key': 'overview.factor.disclaimer', 'scope': 'marriage'},
            ],
          },
        ],
      },
    });

    expect(report.sections, hasLength(2));
    expect(report.disclaimer, contains('not a prediction'));

    final personality = report.byArea('personality')!;
    expect(personality.tone, 'supportive');
    expect(personality.isMixed, isFalse);
    expect(personality.factors, hasLength(2));
    expect(
      KundaliInsights.factorText(personality.factors[1]),
      'Ascendant lord Sun in the 10th house (own sign)',
    );

    final marriage = report.byArea('marriage')!;
    expect(marriage.isMixed, isTrue);
    // the disclaimer marker factor is dropped from the reading lines
    expect(marriage.readingFactors, hasLength(2));
    expect(
      KundaliInsights.factorText(marriage.factors[1]),
      'Darakaraka (Jaimini): Saturn',
    );

    expect(KundaliInsights.title('marriage'), 'Marriage & Spouse');
    expect(KundaliInsights.toneWord('mixed'), 'Mixed');
  });

  test('RemedyReport.fromArtifact groups remedies and flags gated ones', () {
    final report = RemedyReport.fromArtifact({
      'kind': 'remedies',
      'payload': {
        'count': 3,
        'gated_note': 'Confirm gemstones with an astrologer.',
        'disclaimer': 'Do what fits your means.',
        'groups': [
          {
            'category': 'mantra',
            'items': [
              {
                'key': 'planet.saturn.mantra',
                'category': 'mantra',
                'title': 'Saturn beej mantra',
                'body': 'Chant 108 times on Saturday.',
                'gated': false,
                'source': 'traditional',
                'trigger_type': 'planet_weak',
                'trigger_value': 'saturn',
              },
              {
                'key': 'dosha.mangal.hanuman',
                'category': 'mantra',
                'title': 'Hanuman Chalisa',
                'body': 'Recite on Tuesdays.',
                'gated': false,
              },
            ],
          },
          {
            'category': 'gemstone',
            'items': [
              {
                'key': 'planet.saturn.gemstone',
                'category': 'gemstone',
                'title': 'Blue sapphire',
                'body': 'Worn on the middle finger.',
                'caution': 'Never wear without an astrologer.',
                'gated': true,
                'source': 'traditional',
              },
            ],
          },
        ],
      },
    });

    expect(report.count, 3);
    expect(report.groups.map((g) => g.category), ['mantra', 'gemstone']);
    expect(report.groups.first.items, hasLength(2));
    expect(report.hasGated, isTrue);
    expect(report.groups.last.items.single.gated, isTrue);
    expect(report.groups.last.items.single.caution, isNotEmpty);
    expect(RemedyCategoryInfo.isGated('gemstone'), isTrue);
    expect(RemedyCategoryInfo.isGated('mantra'), isFalse);
    expect(RemedyCategoryInfo.label('daan'), 'Daan & charity');
  });

  test('Prashna.fromMap reads the verdict, reasons and catalog', () {
    final p = Prashna.fromMap({
      'id': 'q1',
      'question': 'Will I get the job?',
      'category': 'job',
      'number': 137,
      'verdict': 'yes',
      'strength': 3,
      'answer': 'The horary leans towards yes.',
      'price_paid': '49.00',
      'currency': 'INR',
      'judgment': {
        'reasons': [
          {
            'key': 'prashna.decider',
            'text': 'The 10th cusp sub-lord is Jupiter.',
          },
          {'key': 'prashna.favour', 'text': 'It signifies houses 6, 10, 11.'},
        ],
      },
      'chart': {
        'ruling_planets': {'day_lord': 'Venus'},
      },
    });

    expect(p.verdict, 'yes');
    expect(p.strength, 3);
    expect(p.reasons, hasLength(2));
    expect(p.reasons.first.key, 'prashna.decider');
    expect(p.rulingPlanets['day_lord'], 'Venus');
    expect(PrashnaInfo.verdictLabel('no'), 'Leaning no');

    final cat = PrashnaCatalog.fromMap({
      'currency': 'INR',
      'price': '49',
      'wallet_balance': '120',
      'disclaimer': 'A pointer, not a promise.',
      'categories': [
        {'value': 'job', 'label': 'A job'},
        {'value': 'marriage', 'label': 'Marriage'},
      ],
    });
    expect(cat.canAfford, isTrue);
    expect(cat.priceValue, 49);
    expect(cat.categories.map((c) => c.value), ['job', 'marriage']);
  });

  test('DashaNarrative.fromArtifact reads the timeline and current period', () {
    final n = DashaNarrative.fromArtifact({
      'kind': 'dasha_narrative',
      'payload': {
        'disclaimer': 'Tendencies, not events.',
        'current': {'maha': 'Jupiter', 'antar': 'Saturn'},
        'timeline': [
          {
            'key': 'dasha.maha.jupiter',
            'level': 'maha',
            'lord': 'Jupiter',
            'start': '2020-01-01',
            'end': '2036-01-01',
            'tone': 'supportive',
            'strength': 3,
            'running': true,
            'summary': 'The Jupiter mahadasha turns towards growth.',
            'rules_houses': [2, 5],
            'lord_house': 9,
            'antardashas': [
              {
                'key': 'dasha.antar.jupiter.saturn',
                'level': 'antar',
                'lord': 'Saturn',
                'maha_lord': 'Jupiter',
                'start': '2034-01-01',
                'end': '2036-01-01',
                'summary': 'Saturn sub-period: discipline meets growth.',
              },
            ],
          },
        ],
      },
    });

    expect(n.currentMaha, 'Jupiter');
    expect(n.currentAntar, 'Saturn');
    expect(n.timeline.single.tone, 'supportive');
    expect(n.timeline.single.rulesHouses, [2, 5]);
    expect(n.mahaFor('Jupiter')?.summary, contains('growth'));
    expect(n.antarFor('Jupiter', 'Saturn')?.summary, contains('discipline'));
    expect(n.antarFor('Jupiter', 'Rahu'), isNull);
  });

  test('NumerologyReport.fromArtifact reads numbers and the Lo Shu grid', () {
    final r = NumerologyReport.fromArtifact({
      'kind': 'numerology',
      'payload': {
        'moolank': 5,
        'bhagyank': 9,
        'naamank': 6,
        'numbers': [
          {
            'key': 'numerology.number.5',
            'kind': 'moolank',
            'value': 5,
            'planet': 'Mercury',
            'summary': 'Quickness and trade.',
            'friendly': [1, 3],
            'unfriendly': <int>[],
            'days': ['Wednesday'],
            'colours': ['green'],
            'direction': 'North',
            'deity': 'Vishnu',
            'gemstone': {
              'stone': 'emerald',
              'gated': true,
              'note': 'Ask first.',
            },
          },
        ],
        'combination': {'summary': 'Same pull.'},
        'lo_shu': {
          'layout': [4, 9, 2, 3, 5, 7, 8, 1, 6],
          'counts': {'1': 2, '4': 2, '9': 2, '5': 0},
          'missing': [5],
          'repeated': [1, 4, 9],
          'lines': [
            {
              'key': 'numerology.loshu.line.heart',
              'name': 'heart',
              'numbers': [3, 5, 7],
              'present': <int>[],
              'status': 'weakness',
              'gloss': 'feeling',
            },
          ],
          'summary': 'Emphasised 1, 4, 9.',
        },
        'disclaimer': 'For reflection.',
      },
    });

    expect(r.moolank, 5);
    expect(r.naamank, 6);
    expect(r.numberFor('moolank')?.planet, 'Mercury');
    expect(r.numberFor('moolank')?.gemstone, 'emerald');
    expect(r.loShu.countOf(1), 2);
    expect(r.loShu.countOf(5), 0);
    expect(r.loShu.missing, [5]);
    expect(r.loShu.lines.single.status, 'weakness');
  });

  test('SadeSatiCalendar.fromArtifact reads phases and periods', () {
    final cal = SadeSatiCalendar.fromArtifact({
      'payload': {
        'natal_moon_sign': 'Aquarius',
        'current': {
          'key': 'sade_sati.phase.setting',
          'kind': 'sade_sati',
          'phase': 'setting',
          'sign': 'Pisces',
          'house_from_moon': 2,
          'start': '2025-01-01',
          'end': '2027-06-03',
          'running': true,
          'summary': 'Saturn in Pisces.',
        },
        'sade_sati_periods': [
          {
            'start': '2020-01-24',
            'end': '2027-06-03',
            'running': true,
            'signs': ['Capricorn', 'Aquarius', 'Pisces'],
            'phases': [
              {
                'key': 'sade_sati.phase.rising',
                'phase': 'rising',
                'start': '2020-01-24',
                'end': '2022-07-13',
                'summary': 'x',
              },
            ],
          },
        ],
        'dhaiya_periods': [
          {
            'key': 'dhaiya.phase.kantaka',
            'kind': 'dhaiya',
            'phase': 'kantaka',
            'start': '2030-04-17',
            'end': '2032-05-31',
            'summary': 'y',
          },
        ],
        'phases': [],
        'disclaimer': 'A dated map.',
      },
    });
    expect(cal.natalMoonSign, 'Aquarius');
    expect(cal.current?.phase, 'setting');
    expect(cal.current?.isSadeSati, isTrue);
    expect(cal.sadeSatiPeriods.single.signs.length, 3);
    expect(cal.dhaiyaPeriods.single.phase, 'kantaka');
  });

  test('AvTransitReading.fromArtifact reads bindus and ingresses', () {
    final r = AvTransitReading.fromArtifact({
      'payload': {
        'lagna_sign': 'Virgo',
        'natal_moon_sign': 'Aquarius',
        'transits': [
          {
            'key': 'av_transit.planet.saturn',
            'planet': 'Saturn',
            'sign': 'Pisces',
            'house_from_lagna': 7,
            'bindus': 5,
            'sarva_bindus': 30,
            'tone': 'supportive',
            'summary': 's',
          },
        ],
        'upcoming_ingresses': [
          {
            'planet': 'Jupiter',
            'sign': 'Leo',
            'date': '2026-10-31',
            'bindus': 6,
            'tone': 'supportive',
            'summary': 'i',
          },
        ],
        'disclaimer': 'd',
      },
    });
    expect(r.transits.single.bindus, 5);
    expect(r.transits.single.tone, 'supportive');
    expect(r.upcomingIngresses.single.planet, 'Jupiter');
  });

  test('MuhurtaDay.fromArtifact splits day/night choghadiya and horas', () {
    final d = MuhurtaDay.fromArtifact({
      'payload': {
        'available': true,
        'weekday': 'Thursday',
        'day_lord': 'Jupiter',
        'sunrise': '06:26',
        'sunset': '18:44',
        'choghadiya': [
          {
            'key': 'choghadiya.shubh',
            'period': 'day',
            'name': 'shubh',
            'quality': 'good',
            'start': '06:26',
            'end': '07:58',
          },
          {
            'key': 'choghadiya.amrit',
            'period': 'night',
            'name': 'amrit',
            'quality': 'good',
            'start': '19:00',
            'end': '20:30',
          },
        ],
        'horas': [
          {
            'key': 'hora.jupiter',
            'period': 'day',
            'lord': 'Jupiter',
            'personal': 'favourable',
            'start': '06:26',
            'end': '07:28',
          },
        ],
        'current': {
          'choghadiya': {'name': 'shubh', 'quality': 'good'},
          'hora': {'lord': 'Jupiter', 'personal': 'favourable'},
        },
        'best_windows': [
          {
            'start': '09:31',
            'end': '10:32',
            'hora_lord': 'Venus',
            'choghadiya': 'labh',
            'summary': 'w',
          },
        ],
        'disclaimer': 'g',
      },
    });
    expect(d.available, isTrue);
    expect(d.dayChoghadiya.length, 1);
    expect(d.nightChoghadiya.length, 1);
    expect(d.horas.single.personal, 'favourable');
    expect(d.currentHora?.lord, 'Jupiter');
    expect(d.bestWindows.single.horaLord, 'Venus');
  });

  test(
    'JyotishUpayaReport.fromArtifact gates every gemstone and rudraksha',
    () {
      final r = JyotishUpayaReport.fromArtifact({
        'payload': {
          'lagna_sign': 'Libra',
          'lagna_favourable': {
            'lagna_lord': 'Venus',
            'colours': ['white', 'pink'],
            'direction': 'South-East',
            'auspicious_day': 'Friday',
            'deity': 'Shukra / Lakshmi',
          },
          'strengthen': ['Saturn'],
          'pacify': ['Jupiter', 'Rahu', 'Ketu'],
          'priority_planets': [],
          'planets': [
            {
              'key': 'jyotish_upaya.planet.saturn',
              'planet': 'Saturn',
              'role': 'strengthen',
              'colours': ['dark blue'],
              'direction': 'West',
              'deity': 'Shani',
              'mantra': 'Om Shanaishcharaya Namah',
              'charity': 'black sesame',
              'gemstone': {
                'stone': 'Blue Sapphire',
                'gated': true,
                'metal': 'silver',
              },
              'rudraksha': {'mukhi': '7 mukhi', 'gated': true},
              'summary': 's',
            },
          ],
          'gate_notice': 'Confirm gemstones with an astrologer.',
          'disclaimer': 'd',
        },
      });
      expect(r.lagnaLord, 'Venus');
      expect(r.strengthen, ['Saturn']);
      final saturn = r.planets.single;
      expect(saturn.isStrengthen, isTrue);
      expect(saturn.gemstone, 'Blue Sapphire');
      expect(saturn.rudrakshaMukhi, '7 mukhi');
      expect(r.gateNotice, isNotEmpty);
    },
  );

  test('LalKitabReport.fromArtifact reads rins, manda and free totke', () {
    final r = LalKitabReport.fromArtifact({
      'payload': {
        'rins': [
          {
            'key': 'lal_kitab.rin.matri',
            'name': 'Matri Rin — debt of the mother',
            'planet': 'Moon',
            'present': true,
            'reasons': ['Moon is in the 6th house'],
            'remedy': 'Serve your mother; keep milk in the house.',
          },
          {
            'key': 'lal_kitab.rin.pitri',
            'name': 'Pitri Rin',
            'planet': 'Sun',
            'present': false,
            'reasons': <String>[],
            'remedy': 'Serve your father.',
          },
        ],
        'active_rins': [
          {
            'key': 'lal_kitab.rin.matri',
            'name': 'Matri Rin — debt of the mother',
            'planet': 'Moon',
            'present': true,
            'reasons': ['Moon is in the 6th house'],
            'remedy': 'Serve your mother; keep milk in the house.',
          },
        ],
        'manda_planets': [
          {
            'key': 'lal_kitab.manda.mars',
            'planet': 'Mars',
            'house': 6,
            'pakka_ghar': 3,
            'summary': 'Mars sits in the 6th house.',
            'remedy': 'Keep a sweet dish out for others.',
          },
        ],
        'remedies': [
          {
            'key': 'lal_kitab.rin.matri.remedy',
            'for': 'Matri Rin',
            'text': 'Serve your mother.',
          },
        ],
        'summary': 'Lal Kitab shows 1 active debt.',
        'disclaimer': 'A Lal Kitab reading.',
      },
    });
    expect(r.rins.length, 2);
    expect(r.activeRins.single.planet, 'Moon');
    expect(r.mandaPlanets.single.pakkaGhar, 3);
    expect(r.remedies.single.forWhat, 'Matri Rin');
  });

  test('Varshphal.fromArtifact reads muntha, year lord and tajika', () {
    final v = Varshphal.fromArtifact({
      'payload': {
        'year': 2026,
        'age': 36,
        'starts': '2026-06-15',
        'ends': '2027-06-15',
        'varsha_lagna': 'Capricorn',
        'muntha': {
          'sign': 'Libra',
          'house': 10,
          'lord': 'Venus',
          'theme': 'career, status and public work',
        },
        'year_lord': {
          'planet': 'Venus',
          'roles': ['muntha_lord'],
          'house': 7,
          'dignity': 'neutral',
        },
        'tajika': {'yoga': 'none', 'summary': 'Not in close aspect.'},
        'planets': [
          {
            'name': 'Sun',
            'sign': 'Gemini',
            'house': 6,
            'dignity': 'friend_sign',
          },
        ],
        'summary': 'Your 36th solar-return year.',
        'disclaimer': 'The Tajika annual chart.',
      },
    });
    expect(v.age, 36);
    expect(v.varshaLagna, 'Capricorn');
    expect(v.munthaHouse, 10);
    expect(v.yearLord, 'Venus');
    expect(v.yearLordRoles, ['muntha_lord']);
    expect(v.tajikaYoga, 'none');
    expect(v.planets.single.name, 'Sun');
  });

  test('DoshaReport.present sorts most-severe first', () {
    final report = DoshaReport.fromMap({
      'doshas': [
        {'key': 'a', 'present': true, 'severity': 1, 'net_severity': 1},
        {'key': 'b', 'present': true, 'severity': 3, 'net_severity': 3},
        {'key': 'c', 'present': true, 'severity': 2, 'net_severity': 2},
      ],
    });
    expect(report.present.map((d) => d.key), ['b', 'c', 'a']);
  });

  group('MangalDosha verdict (same as the Doshas screen)', () {
    test('active dosha is Manglik with severity', () {
      final md = MangalDosha.fromMap({
        'has_dosha': true,
        'status': 'manglik',
        'present': true,
        'is_cancelled': false,
        'severity_label': 'moderate',
        'from': ['lagna', 'moon'],
      });
      expect(md.isManglik, isTrue);
      expect(md.hasDosha, isTrue);
      expect(md.severityLabel, 'moderate');
      expect(md.from, ['lagna', 'moon']);
    });

    test('cancelled dosha is NOT Manglik', () {
      final md = MangalDosha.fromMap({
        'has_dosha': false,
        'status': 'cancelled',
        'present': true,
        'is_cancelled': true,
        'from': ['moon'],
      });
      expect(md.isManglik, isFalse);
      expect(md.hasDosha, isFalse);
      expect(md.isCancelledManglik, isTrue);
    });

    test('clear chart', () {
      final md = MangalDosha.fromMap({'has_dosha': false, 'status': 'clear'});
      expect(md.isManglik, isFalse);
      expect(md.isCancelledManglik, isFalse);
    });

    test('legacy payload without status falls back to has_dosha', () {
      expect(MangalDosha.fromMap({'has_dosha': true}).isManglik, isTrue);
      expect(MangalDosha.fromMap({'has_dosha': false}).isManglik, isFalse);
    });
  });
}
