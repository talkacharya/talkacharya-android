import 'package:customr/src/features/home/data/models/home_promo.dart';
import 'package:customr/src/features/home/data/models/horoscope.dart';
import 'package:customr/src/features/home/data/models/live_stream_card.dart';
import 'package:customr/src/features/home/data/models/panchang.dart';
import 'package:customr/src/features/home/data/models/recharge_pack.dart';
import 'package:customr/src/features/home/data/models/wallet_balance.dart';
import 'package:customr/src/features/home/data/models/zodiac.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ZodiacSign', () {
    test('fromDate maps birthdays to the right sign', () {
      expect(ZodiacSign.fromDate(DateTime(1994, 8, 14)), ZodiacSign.leo);
      expect(ZodiacSign.fromDate(DateTime(2000, 1, 1)), ZodiacSign.capricorn);
      expect(ZodiacSign.fromDate(DateTime(2001, 3, 21)), ZodiacSign.aries);
      expect(ZodiacSign.fromDate(DateTime(2001, 3, 20)), ZodiacSign.pisces);
    });

    test('fromSlug is case-insensitive and accepts the label', () {
      expect(ZodiacSign.fromSlug('LEO'), ZodiacSign.leo);
      expect(ZodiacSign.fromSlug('scorpio'), ZodiacSign.scorpio);
      expect(ZodiacSign.fromSlug('nonsense'), isNull);
    });
  });

  group('Horoscope.fromArtifact', () {
    test('flattens the in-house payload shape', () {
      final h = Horoscope.fromArtifact(ZodiacSign.leo, {
        'generated_at': '2026-09-07T06:00:00Z',
        'payload': {
          'sign': 'leo',
          'prediction': {
            'general': 'A steady day.',
            'love': 'Communicate openly.',
            'career': 'Progress on a task.',
            'health': 'Rest well.',
            'luck': 'Good',
          },
        },
      });
      expect(h.general, 'A steady day.');
      expect(h.love, 'Communicate openly.');
      expect(h.luck, 'Good');
      expect(h.generatedAt, isNotNull);
    });

    test('falls back when the payload is empty', () {
      final h = Horoscope.fromArtifact(ZodiacSign.aries, const {});
      expect(h.general, isNotEmpty);
      expect(h.love, isNull);
    });

    test('handles a list-shaped prediction', () {
      final h = Horoscope.fromArtifact(ZodiacSign.virgo, {
        'payload': {
          'prediction': [
            {'general': 'Focus.', 'career': 'Push forward.'},
          ],
        },
      });
      expect(h.general, 'Focus.');
      expect(h.career, 'Push forward.');
    });
  });

  group('Panchang.fromArtifact', () {
    test('pulls names out of list/map elements and trims times', () {
      final p = Panchang.fromArtifact({
        'payload': {
          'tithi': [
            {'name': 'Shukla 5', 'paksha': 'Shukla'},
          ],
          'nakshatra': [
            {'name': 'Rohini'},
          ],
          'yoga': [
            {'name': 'Siddhi'},
          ],
          'sunrise': '06:12:00',
          'sunset': '18:44:00',
        },
      });
      expect(p.tithi, 'Shukla 5');
      expect(p.nakshatra, 'Rohini');
      expect(p.sunrise, '06:12');
      expect(p.sunset, '18:44');
      expect(p.isEmpty, isFalse);
    });

    test('empty payload -> isEmpty', () {
      expect(Panchang.fromArtifact(const {}).isEmpty, isTrue);
    });
  });

  group('LiveStreamCard.fromJson', () {
    test('reads public_id + viewer count', () {
      final s = LiveStreamCard.fromJson({
        'public_id': 's-1',
        'host_name': 'Acharya V',
        'status': 'live',
        'viewer_count': 42,
      });
      expect(s.id, 's-1');
      expect(s.hostName, 'Acharya V');
      expect(s.isLive, isTrue);
      expect(s.viewerCount, 42);
    });
  });

  group('WalletBalance', () {
    test('primary prefers the requested currency', () {
      final list = [
        WalletBalance.fromJson({
          'currency': 'INR',
          'available_balance': '1240.5',
        }),
        WalletBalance.fromJson({'currency': 'USD', 'available_balance': '10'}),
      ];
      expect(list.primary('USD').currency, 'USD');
      expect(list.primary('INR').available, 1240.5);
      expect(<WalletBalance>[].primary('INR').available, 0);
    });
  });

  group('RechargePack.suggestionsFor', () {
    test('builds a bonus ladder from the minimum', () {
      final packs = RechargePack.suggestionsFor(
        minRecharge: 100,
        currency: 'INR',
      );
      expect(packs.first.amount, 100);
      expect(packs.first.hasBonus, isFalse);
      expect(packs.last.hasBonus, isTrue);
      expect(packs.last.total, greaterThan(packs.last.amount));
    });
  });

  group('PromoSlide.fromJson', () {
    test('no media -> a rich card, tone assigned round-robin', () {
      final slide = PromoSlide.fromJson({
        'code': 'DIWALI',
        'title': 'Diwali bonus',
        'subtitle': 'Get 20% extra',
      }, index: 1);
      expect(slide, isA<RichPromo>());
      final rich = slide as RichPromo;
      expect(rich.id, 'DIWALI');
      expect(rich.cta, 'Claim');
      expect(rich.tone, PromoTone.values[1]);
    });

    test('image_url -> an image slide keeping the overlay copy', () {
      final slide = PromoSlide.fromJson({
        'id': 'p2',
        'title': 'New year, new stars',
        'image_url': 'https://cdn.example/promo.jpg',
        'deeplink': 'talkacharya://wallet',
      });
      expect(slide, isA<ImagePromo>());
      final img = slide as ImagePromo;
      expect(img.imageUrl, 'https://cdn.example/promo.jpg');
      expect(img.title, 'New year, new stars');
      expect(img.hasOverlay, isTrue);
      expect(img.deeplink, 'talkacharya://wallet');
    });

    test('video_url wins over an image, which becomes the poster', () {
      final slide = PromoSlide.fromJson({
        'id': 'p3',
        'video_url': 'https://cdn.example/promo.mp4',
        'image_url': 'https://cdn.example/poster.jpg',
      });
      expect(slide, isA<VideoPromo>());
      final vid = slide as VideoPromo;
      expect(vid.videoUrl, 'https://cdn.example/promo.mp4');
      expect(vid.posterUrl, 'https://cdn.example/poster.jpg');
    });

    test('media_type image but no url -> falls back to a rich card', () {
      final slide = PromoSlide.fromJson({
        'id': 'p4',
        'media_type': 'image',
        'title': 'Offer',
      });
      expect(slide, isA<RichPromo>());
    });
  });
}
